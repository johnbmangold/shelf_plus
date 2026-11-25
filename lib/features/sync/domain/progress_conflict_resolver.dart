import 'package:drift/drift.dart' show Value;
import 'package:shelf_plus/core/database/app_database.dart';
import 'package:shelf_plus/core/network/abs_library_models.dart';

/// Result of 3-way merging remote server progress against cached device state.
enum ProgressMergeOutcome {
  /// No unsynced local divergence exists; remote state is adopted cleanly.
  acceptRemote,

  /// Local progress diverged while remote remained near the baseline.
  keepLocalPendingPush,

  /// Both sides moved to effectively the same position within tolerance.
  alreadySynced,

  /// Both device and server progressed independently past tolerance.
  conflict,
}

/// User choice resolving a detected progress conflict.
enum ConflictResolutionChoice {
  /// Preserve this device's listening position and push it to the server.
  keepDevice,

  /// Discard device divergence and adopt the server's listening position.
  useServer,
}

/// Pure 3-way merge resolver comparing local position, server position, and
/// `lastSyncedPositionSec` against a 30-second tolerance window without
/// trusting wall-clock timestamps across devices.
abstract final class ProgressConflictResolver {
  /// Tolerance window in seconds treated as equivalent progress.
  static const double toleranceSec = 30;

  /// Determines the merge outcome for [local] vs [remotePositionSec] and
  /// [remoteIsFinished].
  static ProgressMergeOutcome resolve({
    required MediaProgressEntry? local,
    required double remotePositionSec,
    bool remoteIsFinished = false,
  }) {
    if (local == null) return ProgressMergeOutcome.acceptRemote;

    final baseline = local.lastSyncedPositionSec;
    final localPos = local.localPositionSec;
    final localChanged =
        (localPos - baseline).abs() > toleranceSec ||
        local.syncState == 'pendingPush';
    final remoteChanged =
        (remotePositionSec - baseline).abs() > toleranceSec ||
        (remoteIsFinished != local.isFinished &&
            (remotePositionSec - localPos).abs() > toleranceSec);

    if (local.syncState == 'conflict') {
      if ((remotePositionSec - localPos).abs() <= toleranceSec &&
          remoteIsFinished == local.isFinished) {
        return ProgressMergeOutcome.alreadySynced;
      }
      return ProgressMergeOutcome.conflict;
    }

    if (!localChanged) {
      return ProgressMergeOutcome.acceptRemote;
    }
    if (!remoteChanged) {
      return ProgressMergeOutcome.keepLocalPendingPush;
    }
    if ((remotePositionSec - localPos).abs() <= toleranceSec &&
        remoteIsFinished == local.isFinished) {
      return ProgressMergeOutcome.alreadySynced;
    }
    return ProgressMergeOutcome.conflict;
  }

  /// Produces a [MediaProgressEntriesCompanion] merging [remote] onto
  /// optional [local] progress without losing unsynced local changes.
  static MediaProgressEntriesCompanion mergeToCompanion({
    required String serverId,
    required AbsMediaProgressDto remote,
    required MediaProgressEntry? local,
  }) {
    final outcome = resolve(
      local: local,
      remotePositionSec: remote.currentTimeSec,
      remoteIsFinished: remote.isFinished,
    );

    switch (outcome) {
      case ProgressMergeOutcome.acceptRemote:
        return MediaProgressEntriesCompanion.insert(
          serverId: serverId,
          libraryItemId: remote.libraryItemId,
          durationSec: Value<double>(remote.durationSec),
          localPositionSec: Value<double>(remote.currentTimeSec),
          serverPositionSec: Value<double>(remote.currentTimeSec),
          lastSyncedPositionSec: Value<double>(remote.currentTimeSec),
          progress: Value<double>(remote.progress),
          isFinished: Value<bool>(remote.isFinished),
          hideFromContinueListening: Value<bool>(
            remote.hideFromContinueListening,
          ),
          localUpdatedAtMs: Value<int>(remote.lastUpdateMs),
          serverUpdatedAtMs: Value<int>(remote.lastUpdateMs),
          syncState: const Value<String>('synced'),
        );
      case ProgressMergeOutcome.alreadySynced:
        final effectivePos = local!.localPositionSec;
        return MediaProgressEntriesCompanion.insert(
          serverId: serverId,
          libraryItemId: remote.libraryItemId,
          durationSec: Value<double>(
            remote.durationSec > 0 ? remote.durationSec : local.durationSec,
          ),
          localPositionSec: Value<double>(effectivePos),
          serverPositionSec: Value<double>(remote.currentTimeSec),
          lastSyncedPositionSec: Value<double>(effectivePos),
          progress: Value<double>(local.progress),
          isFinished: Value<bool>(local.isFinished || remote.isFinished),
          hideFromContinueListening: Value<bool>(
            remote.hideFromContinueListening,
          ),
          localUpdatedAtMs: Value<int>(local.localUpdatedAtMs),
          serverUpdatedAtMs: Value<int>(remote.lastUpdateMs),
          syncState: const Value<String>('synced'),
        );
      case ProgressMergeOutcome.keepLocalPendingPush:
        return MediaProgressEntriesCompanion.insert(
          serverId: serverId,
          libraryItemId: remote.libraryItemId,
          durationSec: Value<double>(
            local!.durationSec > 0 ? local.durationSec : remote.durationSec,
          ),
          localPositionSec: Value<double>(local.localPositionSec),
          serverPositionSec: Value<double>(remote.currentTimeSec),
          lastSyncedPositionSec: Value<double>(local.lastSyncedPositionSec),
          progress: Value<double>(local.progress),
          isFinished: Value<bool>(local.isFinished),
          hideFromContinueListening: Value<bool>(
            remote.hideFromContinueListening,
          ),
          localUpdatedAtMs: Value<int>(local.localUpdatedAtMs),
          serverUpdatedAtMs: Value<int>(remote.lastUpdateMs),
          syncState: const Value<String>('pendingPush'),
        );
      case ProgressMergeOutcome.conflict:
        return MediaProgressEntriesCompanion.insert(
          serverId: serverId,
          libraryItemId: remote.libraryItemId,
          durationSec: Value<double>(
            local!.durationSec > 0 ? local.durationSec : remote.durationSec,
          ),
          localPositionSec: Value<double>(local.localPositionSec),
          serverPositionSec: Value<double>(remote.currentTimeSec),
          lastSyncedPositionSec: Value<double>(local.lastSyncedPositionSec),
          progress: Value<double>(local.progress),
          isFinished: Value<bool>(local.isFinished),
          hideFromContinueListening: Value<bool>(
            remote.hideFromContinueListening,
          ),
          localUpdatedAtMs: Value<int>(local.localUpdatedAtMs),
          serverUpdatedAtMs: Value<int>(remote.lastUpdateMs),
          syncState: const Value<String>('conflict'),
        );
    }
  }
}
