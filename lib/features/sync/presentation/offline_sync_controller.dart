import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/database/app_database.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/network/abs_api_client.dart';
import 'package:shelf_plus/core/network/abs_api_models.dart';
import 'package:shelf_plus/core/network/connectivity_service.dart';
import 'package:shelf_plus/features/auth/presentation/auth_controller.dart';
import 'package:shelf_plus/features/sync/domain/local_playback_session.dart';
import 'package:shelf_plus/features/sync/domain/progress_conflict_resolver.dart';
import 'package:uuid/uuid.dart';

/// Coordinates durable offline sync mutation queuing, automatic flush on
/// reconnect/foreground, and 3-way progress conflict resolution.
class OfflineSyncController extends ChangeNotifier {
  /// Creates an [OfflineSyncController].
  new({
    required this._apiClient,
    required this._database,
    required this._authController,
    required this._connectivityService,
    required this._logger,
    DateTime Function()? now,
    String Function()? sessionIdGenerator,
  }) : _now = now ?? DateTime.now,
       _sessionIdGenerator = sessionIdGenerator ?? _defaultSessionId {
    _lastConnection = _connectivityService.currentStatus;
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

  /// Maximum consecutive retry attempts before a mutation is skipped during
  /// automatic flush passes.
  static const int maxRetryCount = 5;

  static const Uuid _uuid = Uuid();
  static String _defaultSessionId() => _uuid.v4();

  /// Computes exponential retry backoff for [retryCount], capped at 5 minutes.
  static Duration retryBackoffForAttempt(int retryCount) {
    final safeAttempt = retryCount < 0 ? 0 : retryCount;
    final multiplier = 1 << safeAttempt.clamp(0, 8);
    final seconds = (2 * multiplier).clamp(2, 300);
    return Duration(seconds: seconds);
  }

  final AbsApiClient _apiClient;
  final AppDatabase _database;
  final AuthController _authController;
  final ConnectivityService _connectivityService;
  final AppLogger _logger;
  final DateTime Function() _now;
  final String Function() _sessionIdGenerator;

  StreamSubscription<NetworkConnectionType>? _connectivitySub;
  StreamSubscription<int>? _pendingCountSub;
  StreamSubscription<List<ConflictedProgressRow>>? _conflictsSub;

  String? _boundServerId;
  NetworkConnectionType _lastConnection = NetworkConnectionType.offline;
  int _pendingCount = 0;
  List<ConflictedProgressRow> _conflicts = const <ConflictedProgressRow>[];
  bool _isFlushing = false;
  bool _disposed = false;

  /// Number of queued mutations awaiting delivery for the active server.
  int get pendingCount => _pendingCount;

  /// Unresolved progress conflicts for the active server.
  List<ConflictedProgressRow> get conflicts => _conflicts;

  /// Whether at least one conflict requires user decision.
  bool get hasConflicts => _conflicts.isNotEmpty;

  /// Whether a sync flush pass is currently running.
  bool get isFlushing => _isFlushing;

  /// Queues a UUIDv4 [LocalPlaybackSession] for replay via
  /// `POST /api/syncLocalSession` (with automatic `PATCH` fallback).
  Future<LocalPlaybackSession?> enqueueLocalSession({
    required String itemId,
    required double startTimeSec,
    required double currentTimeSec,
    required double durationSec,
    required double timeListeningSec,
    required bool isFinished,
    int? startedAtMs,
  }) async {
    final serverId = _authController.session?.serverId;
    if (serverId == null) return null;
    final nowMs = _now().toUtc().millisecondsSinceEpoch;
    final session = LocalPlaybackSession(
      id: _sessionIdGenerator(),
      libraryItemId: itemId,
      durationSec: durationSec,
      startTimeSec: startTimeSec,
      currentTimeSec: currentTimeSec,
      timeListeningSec: timeListeningSec < 0 ? 0 : timeListeningSec,
      startedAtMs: startedAtMs ?? nowMs,
      updatedAtMs: nowMs,
      isFinished: isFinished,
    );
    await _database.enqueueSyncMutation(
      serverId: serverId,
      libraryItemId: itemId,
      mutationType: 'localSession',
      payloadJson: jsonEncode(session.toJson()),
      createdAtMs: nowMs,
    );
    return session;
  }

  /// Queues or updates the latest listening progress mutation for [itemId].
  Future<void> enqueueProgressSync({
    required String itemId,
    required double currentTimeSec,
    required double durationSec,
    required bool isFinished,
  }) async {
    final serverId = _authController.session?.serverId;
    if (serverId == null) return;
    await _database.enqueueSyncMutation(
      serverId: serverId,
      libraryItemId: itemId,
      mutationType: 'progress',
      payloadJson: jsonEncode(<String, Object?>{
        'currentTimeSec': currentTimeSec,
        'durationSec': durationSec,
        'isFinished': isFinished,
      }),
      createdAtMs: _now().toUtc().millisecondsSinceEpoch,
    );
  }

  /// Queues offline creation of a user bookmark.
  Future<void> enqueueBookmarkCreate({
    required String itemId,
    required double timeSec,
    required String title,
  }) async {
    final serverId = _authController.session?.serverId;
    if (serverId == null) return;
    await _database.enqueueSyncMutation(
      serverId: serverId,
      libraryItemId: itemId,
      mutationType: 'bookmarkCreate',
      payloadJson: jsonEncode(<String, Object?>{
        'timeSec': timeSec,
        'title': title,
      }),
      createdAtMs: _now().toUtc().millisecondsSinceEpoch,
    );
  }

  /// Queues offline deletion of a user bookmark.
  Future<void> enqueueBookmarkDelete({
    required String itemId,
    required double timeSec,
  }) async {
    final serverId = _authController.session?.serverId;
    if (serverId == null) return;
    await _database.enqueueSyncMutation(
      serverId: serverId,
      libraryItemId: itemId,
      mutationType: 'bookmarkDelete',
      payloadJson: jsonEncode(<String, Object?>{'timeSec': timeSec}),
      createdAtMs: _now().toUtc().millisecondsSinceEpoch,
    );
  }

  /// Flushes pending offline mutations in FIFO order when online.
  Future<void> flushPendingMutations() async {
    final session = _authController.session;
    if (_disposed ||
        _isFlushing ||
        session == null ||
        _connectivityService.currentStatus == NetworkConnectionType.offline) {
      return;
    }

    _isFlushing = true;
    notifyListeners();

    try {
      final mutations = await _database.getPendingSyncMutations(
        session.serverId,
      );
      for (final mutation in mutations) {
        if (_disposed ||
            _connectivityService.currentStatus ==
                NetworkConnectionType.offline) {
          break;
        }
        if (mutation.retryCount >= maxRetryCount) {
          continue;
        }
        try {
          await _processMutation(session.serverId, session.baseUrl, mutation);
          if (_disposed) break;
          await _database.deleteSyncMutation(mutation.id);
        } on Object catch (err, stackTrace) {
          if (_disposed) break;
          final backoff = retryBackoffForAttempt(mutation.retryCount);
          _logger.warning(
            'Failed flushing ${mutation.mutationType} mutation '
            'for ${mutation.libraryItemId} '
            '(attempt ${mutation.retryCount + 1}/$maxRetryCount, '
            'next backoff ${backoff.inSeconds}s)',
            scope: 'sync',
            error: err,
            stackTrace: stackTrace,
          );
          await _database.markSyncMutationFailed(mutation.id, err.toString());
          break;
        }
      }
    } finally {
      _isFlushing = false;
      if (!_disposed) {
        notifyListeners();
      }
    }
  }

  Future<void> _processMutation(
    String serverId,
    String baseUrl,
    PendingSyncMutation mutation,
  ) async {
    final decoded = jsonDecode(mutation.payloadJson) as Map<String, dynamic>;
    switch (mutation.mutationType) {
      case 'localSession':
        final existing = await _database.getMediaProgress(
          serverId,
          mutation.libraryItemId,
        );
        if (existing != null && existing.syncState == 'conflict') {
          return;
        }
        final localSession = LocalPlaybackSession.fromJson(decoded);
        try {
          await _apiClient.syncLocalSession(
            baseUrl: baseUrl,
            sessionPayload: localSession.toJson(),
          );
        } on AbsApiException catch (err) {
          if (err.statusCode != 404) rethrow;
          await _apiClient.patchMediaProgress(
            baseUrl: baseUrl,
            itemId: mutation.libraryItemId,
            currentTimeSec: localSession.currentTimeSec,
            durationSec: localSession.durationSec,
            isFinished: localSession.isFinished,
          );
        }
        await _database.updateLocalProgress(
          serverId: serverId,
          libraryItemId: mutation.libraryItemId,
          positionSec: localSession.currentTimeSec,
          durationSec: localSession.durationSec,
          updatedAtMs: localSession.updatedAtMs,
          markSynced: true,
        );
      case 'progress':
        final existing = await _database.getMediaProgress(
          serverId,
          mutation.libraryItemId,
        );
        if (existing != null && existing.syncState == 'conflict') {
          return;
        }
        final currentTimeSec =
            (decoded['currentTimeSec'] as num?)?.toDouble() ?? 0;
        final durationSec = (decoded['durationSec'] as num?)?.toDouble() ?? 0;
        final isFinished = decoded['isFinished'] as bool? ?? false;
        await _apiClient.patchMediaProgress(
          baseUrl: baseUrl,
          itemId: mutation.libraryItemId,
          currentTimeSec: currentTimeSec,
          durationSec: durationSec,
          isFinished: isFinished,
        );
        await _database.updateLocalProgress(
          serverId: serverId,
          libraryItemId: mutation.libraryItemId,
          positionSec: currentTimeSec,
          durationSec: durationSec,
          updatedAtMs: mutation.createdAtMs,
          markSynced: true,
        );
      case 'bookmarkCreate':
        final timeSec = (decoded['timeSec'] as num?)?.toDouble() ?? 0;
        final title = decoded['title'] as String? ?? 'Bookmark';
        await _apiClient.createBookmark(
          baseUrl: baseUrl,
          itemId: mutation.libraryItemId,
          timeSec: timeSec,
          title: title,
        );
      case 'bookmarkDelete':
        final timeSec = (decoded['timeSec'] as num?)?.toDouble() ?? 0;
        await _apiClient.deleteBookmark(
          baseUrl: baseUrl,
          itemId: mutation.libraryItemId,
          timeSec: timeSec,
        );
    }
  }

  /// Resolves a progress conflict for [itemId] according to [choice].
  Future<void> resolveConflict({
    required String itemId,
    required ConflictResolutionChoice choice,
  }) async {
    final session = _authController.session;
    if (session == null) return;
    final serverId = session.serverId;
    final entry = await _database.getMediaProgress(serverId, itemId);
    if (entry == null) return;

    final nowMs = _now().toUtc().millisecondsSinceEpoch;

    // Preserve both conflicting positions in playback history so the listener
    // can always jump back to either device's timestamp after resolving.
    await _database.recordPlaybackHistory(
      serverId: serverId,
      libraryItemId: itemId,
      positionSec: entry.localPositionSec,
      reason: 'conflict_device',
      createdAtMs: nowMs,
    );
    await _database.recordPlaybackHistory(
      serverId: serverId,
      libraryItemId: itemId,
      positionSec: entry.serverPositionSec,
      reason: 'conflict_server',
      createdAtMs: nowMs + 1,
    );

    switch (choice) {
      case ConflictResolutionChoice.keepDevice:
        final dur = entry.durationSec;
        final pos = entry.localPositionSec;
        final ratio = dur > 0 ? (pos / dur).clamp(0.0, 1.0) : 0.0;
        final finished = dur > 0 && pos >= dur - 1;
        var pushedOnline = false;
        if (_connectivityService.currentStatus !=
            NetworkConnectionType.offline) {
          try {
            await _apiClient.patchMediaProgress(
              baseUrl: session.baseUrl,
              itemId: itemId,
              currentTimeSec: pos,
              durationSec: dur,
              isFinished: finished,
            );
            pushedOnline = true;
          } on Object catch (err, stackTrace) {
            _logger.warning(
              'Deferring keepDevice resolution push for $itemId',
              scope: 'sync',
              error: err,
              stackTrace: stackTrace,
            );
          }
        }
        await _database.upsertMediaProgressEntries(
          <MediaProgressEntriesCompanion>[
            MediaProgressEntriesCompanion.insert(
              serverId: serverId,
              libraryItemId: itemId,
              durationSec: Value<double>(dur),
              localPositionSec: Value<double>(pos),
              serverPositionSec: Value<double>(
                pushedOnline ? pos : entry.serverPositionSec,
              ),
              lastSyncedPositionSec: Value<double>(
                pushedOnline ? pos : entry.lastSyncedPositionSec,
              ),
              progress: Value<double>(ratio),
              isFinished: Value<bool>(finished),
              hideFromContinueListening: Value<bool>(
                entry.hideFromContinueListening,
              ),
              localUpdatedAtMs: Value<int>(nowMs),
              serverUpdatedAtMs: Value<int>(
                pushedOnline ? nowMs : entry.serverUpdatedAtMs,
              ),
              syncState: Value<String>(pushedOnline ? 'synced' : 'pendingPush'),
            ),
          ],
        );
        if (pushedOnline) {
          await _database.deleteProgressMutationsForItem(serverId, itemId);
        } else {
          await enqueueProgressSync(
            itemId: itemId,
            currentTimeSec: pos,
            durationSec: dur,
            isFinished: finished,
          );
        }
      case ConflictResolutionChoice.useServer:
        final dur = entry.durationSec;
        final pos = entry.serverPositionSec;
        final ratio = dur > 0 ? (pos / dur).clamp(0.0, 1.0) : 0.0;
        final finished = dur > 0 && pos >= dur - 1;
        await _database.upsertMediaProgressEntries(
          <MediaProgressEntriesCompanion>[
            MediaProgressEntriesCompanion.insert(
              serverId: serverId,
              libraryItemId: itemId,
              durationSec: Value<double>(dur),
              localPositionSec: Value<double>(pos),
              serverPositionSec: Value<double>(pos),
              lastSyncedPositionSec: Value<double>(pos),
              progress: Value<double>(ratio),
              isFinished: Value<bool>(finished),
              hideFromContinueListening: Value<bool>(
                entry.hideFromContinueListening,
              ),
              localUpdatedAtMs: Value<int>(entry.serverUpdatedAtMs),
              serverUpdatedAtMs: Value<int>(entry.serverUpdatedAtMs),
              syncState: const Value<String>('synced'),
            ),
          ],
        );
        await _database.deleteProgressMutationsForItem(serverId, itemId);
    }
  }

  void _onConnectivityChanged(NetworkConnectionType next) {
    final wasOffline = _lastConnection == NetworkConnectionType.offline;
    _lastConnection = next;
    if (wasOffline && next != NetworkConnectionType.offline) {
      unawaited(flushPendingMutations());
    }
  }

  void _handleAuthChanged() {
    _bindServer(_authController.session?.serverId);
  }

  void _bindServer(String? serverId) {
    if (_boundServerId == serverId) return;
    _boundServerId = serverId;
    unawaited(_pendingCountSub?.cancel());
    unawaited(_conflictsSub?.cancel());
    _pendingCountSub = null;
    _conflictsSub = null;

    if (serverId == null) {
      _pendingCount = 0;
      _conflicts = const <ConflictedProgressRow>[];
      if (!_disposed) notifyListeners();
      return;
    }

    _pendingCountSub = _database.watchPendingSyncCount(serverId).listen((
      count,
    ) {
      if (_disposed) return;
      _pendingCount = count;
      notifyListeners();
    });
    _conflictsSub = _database.watchConflictedProgress(serverId).listen((rows) {
      if (_disposed) return;
      _conflicts = rows;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _disposed = true;
    _authController.removeListener(_handleAuthChanged);
    unawaited(_connectivitySub?.cancel());
    unawaited(_pendingCountSub?.cancel());
    unawaited(_conflictsSub?.cancel());
    super.dispose();
  }
}
