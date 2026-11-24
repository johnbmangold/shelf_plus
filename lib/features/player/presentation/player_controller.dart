import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/database/app_database.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/network/abs_api_client.dart';
import 'package:shelf_plus/core/network/abs_api_models.dart';
import 'package:shelf_plus/core/network/abs_playback_models.dart';
import 'package:shelf_plus/core/network/abs_url_builder.dart';
import 'package:shelf_plus/core/socket/abs_socket_service.dart';
import 'package:shelf_plus/core/theme/dynamic_cover_theme_service.dart';
import 'package:shelf_plus/features/auth/data/auth_repository_impl.dart';
import 'package:shelf_plus/features/auth/presentation/auth_controller.dart';
import 'package:shelf_plus/features/downloads/presentation/download_controller.dart';
import 'package:shelf_plus/features/library/domain/library_models.dart';
import 'package:shelf_plus/features/player/domain/audio_player_engine.dart';
import 'package:shelf_plus/features/player/domain/book_timeline_mapper.dart';
import 'package:shelf_plus/features/player/domain/shake_detector.dart';
import 'package:shelf_plus/features/player/domain/sleep_timer_controller.dart';
import 'package:shelf_plus/features/player/domain/smart_rewind_policy.dart';
import 'package:shelf_plus/features/sync/presentation/offline_sync_controller.dart';
import 'package:uuid/uuid.dart';

/// Application-wide audio playback controller coordinating the audio engine,
/// server playback sessions, offline progress/history/bookmarks, smart rewind,
/// sleep timer, and dynamic player cover theming.
class PlayerController extends ChangeNotifier {
  /// Creates a [PlayerController].
  new({
    required this._apiClient,
    required this._database,
    required this._authController,
    required this._credentialsStore,
    required this._engine,
    required this._socketService,
    required this._coverThemeExtractor,
    required this._logger,
    this._downloadController,
    this._offlineSyncController,
    ShakeDetector? shakeDetector,
    this._smartRewindPolicy = const SmartRewindPolicy(),
    DateTime Function()? now,
    String Function()? deviceIdGenerator,
    this.syncInterval = const Duration(seconds: 15),
  }) : _shakeDetector = shakeDetector ?? SensorsShakeDetector(),
       _now = now ?? DateTime.now,
       _deviceIdGenerator = deviceIdGenerator ?? const Uuid().v4 {
    _sleepTimer = SleepTimerController(
      setVolume: _engine.setVolume,
      pausePlayback: pause,
      resumePlayback: resumeFromSleepGrace,
      onFadeOrGraceChanged: (active) {
        if (active) {
          _shakeDetector.start();
        } else {
          _shakeDetector.stop();
        }
      },
    );
    _sleepTimer.addListener(notifyListeners);
    _shakeSub = _shakeDetector.onShake.listen((_) {
      if (_sleepTimer.isFadeOrGraceActive) {
        unawaited(_sleepTimer.extend());
      }
    });
    _engineSub = _engine.stateStream.listen(_onEngineState);
    _skipNextSub = _engine.onSkipNextRequest.listen((_) {
      unawaited(nextChapter());
    });
    _skipPrevSub = _engine.onSkipPreviousRequest.listen((_) {
      unawaited(previousChapter());
    });
    _authController.addListener(_handleAuthChanged);
  }

  final AbsApiClient _apiClient;
  final AppDatabase _database;
  final AuthController _authController;
  final AuthCredentialsStore _credentialsStore;
  final AudioPlayerEngine _engine;
  final AbsSocketService _socketService;
  final CoverThemeExtractor _coverThemeExtractor;
  final AppLogger _logger;
  final DownloadController? _downloadController;
  final OfflineSyncController? _offlineSyncController;
  final ShakeDetector _shakeDetector;
  final SmartRewindPolicy _smartRewindPolicy;
  final DateTime Function() _now;
  final String Function() _deviceIdGenerator;

  /// Interval between periodic progress syncs while playing.
  final Duration syncInterval;

  late final SleepTimerController _sleepTimer;
  StreamSubscription<AudioEngineState>? _engineSub;
  StreamSubscription<void>? _skipNextSub;
  StreamSubscription<void>? _skipPrevSub;
  StreamSubscription<void>? _shakeSub;
  StreamSubscription<List<Chapter>>? _chaptersSub;
  StreamSubscription<List<Bookmark>>? _bookmarksSub;
  StreamSubscription<List<PlaybackHistoryEntry>>? _historySub;
  Timer? _syncTimer;

  BookSummary? _activeBook;
  BookTimelineMapper _mapper = BookTimelineMapper(const <TrackSegment>[]);
  List<ChapterInfo> _chapters = const <ChapterInfo>[];
  List<BookmarkEntry> _bookmarks = const <BookmarkEntry>[];
  List<PlaybackHistoryEntry> _history = const <PlaybackHistoryEntry>[];
  AbsPlaybackSessionDto? _activeSession;
  String? _deviceId;
  bool _isStarting = false;
  bool _smartRewindEnabled = true;
  int? _lastSmartRewindSeconds;
  String? _errorMessage;
  double _lastKnownPositionSec = 0;
  DateTime? _pausedAt;
  DateTime? _lastSyncAt;
  ColorScheme? _dynamicLightScheme;
  ColorScheme? _dynamicDarkScheme;
  Map<String, String> _activeHeaders = const <String, String>{};
  bool _disposed = false;

  /// Active sleep timer controller.
  SleepTimerController get sleepTimer => _sleepTimer;

  /// Currently loaded audiobook, or `null` when idle.
  BookSummary? get activeBook => _activeBook;

  /// Whether an audiobook is active in the player.
  bool get hasActiveBook => _activeBook != null;

  /// Latest audio engine snapshot.
  AudioEngineState get engineState => _engine.currentState;

  /// Whether audio is actively playing.
  bool get isPlaying => _engine.currentState.playing;

  /// Whether playback initialization or buffering is in progress.
  bool get isBusy =>
      _isStarting ||
      _engine.currentState.status == AudioPlaybackStatus.loading ||
      _engine.currentState.status == AudioPlaybackStatus.buffering;

  /// Active delivery method (`directPlay`, `transcode`, etc.).
  AbsPlayMethod? get playMethod => _activeSession?.playMethod;

  /// Active playback session identifier.
  String? get activeSessionId => _activeSession?.sessionId;

  /// Ordered chapters for the active book.
  List<ChapterInfo> get chapters => _chapters;

  /// Saved bookmarks for the active book.
  List<BookmarkEntry> get bookmarks => _bookmarks;

  /// Timestamped jump history for the active book (newest-first).
  List<PlaybackHistoryEntry> get history => _history;

  /// Current book-level position in seconds.
  double get positionSec {
    if (_mapper.segments.isEmpty) {
      return _lastKnownPositionSec;
    }
    final state = _engine.currentState;
    if (state.status == AudioPlaybackStatus.idle ||
        state.status == AudioPlaybackStatus.loading) {
      return _lastKnownPositionSec;
    }
    final mapped = _mapper.toBookPosition(
      trackIndex: state.trackIndex,
      trackPosition: state.trackPosition,
    );
    return mapped;
  }

  /// Total book duration in seconds.
  double get durationSec {
    final sessionDuration = _activeSession?.durationSec ?? 0;
    if (sessionDuration > 0) return sessionDuration;
    final bookDuration = _activeBook?.durationSec ?? 0;
    if (bookDuration > 0) return bookDuration;
    return _mapper.totalDurationSec;
  }

  /// Normalized progress in `[0.0, 1.0]`.
  double get progressRatio {
    final total = durationSec;
    if (total <= 0) return 0;
    return (positionSec / total).clamp(0.0, 1.0);
  }

  /// Active chapter at [positionSec], or `null`.
  ChapterInfo? get currentChapter =>
      BookTimelineMapper.activeChapter(_chapters, positionSec);

  /// Active chapter index at [positionSec], or `-1`.
  int get currentChapterIndex =>
      BookTimelineMapper.activeChapterIndex(_chapters, positionSec);

  /// Active playback speed multiplier.
  double get speed => _engine.currentState.speed;

  /// Whether silence skipping is enabled.
  bool get skipSilence => _engine.currentState.skipSilence;

  /// Whether silence skipping is supported on the current platform.
  bool get supportsSkipSilence => _engine.capabilities.supportsSkipSilence;

  /// Whether smart rewind on resume is enabled.
  bool get smartRewindEnabled => _smartRewindEnabled;

  /// Seconds rewound on the most recent resume, if smart rewind triggered.
  int? get lastSmartRewindSeconds => _lastSmartRewindSeconds;

  /// User-facing playback error, if any.
  String? get errorMessage =>
      _errorMessage ?? _engine.currentState.errorMessage;

  /// Cover-derived dynamic light [ColorScheme], if extracted.
  ColorScheme? get dynamicLightScheme => _dynamicLightScheme;

  /// Cover-derived dynamic dark [ColorScheme], if extracted.
  ColorScheme? get dynamicDarkScheme => _dynamicDarkScheme;

  /// Cover URL for [activeBook] against the connected server, if available.
  String? get activeCoverUrl {
    final book = _activeBook;
    final baseUrl = _authController.session?.baseUrl;
    if (book == null || baseUrl == null || !book.hasCover) return null;
    return AbsApiClient.buildCoverUrl(baseUrl: baseUrl, itemId: book.id);
  }

  /// Cached HTTP request headers for fetching authenticated cover artwork.
  Map<String, String> get activeCoverHeaders => _activeHeaders;

  /// Starts or resumes playback of [book], preferring Direct Play with
  /// automatic HLS transcoding fallback if Direct Play cannot be decoded.
  Future<void> playBook(
    BookSummary book, {
    List<ChapterInfo> chapters = const <ChapterInfo>[],
    double? startPositionSec,
  }) async {
    final session = _authController.session;
    if (session == null) {
      _errorMessage = 'Sign in to a server to start playback.';
      notifyListeners();
      return;
    }

    await _closeActiveServerSession();
    await _sleepTimer.cancel();

    _isStarting = true;
    _errorMessage = null;
    _lastSmartRewindSeconds = null;
    _pausedAt = null;
    _activeBook = book;
    if (chapters.isNotEmpty) {
      _chapters = chapters;
    } else {
      _chapters = const <ChapterInfo>[];
    }
    _lastKnownPositionSec = startPositionSec ?? book.progress?.positionSec ?? 0;
    _dynamicLightScheme = null;
    _dynamicDarkScheme = null;
    notifyListeners();

    await _bindItemStreams(session.serverId, book.id);

    try {
      final headers = await _credentialsStore.loadActiveRequestHeaders();
      _activeHeaders = headers;
      final deviceId = _deviceId ??= _deviceIdGenerator();
      final coverUrl = book.hasCover
          ? AbsApiClient.buildCoverUrl(
              baseUrl: session.baseUrl,
              itemId: book.id,
            )
          : null;
      if (coverUrl != null) {
        unawaited(_extractDynamicSchemes(coverUrl, headers));
      }

      final localTracks = await _downloadController?.resolveLocalTracks(
        session.serverId,
        book.id,
      );
      if (localTracks != null && localTracks.isNotEmpty) {
        final totalLocalDur = localTracks.fold<double>(
          0,
          (sum, t) => sum + t.durationSec,
        );
        final initialResumeSec =
            startPositionSec ?? book.progress?.positionSec ?? 0;
        final playbackSession = AbsPlaybackSessionDto(
          sessionId: 'local-${book.id}',
          libraryItemId: book.id,
          playMethod: AbsPlayMethod.local,
          startTimeSec: initialResumeSec,
          currentTimeSec: initialResumeSec,
          durationSec: totalLocalDur > 0 ? totalLocalDur : book.durationSec,
          audioTracks: <AbsAudioTrackDto>[
            for (final t in localTracks)
              AbsAudioTrackDto(
                index: t.trackIndex,
                startOffsetSec: t.startOffsetSec,
                durationSec: t.durationSec,
                contentUrl: Uri.file(t.localPath).toString(),
                title: t.title,
              ),
          ],
        );
        final segments = localTracks
            .map(
              (t) => TrackSegment(
                index: t.trackIndex,
                startOffsetSec: t.startOffsetSec,
                durationSec: t.durationSec,
              ),
            )
            .toList(growable: false);
        final mapper = BookTimelineMapper(segments);
        final target = mapper.toTrackPosition(initialResumeSec);
        final engineTracks = localTracks
            .map(
              (t) => AudioEngineTrack(
                id: 'local_${book.id}_${t.trackIndex}',
                uri: Uri.file(t.localPath),
                startOffsetSec: t.startOffsetSec,
                durationSec: t.durationSec,
                title: t.title,
              ),
            )
            .toList(growable: false);

        await _engine.loadBook(
          metadata: AudioBookMetadata(
            itemId: book.id,
            title: book.title,
            author: book.authorsDisplay,
            durationSec: playbackSession.durationSec,
            coverUri: coverUrl != null ? Uri.parse(coverUrl) : null,
            coverHeaders: headers,
          ),
          tracks: engineTracks,
          initialTrackIndex: target.trackIndex,
          initialTrackPosition: target.trackPosition,
        );
        _mapper = mapper;
        _activeSession = playbackSession;
        _lastKnownPositionSec = initialResumeSec;
        _lastSyncAt = _now();
        await _engine.play();
        _startSyncTimer();
        await _recordHistory(
          serverId: session.serverId,
          itemId: book.id,
          positionSec: _lastKnownPositionSec,
          reason: 'play',
        );
        await _persistLocalProgress(
          serverId: session.serverId,
          itemId: book.id,
          positionSec: _lastKnownPositionSec,
        );
        return;
      }

      var playbackSession = await _apiClient.startPlaybackSession(
        baseUrl: session.baseUrl,
        itemId: book.id,
        deviceId: deviceId,
      );

      final initialResumeSec =
          startPositionSec ??
          book.progress?.positionSec ??
          playbackSession.currentTimeSec;

      try {
        await _loadSessionIntoEngine(
          playbackSession: playbackSession,
          book: book,
          baseUrl: session.baseUrl,
          headers: headers,
          coverUrl: coverUrl,
          startPositionSec: initialResumeSec,
        );
      } on Object catch (directError, stackTrace) {
        if (playbackSession.isHls) rethrow;
        _logger.warning(
          'Direct play failed for ${book.id}; falling back to HLS',
          scope: 'player',
          error: directError,
          stackTrace: stackTrace,
        );
        await _safeCloseSession(
          baseUrl: session.baseUrl,
          playbackSession: playbackSession,
          currentTimeSec: initialResumeSec,
        );
        playbackSession = await _apiClient.startPlaybackSession(
          baseUrl: session.baseUrl,
          itemId: book.id,
          deviceId: deviceId,
          forceDirectPlay: false,
        );
        await _loadSessionIntoEngine(
          playbackSession: playbackSession,
          book: book,
          baseUrl: session.baseUrl,
          headers: headers,
          coverUrl: coverUrl,
          startPositionSec: initialResumeSec,
        );
      }

      _activeSession = playbackSession;
      _socketService.registerSelfSessionId(playbackSession.sessionId);
      _lastKnownPositionSec = initialResumeSec;
      _lastSyncAt = _now();
      await _engine.play();
      _startSyncTimer();

      await _recordHistory(
        serverId: session.serverId,
        itemId: book.id,
        positionSec: _lastKnownPositionSec,
        reason: 'play',
      );
      await _persistLocalProgress(
        serverId: session.serverId,
        itemId: book.id,
        positionSec: _lastKnownPositionSec,
      );
    } on Object catch (err, stackTrace) {
      _logger.warning(
        'Unable to start playback for ${book.id}',
        scope: 'player',
        error: err,
        stackTrace: stackTrace,
      );
      _errorMessage = err is AbsApiException && err.message != null
          ? err.message
          : 'Could not start audio playback.';
    } finally {
      _isStarting = false;
      if (!_disposed) {
        notifyListeners();
      }
    }
  }

  Future<void> _loadSessionIntoEngine({
    required AbsPlaybackSessionDto playbackSession,
    required BookSummary book,
    required String baseUrl,
    required Map<String, String> headers,
    required String? coverUrl,
    required double startPositionSec,
  }) async {
    final normalizedBase = AbsUrlBuilder.normalizeBaseUrl(baseUrl);
    final segments = playbackSession.audioTracks
        .map(
          (t) => TrackSegment(
            index: t.index,
            startOffsetSec: t.startOffsetSec,
            durationSec: t.durationSec,
          ),
        )
        .toList(growable: false);
    final mapper = BookTimelineMapper(segments);
    final target = mapper.toTrackPosition(startPositionSec);

    final tracks = playbackSession.audioTracks
        .map(
          (t) => AudioEngineTrack(
            id: '${playbackSession.sessionId}_${t.index}',
            uri: Uri.parse(AbsUrlBuilder.resolve(normalizedBase, t.contentUrl)),
            startOffsetSec: t.startOffsetSec,
            durationSec: t.durationSec,
            title: t.title,
            headers: headers,
          ),
        )
        .toList(growable: false);

    await _engine.loadBook(
      metadata: AudioBookMetadata(
        itemId: book.id,
        title: book.title,
        author: book.authorsDisplay,
        durationSec: playbackSession.durationSec > 0
            ? playbackSession.durationSec
            : book.durationSec,
        coverUri: coverUrl != null ? Uri.parse(coverUrl) : null,
        coverHeaders: headers,
      ),
      tracks: tracks,
      initialTrackIndex: target.trackIndex,
      initialTrackPosition: target.trackPosition,
    );
    _mapper = mapper;
  }

  /// Toggles play/pause, applying [SmartRewindPolicy] when resuming from pause.
  Future<void> togglePlayPause() async {
    if (!hasActiveBook) return;
    if (isPlaying) {
      await pause();
      return;
    }

    final pausedAt = _pausedAt;
    _pausedAt = null;
    if (pausedAt != null && _smartRewindEnabled) {
      final pauseDuration = _now().difference(pausedAt);
      final rewind = _smartRewindPolicy.rewindDurationForPause(
        pauseDuration,
        isEnabled: _smartRewindEnabled,
      );
      if (rewind > Duration.zero) {
        final targetSec = _smartRewindPolicy.computeResumePositionSec(
          currentPositionSec: positionSec,
          pauseDuration: pauseDuration,
          isEnabled: _smartRewindEnabled,
        );
        _lastSmartRewindSeconds = rewind.inSeconds;
        await seekToBookPosition(targetSec, historyReason: 'rewind');
      } else {
        _lastSmartRewindSeconds = null;
      }
    }

    _lastSyncAt = _now();
    await _engine.play();
    _startSyncTimer();
    notifyListeners();
  }

  /// Resumes playback when extended during the sleep timer's grace window.
  Future<void> resumeFromSleepGrace() async {
    if (!hasActiveBook || isPlaying) return;
    _pausedAt = null;
    _lastSyncAt = _now();
    await _engine.play();
    _startSyncTimer();
    notifyListeners();
  }

  /// Pauses playback, updates local progress, and syncs immediately to server.
  Future<void> pause() async {
    if (!hasActiveBook) return;
    _pausedAt ??= _now();
    _stopSyncTimer();
    await _engine.pause();
    final pos = positionSec;
    _lastKnownPositionSec = pos;
    final session = _authController.session;
    final book = _activeBook;
    if (session != null && book != null) {
      await _persistLocalProgress(
        serverId: session.serverId,
        itemId: book.id,
        positionSec: pos,
      );
      await _recordHistory(
        serverId: session.serverId,
        itemId: book.id,
        positionSec: pos,
        reason: 'pause',
      );
      await syncProgressNow();
    }
    notifyListeners();
  }

  /// Seeks to [targetSec] within the unified book timeline.
  Future<void> seekToBookPosition(
    double targetSec, {
    String historyReason = 'seek',
  }) async {
    if (!hasActiveBook) return;
    final maxDur = durationSec;
    final clamped = maxDur > 0
        ? targetSec.clamp(0.0, maxDur)
        : (targetSec < 0 ? 0.0 : targetSec);
    final trackPos = _mapper.toTrackPosition(clamped);
    _lastKnownPositionSec = clamped;
    await _engine.seekToTrack(
      trackIndex: trackPos.trackIndex,
      position: trackPos.trackPosition,
    );
    _sleepTimer.onBookPositionChanged(
      positionSec: clamped,
      activeChapterEndSec: BookTimelineMapper.activeChapter(
        _chapters,
        clamped,
      )?.endSec,
    );
    final session = _authController.session;
    final book = _activeBook;
    if (session != null && book != null) {
      await _persistLocalProgress(
        serverId: session.serverId,
        itemId: book.id,
        positionSec: clamped,
      );
      await _recordHistory(
        serverId: session.serverId,
        itemId: book.id,
        positionSec: clamped,
        reason: historyReason,
      );
    }
    notifyListeners();
  }

  /// Rewinds by [amount] (default 15 seconds).
  Future<void> rewind([Duration amount = const Duration(seconds: 15)]) =>
      seekToBookPosition(positionSec - (amount.inMilliseconds / 1000.0));

  /// Fast-forwards by [amount] (default 30 seconds).
  Future<void> forward([Duration amount = const Duration(seconds: 30)]) =>
      seekToBookPosition(positionSec + (amount.inMilliseconds / 1000.0));

  /// Jumps to the previous chapter or restarts the active chapter if >3s in.
  Future<void> previousChapter() async {
    if (_chapters.isEmpty) {
      await seekToBookPosition(0, historyReason: 'chapter');
      return;
    }
    final pos = positionSec;
    final idx = BookTimelineMapper.activeChapterIndex(_chapters, pos);
    if (idx <= 0) {
      await seekToBookPosition(
        _chapters.first.startSec,
        historyReason: 'chapter',
      );
      return;
    }
    final current = _chapters[idx];
    if (pos - current.startSec > 3.0) {
      await seekToBookPosition(current.startSec, historyReason: 'chapter');
    } else {
      await seekToBookPosition(
        _chapters[idx - 1].startSec,
        historyReason: 'chapter',
      );
    }
  }

  /// Jumps to the start of the next chapter, if one exists.
  Future<void> nextChapter() async {
    if (_chapters.isEmpty) return;
    final idx = currentChapterIndex;
    final nextIdx = idx + 1;
    if (nextIdx >= 0 && nextIdx < _chapters.length) {
      await seekToBookPosition(
        _chapters[nextIdx].startSec,
        historyReason: 'chapter',
      );
    }
  }

  /// Jumps directly to [chapter].
  Future<void> jumpToChapter(ChapterInfo chapter) =>
      seekToBookPosition(chapter.startSec, historyReason: 'chapter');

  /// Sets playback speed clamped to `[0.5, 3.0]` in `0.05x` increments.
  Future<void> setSpeed(double nextSpeed) async {
    final stepped = ((nextSpeed.clamp(0.5, 3.0) * 20).round()) / 20.0;
    await _engine.setSpeed(stepped);
    notifyListeners();
  }

  /// Enables or disables silence skipping on supported platforms.
  Future<void> setSkipSilence(bool enabled) async {
    if (!supportsSkipSilence) return;
    await _engine.setSkipSilence(enabled);
    notifyListeners();
  }

  /// Enables or disables smart rewind on resume.
  void setSmartRewindEnabled(bool enabled) {
    if (_smartRewindEnabled == enabled) return;
    _smartRewindEnabled = enabled;
    if (!enabled) {
      _lastSmartRewindSeconds = null;
    }
    notifyListeners();
  }

  /// Saves a bookmark at the current position with [title] and optional [note].
  Future<void> createBookmark({required String title, String? note}) async {
    final session = _authController.session;
    final book = _activeBook;
    if (session == null || book == null) return;
    final trimmedTitle = title.trim().isEmpty
        ? (currentChapter?.title ?? 'Bookmark')
        : title.trim();
    final trimmedNote = note?.trim();
    final timeSec = positionSec;
    final createdAtMs = _now().millisecondsSinceEpoch;

    final resolvedNote = trimmedNote == null || trimmedNote.isEmpty
        ? null
        : trimmedNote;
    final entry = BookmarkEntry(
      timeSec: timeSec,
      title: trimmedTitle,
      note: resolvedNote,
      createdAtMs: createdAtMs,
    );
    _bookmarks = <BookmarkEntry>[
      ..._bookmarks.where((b) => b.timeSec != timeSec),
      entry,
    ]..sort((a, b) => a.timeSec.compareTo(b.timeSec));
    notifyListeners();

    await _database.upsertBookmark(
      BookmarksCompanion.insert(
        serverId: session.serverId,
        libraryItemId: book.id,
        timeSec: timeSec,
        title: trimmedTitle,
        note: Value<String?>(resolvedNote),
        createdAtMs: Value<int>(createdAtMs),
      ),
    );

    try {
      await _apiClient.createBookmark(
        baseUrl: session.baseUrl,
        itemId: book.id,
        timeSec: timeSec,
        title: trimmedTitle,
      );
    } on Object catch (err, stackTrace) {
      _logger.warning(
        'Saved bookmark locally; queuing offline sync',
        scope: 'player',
        error: err,
        stackTrace: stackTrace,
      );
      await _offlineSyncController?.enqueueBookmarkCreate(
        itemId: book.id,
        timeSec: timeSec,
        title: trimmedTitle,
      );
    }
  }

  /// Deletes the bookmark at [timeSec].
  Future<void> deleteBookmark(double timeSec) async {
    final session = _authController.session;
    final book = _activeBook;
    if (session == null || book == null) return;

    _bookmarks = _bookmarks
        .where((b) => b.timeSec != timeSec)
        .toList(growable: false);
    notifyListeners();

    await _database.deleteBookmark(session.serverId, book.id, timeSec);
    try {
      await _apiClient.deleteBookmark(
        baseUrl: session.baseUrl,
        itemId: book.id,
        timeSec: timeSec,
      );
    } on Object catch (err, stackTrace) {
      _logger.warning(
        'Deleted bookmark locally; queuing offline sync',
        scope: 'player',
        error: err,
        stackTrace: stackTrace,
      );
      await _offlineSyncController?.enqueueBookmarkDelete(
        itemId: book.id,
        timeSec: timeSec,
      );
    }
  }

  /// Jumps playback directly to [bookmark].
  Future<void> jumpToBookmark(BookmarkEntry bookmark) =>
      seekToBookPosition(bookmark.timeSec, historyReason: 'bookmark');

  /// Jumps playback to a previously recorded [entry].
  Future<void> jumpToHistory(PlaybackHistoryEntry entry) =>
      seekToBookPosition(entry.positionSec);

  /// Syncs the active session's current position to the ABS server.
  Future<void> syncProgressNow() async {
    final session = _authController.session;
    final playbackSession = _activeSession;
    final book = _activeBook;
    if (session == null || playbackSession == null || book == null) return;

    final now = _now();
    final last = _lastSyncAt ?? now;
    _lastSyncAt = now;
    final elapsedSec = isPlaying
        ? (now.difference(last).inMilliseconds / 1000.0)
        : 0.0;
    final pos = positionSec;
    final dur = durationSec;
    final finished = dur > 0 && pos >= dur - 1;

    if (playbackSession.playMethod == AbsPlayMethod.local) {
      await _offlineSyncController?.enqueueProgressSync(
        itemId: book.id,
        currentTimeSec: pos,
        durationSec: dur,
        isFinished: finished,
      );
      await _offlineSyncController?.flushPendingMutations();
      return;
    }

    try {
      await _apiClient.syncPlaybackSession(
        baseUrl: session.baseUrl,
        sessionId: playbackSession.sessionId,
        currentTimeSec: pos,
        timeListenedSec: elapsedSec < 0 ? 0 : elapsedSec,
        durationSec: dur,
      );
      await _persistLocalProgress(
        serverId: session.serverId,
        itemId: book.id,
        positionSec: pos,
        markSynced: true,
      );
    } on Object catch (err, stackTrace) {
      _logger.warning(
        'Session sync failed; queuing offline progress',
        scope: 'player',
        error: err,
        stackTrace: stackTrace,
      );
      await _offlineSyncController?.enqueueProgressSync(
        itemId: book.id,
        currentTimeSec: pos,
        durationSec: dur,
        isFinished: finished,
      );
    }
  }

  /// Stops playback, closes the server session, and clears active book state.
  Future<void> stopAndClose() async {
    _stopSyncTimer();
    await _sleepTimer.cancel();
    await _closeActiveServerSession();
    await _engine.stop();
    await _cancelItemStreams();
    _activeBook = null;
    _chapters = const <ChapterInfo>[];
    _bookmarks = const <BookmarkEntry>[];
    _history = const <PlaybackHistoryEntry>[];
    _mapper = BookTimelineMapper(const <TrackSegment>[]);
    _lastKnownPositionSec = 0;
    _pausedAt = null;
    _lastSmartRewindSeconds = null;
    _errorMessage = null;
    notifyListeners();
  }

  void _onEngineState(AudioEngineState state) {
    if (_disposed) return;
    if (_mapper.segments.isNotEmpty &&
        state.status != AudioPlaybackStatus.idle &&
        state.status != AudioPlaybackStatus.loading) {
      _lastKnownPositionSec = _mapper.toBookPosition(
        trackIndex: state.trackIndex,
        trackPosition: state.trackPosition,
      );
    }
    _sleepTimer.onBookPositionChanged(
      positionSec: positionSec,
      activeChapterEndSec: currentChapter?.endSec,
    );
    notifyListeners();
  }

  Future<void> _bindItemStreams(String serverId, String itemId) async {
    await _cancelItemStreams();
    _chaptersSub = _database.watchChapters(serverId, itemId).listen((rows) {
      if (_disposed) return;
      if (rows.isNotEmpty) {
        _chapters = rows
            .map(
              (c) => ChapterInfo(
                index: c.chapterIndex,
                title: c.title,
                startSec: c.startSec,
                endSec: c.endSec,
              ),
            )
            .toList(growable: false);
        notifyListeners();
      }
    });
    _bookmarksSub = _database.watchBookmarks(serverId, itemId).listen((rows) {
      if (_disposed) return;
      _bookmarks = rows
          .map(
            (b) => BookmarkEntry(
              timeSec: b.timeSec,
              title: b.title,
              note: b.note,
              createdAtMs: b.createdAtMs,
            ),
          )
          .toList(growable: false);
      notifyListeners();
    });
    _historySub = _database.watchPlaybackHistory(serverId, itemId).listen((
      rows,
    ) {
      if (_disposed) return;
      _history = rows;
      notifyListeners();
    });
  }

  Future<void> _cancelItemStreams() async {
    await _chaptersSub?.cancel();
    await _bookmarksSub?.cancel();
    await _historySub?.cancel();
    _chaptersSub = null;
    _bookmarksSub = null;
    _historySub = null;
  }

  Future<void> _persistLocalProgress({
    required String serverId,
    required String itemId,
    required double positionSec,
    bool markSynced = false,
  }) async {
    await _database.updateLocalProgress(
      serverId: serverId,
      libraryItemId: itemId,
      positionSec: positionSec,
      durationSec: durationSec,
      updatedAtMs: _now().millisecondsSinceEpoch,
      markSynced: markSynced,
    );
    if (durationSec > 0 && positionSec >= durationSec - 1) {
      await _downloadController?.handleBookFinished(itemId);
    }
  }

  Future<void> _recordHistory({
    required String serverId,
    required String itemId,
    required double positionSec,
    required String reason,
  }) {
    return _database.recordPlaybackHistory(
      serverId: serverId,
      libraryItemId: itemId,
      positionSec: positionSec,
      reason: reason,
      createdAtMs: _now().millisecondsSinceEpoch,
    );
  }

  Future<void> _closeActiveServerSession() async {
    final active = _activeSession;
    _activeSession = null;
    if (active == null) return;
    if (active.playMethod == AbsPlayMethod.local) return;
    _socketService.unregisterSelfSessionId(active.sessionId);
    final baseUrl = _authController.session?.baseUrl;
    if (baseUrl == null) return;
    await _safeCloseSession(
      baseUrl: baseUrl,
      playbackSession: active,
      currentTimeSec: _lastKnownPositionSec,
    );
  }

  Future<void> _safeCloseSession({
    required String baseUrl,
    required AbsPlaybackSessionDto playbackSession,
    required double currentTimeSec,
  }) async {
    final now = _now();
    final last = _lastSyncAt ?? now;
    final elapsedSec = isPlaying
        ? (now.difference(last).inMilliseconds / 1000.0)
        : 0.0;
    try {
      await _apiClient.closePlaybackSession(
        baseUrl: baseUrl,
        sessionId: playbackSession.sessionId,
        currentTimeSec: currentTimeSec,
        timeListenedSec: elapsedSec < 0 ? 0 : elapsedSec,
        durationSec: playbackSession.durationSec > 0
            ? playbackSession.durationSec
            : durationSec,
      );
    } on Object catch (err) {
      _logger.fine(
        'Ignoring closePlaybackSession error for '
        '${playbackSession.sessionId}: $err',
        scope: 'player',
      );
    }
  }

  Future<void> _extractDynamicSchemes(
    String coverUrl,
    Map<String, String> headers,
  ) async {
    final light = await _coverThemeExtractor.extractScheme(
      coverUrl: coverUrl,
      brightness: Brightness.light,
      headers: headers,
    );
    final dark = await _coverThemeExtractor.extractScheme(
      coverUrl: coverUrl,
      brightness: Brightness.dark,
      headers: headers,
    );
    if (_disposed || _activeBook == null) return;
    _dynamicLightScheme = light;
    _dynamicDarkScheme = dark;
    notifyListeners();
  }

  void _startSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(syncInterval, (_) {
      unawaited(syncProgressNow());
    });
  }

  void _stopSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  void _handleAuthChanged() {
    if (_authController.session == null && _activeBook != null) {
      unawaited(stopAndClose());
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _stopSyncTimer();
    _authController.removeListener(_handleAuthChanged);
    _sleepTimer
      ..removeListener(notifyListeners)
      ..dispose();
    unawaited(_engineSub?.cancel());
    unawaited(_skipNextSub?.cancel());
    unawaited(_skipPrevSub?.cancel());
    unawaited(_shakeSub?.cancel());
    unawaited(_cancelItemStreams());
    unawaited(_shakeDetector.dispose());
    unawaited(_engine.dispose());
    super.dispose();
  }
}
