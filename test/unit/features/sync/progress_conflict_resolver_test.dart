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
    }) {
      return MediaProgressEntry(
        serverId: 'srv-1',
        libraryItemId: 'item-1',
        durationSec: 3600,
        localPositionSec: local,
        serverPositionSec: server,
        lastSyncedPositionSec: baseline,
        progress: local / 3600,
        isFinished: false,
        hideFromContinueListening: false,
        localUpdatedAtMs: baseTime,
        serverUpdatedAtMs: baseTime,
        syncState: syncState,
      );
    }

    AbsMediaProgressDto remote(double pos) => AbsMediaProgressDto(
      libraryItemId: 'item-1',
      durationSec: 3600,
      currentTimeSec: pos,
      progress: pos / 3600,
      isFinished: false,
      hideFromContinueListening: false,
      lastUpdateMs: baseTime + 5000,
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
      'preserves local pendingPush when server did not move past tolerance',
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
            remotePositionSec: 103,
          ),
        ).equals(ProgressMergeOutcome.keepLocalPendingPush);

        final companion = ProgressConflictResolver.mergeToCompanion(
          serverId: 'srv-1',
          remote: remote(103),
          local: pending,
        );
        check(companion.localPositionSec.value).equals(650);
        check(companion.syncState.value).equals('pendingPush');
      },
    );

    test('marks alreadySynced when both sides moved within 5s tolerance', () {
      final pending = entry(
        local: 602,
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
      check(companion.lastSyncedPositionSec.value).equals(602);
    });

    test('flags conflict when device and server diverged independently', () {
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
  });
}
