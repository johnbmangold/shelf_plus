import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:material_ui/material_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shelf_plus/core/database/app_database.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/network/abs_api_client.dart';
import 'package:shelf_plus/core/network/connectivity_service.dart';
import 'package:shelf_plus/features/auth/presentation/auth_controller.dart';
import 'package:shelf_plus/features/downloads/domain/download_models.dart';
import 'package:shelf_plus/features/downloads/domain/download_transport.dart';
import 'package:shelf_plus/features/library/domain/library_models.dart';

/// Offline audiobook download manager supporting sequential queue execution,
/// byte-range pause/resume, Wi-Fi-only gating, and finished auto-cleanup.
class DownloadController extends ChangeNotifier {
  /// Creates a [DownloadController].
  new({
    required this._apiClient,
    required this._database,
    required this._authController,
    required this._connectivityService,
    required this._transport,
    required this._logger,
    Future<Directory> Function()? getDownloadsRoot,
    DateTime Function()? now,
  }) : _getDownloadsRoot = getDownloadsRoot ?? _defaultDownloadsRoot,
       _now = now ?? DateTime.now {
    _connectivitySub = _connectivityService.onStatusChanged.listen(
      _onConnectivityChanged,
    );
    _authController.addListener(_handleAuthChanged);
    scheduleMicrotask(() {
      if (!_disposed) {
        _bindServer(_authController.session?.serverId);
      }
    });
  }

  /// Error marker used when a task is paused solely awaiting Wi-Fi.
  static const String waitingForWifiMarker = 'waiting_for_wifi';

  static const String _prefWifiOnly = 'downloads_wifi_only';
  static const String _prefAutoDelete = 'downloads_auto_delete_finished';

  static Future<Directory> _defaultDownloadsRoot() async {
    final support = await getApplicationSupportDirectory();
    return Directory('${support.path}${Platform.pathSeparator}downloads');
  }

  final AbsApiClient _apiClient;
  final AppDatabase _database;
  final AuthController _authController;
  final ConnectivityService _connectivityService;
  final DownloadTransport _transport;
  final AppLogger _logger;
  final Future<Directory> Function() _getDownloadsRoot;
  final DateTime Function() _now;

  Future<void>? _prefsLoaded;
  StreamSubscription<NetworkConnectionType>? _connectivitySub;
  StreamSubscription<List<DownloadedBookRow>>? _downloadsSub;
  StreamSubscription<List<DownloadTask>>? _tasksSub;

  String? _boundServerId;
  List<DownloadedBookRow> _downloads = const <DownloadedBookRow>[];
  Map<String, DownloadTask> _tasksByItemId = const <String, DownloadTask>{};
  bool _wifiOnly = true;
  bool _autoDeleteFinished = false;
  bool _isWorkerRunning = false;
  String? _activeItemId;
  CancelToken? _activeCancelToken;
  String? _activeCancelReason;
  final Set<String> _deletingItemIds = <String>{};
  bool _disposed = false;

  /// Reactive downloaded & queued books for the active server.
  List<DownloadedBookRow> get downloads => _downloads;

  /// Whether downloads are restricted to Wi-Fi networks.
  bool get wifiOnly => _wifiOnly;

  /// Whether completed books are deleted automatically when marked finished.
  bool get autoDeleteFinished => _autoDeleteFinished;

  /// Total bytes currently consumed by downloaded/partial tasks on this server.
  int get totalBytesUsed =>
      _downloads.fold<int>(0, (sum, row) => sum + row.task.bytesDownloaded);

  /// Returns the [DownloadTask] for [itemId], or `null` if not downloaded.
  DownloadTask? taskForBook(String itemId) => _tasksByItemId[itemId];

  /// Resolves verified local tracks for offline playback, or returns `null` if
  /// not fully downloaded or files are missing.
  Future<List<DownloadedTrack>?> resolveLocalTracks(
    String serverId,
    String itemId,
  ) async {
    final task = await _database.getDownloadTask(serverId, itemId);
    if (task == null || task.status != DownloadStatus.completed.name) {
      return null;
    }
    final tracks = await _database.getDownloadedTracks(serverId, itemId);
    if (tracks.isEmpty) return null;
    for (final track in tracks) {
      if (!track.isComplete || !File(track.localPath).existsSync()) {
        return null;
      }
    }
    return tracks;
  }

  /// Queues [book] for offline download and starts transfers if permitted.
  Future<void> enqueueDownload(BookSummary book) async {
    await _ensurePreferencesLoaded();
    final session = _authController.session;
    if (session == null) return;

    final existing = await _database.getDownloadTask(session.serverId, book.id);
    if (existing != null &&
        existing.status == DownloadStatus.completed.name &&
        await resolveLocalTracks(session.serverId, book.id) != null) {
      return;
    }

    final nowMs = _now().toUtc().millisecondsSinceEpoch;
    final shouldPauseForWifi =
        _wifiOnly &&
        _connectivityService.currentStatus != NetworkConnectionType.wifi;
    await _database.upsertDownloadTask(
      DownloadTasksCompanion.insert(
        serverId: session.serverId,
        libraryItemId: book.id,
        status: shouldPauseForWifi
            ? DownloadStatus.paused.name
            : DownloadStatus.queued.name,
        bytesDownloaded: Value<int>(existing?.bytesDownloaded ?? 0),
        totalBytes: Value<int>(existing?.totalBytes ?? 0),
        trackCount: Value<int>(existing?.trackCount ?? 0),
        completedTracks: Value<int>(existing?.completedTracks ?? 0),
        errorMessage: Value<String?>(
          shouldPauseForWifi ? waitingForWifiMarker : null,
        ),
        createdAtMs: existing?.createdAtMs ?? nowMs,
        updatedAtMs: nowMs,
      ),
    );

    if (!shouldPauseForWifi) {
      unawaited(_processQueue());
    }
  }

  /// Pauses an active or queued download for [itemId], retaining `.part`
  /// bytes on disk.
  Future<void> pauseDownload(String itemId, {String reason = 'user'}) async {
    final session = _authController.session;
    if (session == null) return;

    if (_activeItemId == itemId && _activeCancelToken != null) {
      _activeCancelReason = reason;
      _activeCancelToken!.cancel(reason);
      return;
    }

    final existing = await _database.getDownloadTask(session.serverId, itemId);
    if (existing == null) return;
    await _database.updateDownloadTask(
      session.serverId,
      itemId,
      DownloadTasksCompanion(
        status: Value<String>(DownloadStatus.paused.name),
        errorMessage: Value<String?>(
          reason == waitingForWifiMarker ? waitingForWifiMarker : null,
        ),
        updatedAtMs: Value<int>(_now().toUtc().millisecondsSinceEpoch),
      ),
    );
  }

  /// Resumes a paused or failed download for [itemId].
  Future<void> resumeDownload(String itemId) async {
    await _ensurePreferencesLoaded();
    final session = _authController.session;
    if (session == null) return;
    final existing = await _database.getDownloadTask(session.serverId, itemId);
    if (existing == null) return;

    final blockedByWifi =
        _wifiOnly &&
        _connectivityService.currentStatus != NetworkConnectionType.wifi;
    await _database.updateDownloadTask(
      session.serverId,
      itemId,
      DownloadTasksCompanion(
        status: Value<String>(
          blockedByWifi
              ? DownloadStatus.paused.name
              : DownloadStatus.queued.name,
        ),
        errorMessage: Value<String?>(
          blockedByWifi ? waitingForWifiMarker : null,
        ),
        updatedAtMs: Value<int>(_now().toUtc().millisecondsSinceEpoch),
      ),
    );
    if (!blockedByWifi) {
      unawaited(_processQueue());
    }
  }

  /// Cancels any active transfer and deletes offline files for [itemId].
  Future<void> cancelAndDeleteDownload(String itemId) async {
    final session = _authController.session;
    if (session == null) return;

    _deletingItemIds.add(itemId);
    if (_activeItemId == itemId && _activeCancelToken != null) {
      _activeCancelReason = 'delete';
      _activeCancelToken!.cancel('delete');
    }

    try {
      final root = await _getDownloadsRoot();
      final itemDir = Directory(
        '${root.path}${Platform.pathSeparator}${session.serverId}'
        '${Platform.pathSeparator}$itemId',
      );
      if (itemDir.existsSync()) {
        await itemDir.delete(recursive: true);
      }
      await _database.deleteDownloadForBook(session.serverId, itemId);
    } finally {
      _deletingItemIds.remove(itemId);
    }
  }

  /// Deletes all downloaded books and pending transfers for the active server.
  Future<void> deleteAllDownloads() async {
    final ids = _downloads
        .map((row) => row.task.libraryItemId)
        .toList(growable: false);
    for (final id in ids) {
      await cancelAndDeleteDownload(id);
    }
  }

  /// Updates the Wi-Fi-only preference and pauses/resumes active queue items.
  Future<void> setWifiOnly(bool value) async {
    if (_wifiOnly == value) return;
    _wifiOnly = value;
    notifyListeners();
    await _database.setPreference(_prefWifiOnly, value.toString());

    if (value &&
        _connectivityService.currentStatus != NetworkConnectionType.wifi) {
      if (_activeItemId != null) {
        await pauseDownload(_activeItemId!, reason: waitingForWifiMarker);
      }
      final queued = _downloads
          .where((row) => row.task.status == DownloadStatus.queued.name)
          .toList(growable: false);
      for (final row in queued) {
        await pauseDownload(
          row.task.libraryItemId,
          reason: waitingForWifiMarker,
        );
      }
    } else if (!value ||
        _connectivityService.currentStatus == NetworkConnectionType.wifi) {
      await _resumeWaitingForWifiTasks();
    }
  }

  /// Updates the auto-delete finished preference.
  Future<void> setAutoDeleteFinished(bool value) async {
    if (_autoDeleteFinished == value) return;
    _autoDeleteFinished = value;
    notifyListeners();
    await _database.setPreference(_prefAutoDelete, value.toString());
  }

  /// Deletes offline files for [itemId] when [autoDeleteFinished] is enabled.
  Future<void> handleBookFinished(String itemId) async {
    await _ensurePreferencesLoaded();
    if (!_autoDeleteFinished) return;
    final task = taskForBook(itemId);
    if (task != null && task.status == DownloadStatus.completed.name) {
      await cancelAndDeleteDownload(itemId);
    }
  }

  Future<void> _ensurePreferencesLoaded() =>
      _prefsLoaded ??= _loadPreferences();

  Future<void> _loadPreferences() async {
    final wifiRaw = await _database.getPreference(_prefWifiOnly);
    final autoDeleteRaw = await _database.getPreference(_prefAutoDelete);
    if (_disposed) return;
    if (wifiRaw != null) {
      _wifiOnly = wifiRaw == 'true';
    }
    if (autoDeleteRaw != null) {
      _autoDeleteFinished = autoDeleteRaw == 'true';
    }
    notifyListeners();
  }

  Future<void> _processQueue() async {
    await _ensurePreferencesLoaded();
    if (_disposed || _isWorkerRunning) return;
    _isWorkerRunning = true;

    try {
      while (!_disposed) {
        final session = _authController.session;
        if (session == null) break;

        if (_wifiOnly &&
            _connectivityService.currentStatus != NetworkConnectionType.wifi) {
          break;
        }
        if (_connectivityService.currentStatus ==
            NetworkConnectionType.offline) {
          break;
        }

        final tasks = await _database.getDownloadTasks(session.serverId);
        final next =
            tasks
                .where((t) => t.status == DownloadStatus.queued.name)
                .toList(growable: false)
              ..sort((a, b) => a.createdAtMs.compareTo(b.createdAtMs));
        if (next.isEmpty) break;

        await _downloadBook(
          serverId: session.serverId,
          baseUrl: session.baseUrl,
          task: next.first,
        );
      }
    } finally {
      _isWorkerRunning = false;
    }
  }

  Future<void> _downloadBook({
    required String serverId,
    required String baseUrl,
    required DownloadTask task,
  }) async {
    final itemId = task.libraryItemId;
    if (_deletingItemIds.contains(itemId)) return;

    _activeItemId = itemId;
    final cancelToken = CancelToken();
    _activeCancelToken = cancelToken;
    _activeCancelReason = null;

    try {
      var tracks = await _database.getDownloadedTracks(serverId, itemId);
      if (tracks.isEmpty) {
        final expanded = await _apiClient.fetchItemExpanded(
          baseUrl: baseUrl,
          itemId: itemId,
        );
        if (expanded.chapters.isNotEmpty) {
          await _database.replaceChapters(serverId, itemId, <ChaptersCompanion>[
            for (var i = 0; i < expanded.chapters.length; i++)
              ChaptersCompanion.insert(
                serverId: serverId,
                libraryItemId: itemId,
                chapterIndex: i,
                title: expanded.chapters[i].title.isNotEmpty
                    ? expanded.chapters[i].title
                    : 'Chapter ${i + 1}',
                startSec: expanded.chapters[i].start,
                endSec: expanded.chapters[i].end,
              ),
          ]);
        }
        final audioFiles = expanded.audioFiles;
        if (audioFiles.isEmpty) {
          throw StateError('No downloadable audio files reported by server.');
        }

        final root = await _getDownloadsRoot();
        final bookDirPath =
            '${root.path}${Platform.pathSeparator}$serverId'
            '${Platform.pathSeparator}$itemId';
        var offset = 0.0;
        final companions = <DownloadedTracksCompanion>[];
        for (var i = 0; i < audioFiles.length; i++) {
          final file = audioFiles[i];
          final ext = _extensionForFilename(file.filename);
          final localPath =
              '$bookDirPath${Platform.pathSeparator}'
              'track_${i.toString().padLeft(3, '0')}$ext';
          companions.add(
            DownloadedTracksCompanion.insert(
              serverId: serverId,
              libraryItemId: itemId,
              trackIndex: i,
              ino: file.ino,
              title: file.title.isNotEmpty ? file.title : 'Track ${i + 1}',
              contentUrl: '/api/items/$itemId/file/${file.ino}',
              localPath: localPath,
              startOffsetSec: Value<double>(offset),
              durationSec: Value<double>(file.durationSec),
              expectedBytes: Value<int>(file.sizeBytes),
            ),
          );
          offset += file.durationSec;
        }
        await _database.replaceDownloadedTracks(serverId, itemId, companions);
        tracks = await _database.getDownloadedTracks(serverId, itemId);
      }

      var totalExpected = tracks.fold<int>(
        0,
        (sum, t) => sum + t.expectedBytes,
      );
      var totalReceived = tracks.fold<int>(
        0,
        (sum, t) => sum + t.downloadedBytes,
      );
      var completedCount = tracks.where((t) => t.isComplete).length;

      await _database.updateDownloadTask(
        serverId,
        itemId,
        DownloadTasksCompanion(
          status: Value<String>(DownloadStatus.downloading.name),
          bytesDownloaded: Value<int>(totalReceived),
          totalBytes: Value<int>(totalExpected),
          trackCount: Value<int>(tracks.length),
          completedTracks: Value<int>(completedCount),
          errorMessage: const Value<String?>(null),
          updatedAtMs: Value<int>(_now().toUtc().millisecondsSinceEpoch),
        ),
      );

      for (final track in tracks) {
        if (track.isComplete) continue;
        if (cancelToken.isCancelled || _deletingItemIds.contains(itemId)) {
          break;
        }

        final url = AbsApiClient.buildAudioFileUrl(
          baseUrl: baseUrl,
          itemId: itemId,
          ino: track.ino,
        );

        final previousTrackBytes = track.downloadedBytes;
        var lastPersistedTrackBytes = previousTrackBytes;

        final result = await _transport.downloadTrack(
          url: url,
          destinationPath: track.localPath,
          existingBytes: previousTrackBytes,
          cancelToken: cancelToken,
          onProgress: (received, trackTotal) {
            final expected = track.expectedBytes > 0
                ? track.expectedBytes
                : trackTotal;
            final delta = received - lastPersistedTrackBytes;
            if (delta < 0) return;
            lastPersistedTrackBytes = received;
            totalReceived += delta;
            if (track.expectedBytes == 0 && expected > 0) {
              totalExpected =
                  tracks.fold<int>(0, (sum, t) => sum + t.expectedBytes) +
                  expected;
            }
            unawaited(
              _persistProgressSnapshot(
                serverId: serverId,
                itemId: itemId,
                trackIndex: track.trackIndex,
                trackBytes: received,
                expectedTrackBytes: expected,
                totalDownloaded: totalReceived,
                totalExpected: totalExpected,
              ),
            );
          },
        );

        final finalDelta = result.totalBytes - lastPersistedTrackBytes;
        if (finalDelta > 0) {
          totalReceived += finalDelta;
        }
        completedCount++;
        await _database.updateDownloadedTrackProgress(
          serverId: serverId,
          libraryItemId: itemId,
          trackIndex: track.trackIndex,
          downloadedBytes: result.totalBytes,
          expectedBytes: result.totalBytes,
          isComplete: true,
        );
      }

      if (cancelToken.isCancelled || _deletingItemIds.contains(itemId)) {
        if (!_deletingItemIds.contains(itemId)) {
          await _markPaused(serverId, itemId, totalReceived);
        }
        return;
      }

      final finalTracks = await _database.getDownloadedTracks(serverId, itemId);
      final finalBytes = finalTracks.fold<int>(
        0,
        (sum, t) => sum + t.downloadedBytes,
      );
      await _database.updateDownloadTask(
        serverId,
        itemId,
        DownloadTasksCompanion(
          status: Value<String>(DownloadStatus.completed.name),
          bytesDownloaded: Value<int>(finalBytes),
          totalBytes: Value<int>(finalBytes),
          trackCount: Value<int>(finalTracks.length),
          completedTracks: Value<int>(finalTracks.length),
          errorMessage: const Value<String?>(null),
          updatedAtMs: Value<int>(_now().toUtc().millisecondsSinceEpoch),
        ),
      );
    } on DioException catch (err) {
      if (CancelToken.isCancel(err) || cancelToken.isCancelled) {
        if (!_deletingItemIds.contains(itemId)) {
          final currentTracks = await _database.getDownloadedTracks(
            serverId,
            itemId,
          );
          final sumBytes = currentTracks.fold<int>(
            0,
            (sum, t) => sum + t.downloadedBytes,
          );
          await _markPaused(serverId, itemId, sumBytes);
        }
      } else {
        await _markFailed(serverId, itemId, err.message ?? 'Download failed');
      }
    } on Object catch (err, stackTrace) {
      if (cancelToken.isCancelled && !_deletingItemIds.contains(itemId)) {
        final currentTracks = await _database.getDownloadedTracks(
          serverId,
          itemId,
        );
        final sumBytes = currentTracks.fold<int>(
          0,
          (sum, t) => sum + t.downloadedBytes,
        );
        await _markPaused(serverId, itemId, sumBytes);
      } else if (!_deletingItemIds.contains(itemId)) {
        _logger.warning(
          'Download failed for $itemId',
          scope: 'downloads',
          error: err,
          stackTrace: stackTrace,
        );
        await _markFailed(serverId, itemId, err.toString());
      }
    } finally {
      _activeItemId = null;
      _activeCancelToken = null;
      _activeCancelReason = null;
    }
  }

  Future<void> _persistProgressSnapshot({
    required String serverId,
    required String itemId,
    required int trackIndex,
    required int trackBytes,
    required int expectedTrackBytes,
    required int totalDownloaded,
    required int totalExpected,
  }) async {
    if (_disposed || _deletingItemIds.contains(itemId)) return;
    await _database.updateDownloadedTrackProgress(
      serverId: serverId,
      libraryItemId: itemId,
      trackIndex: trackIndex,
      downloadedBytes: trackBytes,
      expectedBytes: expectedTrackBytes > 0 ? expectedTrackBytes : null,
    );
    await _database.updateDownloadTask(
      serverId,
      itemId,
      DownloadTasksCompanion(
        bytesDownloaded: Value<int>(totalDownloaded),
        totalBytes: Value<int>(totalExpected),
        updatedAtMs: Value<int>(_now().toUtc().millisecondsSinceEpoch),
      ),
    );
  }

  Future<void> _markPaused(String serverId, String itemId, int bytes) {
    final reason = _activeCancelReason == waitingForWifiMarker
        ? waitingForWifiMarker
        : null;
    return _database.updateDownloadTask(
      serverId,
      itemId,
      DownloadTasksCompanion(
        status: Value<String>(DownloadStatus.paused.name),
        bytesDownloaded: Value<int>(bytes),
        errorMessage: Value<String?>(reason),
        updatedAtMs: Value<int>(_now().toUtc().millisecondsSinceEpoch),
      ),
    );
  }

  Future<void> _markFailed(String serverId, String itemId, String message) {
    return _database.updateDownloadTask(
      serverId,
      itemId,
      DownloadTasksCompanion(
        status: Value<String>(DownloadStatus.failed.name),
        errorMessage: Value<String?>(message),
        updatedAtMs: Value<int>(_now().toUtc().millisecondsSinceEpoch),
      ),
    );
  }

  Future<void> _resumeWaitingForWifiTasks() async {
    final session = _authController.session;
    if (session == null) return;
    final tasks = await _database.getDownloadTasks(session.serverId);
    final waiting = tasks
        .where(
          (task) =>
              task.status == DownloadStatus.paused.name &&
              task.errorMessage == waitingForWifiMarker,
        )
        .toList(growable: false);
    for (final task in waiting) {
      await _database.updateDownloadTask(
        session.serverId,
        task.libraryItemId,
        DownloadTasksCompanion(
          status: Value<String>(DownloadStatus.queued.name),
          errorMessage: const Value<String?>(null),
          updatedAtMs: Value<int>(_now().toUtc().millisecondsSinceEpoch),
        ),
      );
    }
    if (waiting.isNotEmpty) {
      unawaited(_processQueue());
    }
  }

  Future<void> _handleOnlineReconnect() async {
    await _resumeWaitingForWifiTasks();
    await _processQueue();
  }

  void _onConnectivityChanged(NetworkConnectionType next) {
    if (_wifiOnly && next != NetworkConnectionType.wifi) {
      if (_activeItemId != null) {
        unawaited(pauseDownload(_activeItemId!, reason: waitingForWifiMarker));
      }
      return;
    }
    if (next == NetworkConnectionType.wifi ||
        (!_wifiOnly && next != NetworkConnectionType.offline)) {
      unawaited(_handleOnlineReconnect());
    }
  }

  void _handleAuthChanged() {
    _bindServer(_authController.session?.serverId);
  }

  void _bindServer(String? serverId) {
    if (_boundServerId == serverId) return;
    _boundServerId = serverId;
    if (_activeItemId != null && _activeCancelToken != null) {
      _activeCancelReason = 'signOut';
      _activeCancelToken!.cancel('signOut');
    }
    unawaited(_downloadsSub?.cancel());
    unawaited(_tasksSub?.cancel());
    _downloadsSub = null;
    _tasksSub = null;

    if (serverId == null) {
      _downloads = const <DownloadedBookRow>[];
      _tasksByItemId = const <String, DownloadTask>{};
      if (!_disposed) notifyListeners();
      return;
    }

    _downloadsSub = _database.watchDownloadedBooks(serverId).listen((rows) {
      if (_disposed) return;
      _downloads = rows;
      notifyListeners();
    });
    _tasksSub = _database.watchDownloadTasks(serverId).listen((tasks) {
      if (_disposed) return;
      _tasksByItemId = <String, DownloadTask>{
        for (final task in tasks) task.libraryItemId: task,
      };
      notifyListeners();
    });
  }

  static String _extensionForFilename(String filename) {
    final dotIndex = filename.lastIndexOf('.');
    if (dotIndex != -1 && dotIndex < filename.length - 1) {
      return filename.substring(dotIndex);
    }
    return '.m4b';
  }

  @override
  void dispose() {
    _disposed = true;
    _authController.removeListener(_handleAuthChanged);
    unawaited(_connectivitySub?.cancel());
    unawaited(_downloadsSub?.cancel());
    unawaited(_tasksSub?.cancel());
    _activeCancelToken?.cancel('disposed');
    super.dispose();
  }
}
