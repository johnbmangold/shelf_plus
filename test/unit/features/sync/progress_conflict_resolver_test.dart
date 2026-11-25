import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_plus/core/database/app_database.dart';
import 'package:shelf_plus/core/network/abs_library_models.dart';
import 'package:shelf_plus/features/sync/domain/progress_conflict_resolver.dart';

void main() {
  group('ProgressConflictResolver', () {
    const baseTime = 1718000000000;

    MediaProgressEntry entry({
      required double local,
      required double server,
      required double baseline,
      String syncState = 'synced',
      bool isFinished = false,
      int localUpdatedAtMs = baseTime,
      int serverUpdatedAtMs = baseTime,
    }) {
      return MediaProgressEntry(
        serverId: 'srv-1',
        libraryItemId: 'item-1',
        durationSec: 3600,
        localPositionSec: local,
        serverPositionSec: server,
        lastSyncedPositionSec: baseline,
        progress: local / 3600,
        isFinished: isFinished,
        hideFromContinueListening: false,
        localUpdatedAtMs: localUpdatedAtMs,
        serverUpdatedAtMs: serverUpdatedAtMs,
        syncState: syncState,
      );
    }

    AbsMediaProgressDto remote(
      double pos, {
      bool isFinished = false,
      int lastUpdateMs = baseTime + 5000,
    }) => AbsMediaProgressDto(
      libraryItemId: 'item-1',
      durationSec: 3600,
      currentTimeSec: pos,
      progress: pos / 3600,
      isFinished: isFinished,
      hideFromContinueListening: false,
      lastUpdateMs: lastUpdateMs,
    );

    test('accepts remote when no local progress or no local divergence', () {
      check(
        ProgressConflictResolver.resolve(local: null, remotePositionSec: 400),
      ).equals(ProgressMergeOutcome.acceptRemote);

      final synced = entry(local: 100, server: 100, baseline: 100);
      check(
        ProgressConflictResolver.resolve(local: synced, remotePositionSec: 500),
      ).equals(ProgressMergeOutcome.acceptRemote);

      final companion = ProgressConflictResolver.mergeToCompanion(
        serverId: 'srv-1',
        remote: remote(500),
        local: synced,
      );
      check(companion.localPositionSec.value).equals(500);
      check(companion.syncState.value).equals('synced');
    });

    test(
      'preserves local pendingPush when server did not move past 30s tolerance',
      () {
        final pending = entry(
          local: 650,
          server: 100,
          baseline: 100,
          syncState: 'pendingPush',
        );
        check(
          ProgressConflictResolver.resolve(
            local: pending,
            remotePositionSec: 125,
          ),
        ).equals(ProgressMergeOutcome.keepLocalPendingPush);

        final companion = ProgressConflictResolver.mergeToCompanion(
          serverId: 'srv-1',
          remote: remote(125),
          local: pending,
        );
        check(companion.localPositionSec.value).equals(650);
        check(companion.syncState.value).equals('pendingPush');
      },
    );

    test('marks alreadySynced when both sides moved within 30s tolerance', () {
      final pending = entry(
        local: 625,
        server: 100,
        baseline: 100,
        syncState: 'pendingPush',
      );
      check(
        ProgressConflictResolver.resolve(
          local: pending,
          remotePositionSec: 600,
        ),
      ).equals(ProgressMergeOutcome.alreadySynced);

      final companion = ProgressConflictResolver.mergeToCompanion(
        serverId: 'srv-1',
        remote: remote(600),
        local: pending,
      );
      check(companion.syncState.value).equals('synced');
      check(companion.lastSyncedPositionSec.value).equals(625);
    });

    test('flags conflict when device and server diverged past 30s', () {
      final pending = entry(
        local: 850,
        server: 100,
        baseline: 100,
        syncState: 'pendingPush',
      );
      check(
        ProgressConflictResolver.resolve(
          local: pending,
          remotePositionSec: 1400,
        ),
      ).equals(ProgressMergeOutcome.conflict);

      final companion = ProgressConflictResolver.mergeToCompanion(
        serverId: 'srv-1',
        remote: remote(1400),
        local: pending,
      );
      check(companion.localPositionSec.value).equals(850);
      check(companion.serverPositionSec.value).equals(1400);
      check(companion.syncState.value).equals('conflict');
    });

    test('remains resilient to severe device/server clock skew', () {
      // Device clock is 10 hours behind server, yet local pending progress is
      // preserved when server stayed within tolerance of baseline.
      final deviceBehind = entry(
        local: 900,
        server: 100,
        baseline: 100,
        syncState: 'pendingPush',
        localUpdatedAtMs: baseTime - 36000000,
      );
      final kept = ProgressConflictResolver.mergeToCompanion(
        serverId: 'srv-1',
        remote: remote(115, lastUpdateMs: baseTime + 36000000),
        local: deviceBehind,
      );
      check(kept.syncState.value).equals('pendingPush');
      check(kept.localPositionSec.value).equals(900);

      // Device clock is 10 hours ahead, yet true divergence still flags
      // conflict instead of silently clobbering the server position.
      final deviceAhead = entry(
        local: 900,
        server: 100,
        baseline: 100,
        syncState: 'pendingPush',
        localUpdatedAtMs: baseTime + 36000000,
      );
      final conflicted = ProgressConflictResolver.mergeToCompanion(
        serverId: 'srv-1',
        remote: remote(1800, lastUpdateMs: baseTime - 36000000),
        local: deviceAhead,
      );
      check(conflicted.syncState.value).equals('conflict');
    });

    test('handles finished vs unfinished divergence and conflict recovery', () {
      final localUnfinished = entry(
        local: 1200,
        server: 100,
        baseline: 100,
        syncState: 'pendingPush',
      );
      final finishedConflict = ProgressConflictResolver.mergeToCompanion(
        serverId: 'srv-1',
        remote: remote(3600, isFinished: true),
        local: localUnfinished,
      );
      check(finishedConflict.syncState.value).equals('conflict');

      // Existing conflict auto-clears if remote catches up within 30s and
      // matches finished state.
      final existingConflict = entry(
        local: 1200,
        server: 1800,
        baseline: 100,
        syncState: 'conflict',
      );
      check(
        ProgressConflictResolver.resolve(
          local: existingConflict,
          remotePositionSec: 1215,
        ),
      ).equals(ProgressMergeOutcome.alreadySynced);
      check(
        ProgressConflictResolver.resolve(
          local: existingConflict,
          remotePositionSec: 1800,
        ),
      ).equals(ProgressMergeOutcome.conflict);
    });
  });
}
