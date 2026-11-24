import 'package:checks/checks.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/database/app_database.dart';
import 'package:shelf_plus/core/network/abs_library_models.dart';
import 'package:shelf_plus/core/network/connectivity_service.dart';
import 'package:shelf_plus/features/downloads/domain/download_models.dart';
import 'package:shelf_plus/features/library/domain/library_models.dart';
import 'package:shelf_plus/features/player/presentation/full_player_screen.dart';
import 'package:shelf_plus/features/sync/domain/progress_conflict_resolver.dart';

import '../../../fakes/fake_connectivity_service.dart';
import '../../../fakes/fake_library_repository.dart';
import '../../../fixtures/abs_library_fixtures.dart';
import '../../../helpers/pump_app.dart';

void main() {
  group('DownloadsScreen & Conflict Resolution', () {
    testWidgets(
      'displays policy switches, download cards, sync conflict banner, and '
      'plays downloaded audiobooks offline',
      (tester) async {
        final connectivity = FakeConnectivityService();
        final fakeRepo = FakeLibraryRepository(
          books: const <BookSummary>[AbsLibraryFixtures.bookOne],
        );
        final deps = createTestDependencies(
          connectivityService: connectivity,
          libraryRepository: fakeRepo,
        );

        await deps.database.upsertLibraryItems(
          'test-server-1',
          <LibraryItemsCompanion>[
            LibraryItemsCompanion.insert(
              serverId: 'test-server-1',
              id: 'item-1',
              libraryId: 'lib-main',
              title: 'Project Hail Mary',
              authors: const Value<String>('Andy Weir'),
              durationSec: const Value<double>(58200),
            ),
          ],
        );
        await deps.downloadController.enqueueDownload(
          AbsLibraryFixtures.bookOne,
        );
        await tester.pump(const Duration(milliseconds: 120));

        // Queue an offline mutation and create a progress conflict.
        connectivity.setStatus(NetworkConnectionType.offline);
        await deps.offlineSyncController.enqueueProgressSync(
          itemId: 'item-1',
          currentTimeSec: 900,
          durationSec: 58200,
          isFinished: false,
        );
        await deps.database.upsertMediaProgressEntries(
          <MediaProgressEntriesCompanion>[
            ProgressConflictResolver.mergeToCompanion(
              serverId: 'test-server-1',
              remote: const AbsMediaProgressDto(
                libraryItemId: 'item-1',
                durationSec: 58200,
                currentTimeSec: 1800,
                progress: 1800 / 58200,
                isFinished: false,
                hideFromContinueListening: false,
                lastUpdateMs: 9000,
              ),
              local: const MediaProgressEntry(
                serverId: 'test-server-1',
                libraryItemId: 'item-1',
                durationSec: 58200,
                localPositionSec: 900,
                serverPositionSec: 100,
                lastSyncedPositionSec: 100,
                progress: 900 / 58200,
                isFinished: false,
                hideFromContinueListening: false,
                localUpdatedAtMs: 8000,
                serverUpdatedAtMs: 7000,
                syncState: 'pendingPush',
              ),
            ),
          ],
        );

        await tester.pumpShelfApp(dependencies: deps);

        await tester.tap(find.text('Downloads'));
        await tester.pumpAndSettle();

        check(find.byKey(const Key('download_card_item-1')).evaluate().length)
            .equals(1);
        check(
          find.byKey(const Key('downloads_conflict_banner')).evaluate().length,
        ).equals(1);

        // Toggle Wi-Fi only and Auto-delete switches.
        await tester.tap(find.byKey(const Key('downloads_wifi_only_switch')));
        await tester.pumpAndSettle();
        check(deps.downloadController.wifiOnly).isFalse;
        await tester.tap(find.byKey(const Key('downloads_auto_delete_switch')));
        await tester.pumpAndSettle();
        check(deps.downloadController.autoDeleteFinished).isTrue;

        // Open conflict sheet & choose server position.
        await tester.tap(
          find.byKey(const Key('downloads_conflict_resolve_button')),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('conflict_use_server_item-1')));
        await tester.pumpAndSettle();
        check(find.byKey(const Key('downloads_conflict_banner')).evaluate())
            .isEmpty;

        // Play downloaded book offline and confirm Downloaded badge appears.
        await tester.tap(find.byKey(const Key('download_play_item-1')));
        await tester.pumpAndSettle();
        check(find.byType(FullPlayerScreen).evaluate().length).equals(1);
        check(find.text('Downloaded').evaluate().length).equals(1);

        // Return to Downloads and delete downloaded files cleanly.
        await tester.tap(find.byKey(const Key('player_close_button')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('download_delete_item-1')));
        await tester.pumpAndSettle();
        await tester.tap(
          find.byKey(const Key('confirm_delete_download_item-1')),
        );
        await tester.pumpAndSettle();

        check(deps.downloadController.taskForBook('item-1')).isNull;
        check(ByteFormatter.format(1536 * 1024)).equals('1.5 MB');
      },
    );
  });
}
