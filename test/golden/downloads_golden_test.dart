import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/database/app_database.dart';
import 'package:shelf_plus/core/network/abs_library_models.dart';
import 'package:shelf_plus/core/theme/app_theme.dart';
import 'package:shelf_plus/features/downloads/presentation/downloads_screen.dart';
import 'package:shelf_plus/features/sync/domain/progress_conflict_resolver.dart';

import '../fixtures/abs_library_fixtures.dart';
import '../helpers/pump_app.dart';

void main() {
  testWidgets(
    'DownloadsScreen light golden with downloaded book and conflict',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 892));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final deps = createTestDependencies();
      addTearDown(() async {
        deps.dispose();
        await Future<void>.delayed(Duration.zero);
      });

      // The in-memory database completes via microtasks, so seed it inside
      // the fake-async zone where the controllers' Drift streams live.
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
      await deps.downloadController.enqueueDownload(AbsLibraryFixtures.bookOne);
      await tester.pump(const Duration(milliseconds: 120));
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

      await tester.pumpLocalizedWidget(
        DownloadsScreen(
          downloadController: deps.downloadController,
          syncController: deps.offlineSyncController,
          playerController: deps.playerController,
          libraryRepository: deps.libraryRepository,
          authController: deps.authController,
          loadImageHeaders: deps.credentialsStore.loadActiveRequestHeaders,
          onOpenPlayer: () {},
          enableNetworkImages: false,
        ),
        theme: AppTheme.light(useGoogleFonts: false),
      );

      await expectLater(
        find.byType(DownloadsScreen),
        matchesGoldenFile('goldens/downloads_light.png'),
      );
    },
  );
}
