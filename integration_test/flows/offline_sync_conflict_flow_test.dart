import 'dart:io';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/app/app.dart';
import 'package:shelf_plus/app/app_dependencies.dart';
import 'package:shelf_plus/app/flavor_config.dart';
import 'package:shelf_plus/core/database/app_database.dart';
import 'package:shelf_plus/core/network/abs_playback_models.dart';
import 'package:shelf_plus/core/network/connectivity_service.dart';
import 'package:shelf_plus/features/downloads/domain/download_models.dart';

import '../../test/fakes/fake_abs_socket_service.dart';
import '../../test/fakes/fake_audio_player_engine.dart';
import '../../test/fakes/fake_connectivity_service.dart';
import '../../test/fakes/fake_download_transport.dart';
import '../../test/fakes/fake_log_exporter.dart';
import '../../test/fakes/in_memory_secure_storage_service.dart';
import '../../test/fakes/mock_abs_server.dart';
import '../../test/fixtures/abs_library_fixtures.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'E2E offline download, local playback, concurrent server advance, '
    'reconnect conflict banner, resolution, and dual-position history',
    (tester) async {
      final server = await MockAbsServer.start();
      addTearDown(server.close);

      final tempDir = Directory.systemTemp.createTempSync('shelf_e2e_sync_');
      addTearDown(() {
        if (tempDir.existsSync()) {
          tempDir.deleteSync(recursive: true);
        }
      });

      final connectivity = FakeConnectivityService();
      final engine = FakeAudioPlayerEngine();
      final db = AppDatabase.inMemory();
      final deps = AppDependencies.create(
        flavorConfig: const FlavorConfig.dev(),
        database: db,
        secureStorage: InMemorySecureStorageService(),
        socketService: FakeAbsSocketService(),
        audioPlayerEngine: engine,
        connectivityService: connectivity,
        downloadTransport: FakeDownloadTransport(),
        getDownloadsRoot: () async => tempDir,
        logExporter: FakeLogExporter(),
        useGoogleFonts: false,
        enableNetworkImages: false,
        autoSyncOnStart: false,
      )..logger.level = Level.FINE;
      addTearDown(deps.dispose);

      // 1. Authenticate against embedded MockAbsServer and sync library.
      await deps.authController.initialize();
      final session = await deps.authRepository.login(
        serverUrl: server.baseUrl,
        username: server.validUsername,
        password: server.validPassword,
      );
      deps.authController.setAuthenticated(session);
      await deps.libraryRepository.syncAll(session);

      // 2. Download book locally while online on Wi-Fi.
      await deps.downloadController.enqueueDownload(AbsLibraryFixtures.bookOne);
      await Future<void>.delayed(const Duration(milliseconds: 120));
      check(deps.downloadController.taskForBook('item-1')?.status)
          .equals(DownloadStatus.completed.name);

      // 3. Go offline and play downloaded audiobook locally.
      connectivity.setStatus(NetworkConnectionType.offline);
      await deps.playerController.playBook(
        AbsLibraryFixtures.bookOne,
        startPositionSec: 600,
      );
      check(deps.playerController.playMethod).equals(AbsPlayMethod.local);

      // Advance position offline and pause (queues UUIDv4 local session).
      await deps.playerController.seekToBookPosition(950);
      await deps.playerController.pause();
      await Future<void>.delayed(const Duration(milliseconds: 60));
      check(deps.offlineSyncController.pendingCount).isGreaterThan(0);

      // 4. Simulate another device advancing the same book on the server.
      server.serverProgressOverrides['item-1'] = <String, Object?>{
        'libraryItemId': 'item-1',
        'duration': 58200,
        'currentTime': 2100,
        'progress': 2100 / 58200,
        'isFinished': false,
        'hideFromContinueListening': false,
        'lastUpdate': DateTime.now().toUtc().millisecondsSinceEpoch,
      };

      // 5. Reconnect and sync library -> conflict detected & banner shown.
      connectivity.setStatus(NetworkConnectionType.wifi);
      await deps.libraryRepository.syncAll(session);

      await tester.pumpWidget(ShelfPlusApp(dependencies: deps));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Downloads'));
      await tester.pumpAndSettle();
      check(
        find.byKey(const Key('downloads_conflict_banner')).evaluate().length,
      ).equals(1);

      // 6. Open conflict sheet and choose server position.
      await tester.tap(
        find.byKey(const Key('downloads_conflict_resolve_button')),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('conflict_use_server_item-1')));
      await tester.pumpAndSettle();

      check(find.byKey(const Key('downloads_conflict_banner')).evaluate())
          .isEmpty;

      // 7. Verify both device (950s) and server (2100s) positions are
      // preserved in playback_history for jump-back.
      final history = await db
          .watchPlaybackHistory(session.serverId, 'item-1')
          .first;
      final reasons = history.map((h) => h.reason).toSet();
      check(reasons.contains('conflict_device')).isTrue;
      check(reasons.contains('conflict_server')).isTrue;
      check(
        history.any(
          (h) =>
              h.reason == 'conflict_device' &&
              (h.positionSec - 950).abs() < 1.0,
        ),
      ).isTrue;
      check(
        history.any(
          (h) =>
              h.reason == 'conflict_server' &&
              (h.positionSec - 2100).abs() < 1.0,
        ),
      ).isTrue;
    },
  );
}
