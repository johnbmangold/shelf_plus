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
import 'package:shelf_plus/core/theme/app_theme_mode.dart';
import 'package:shelf_plus/features/downloads/domain/download_models.dart';

import '../../test/fakes/fake_abs_socket_service.dart';
import '../../test/fakes/fake_audio_player_engine.dart';
import '../../test/fakes/fake_connectivity_service.dart';
import '../../test/fakes/fake_download_transport.dart';
import '../../test/fakes/fake_log_exporter.dart';
import '../../test/fakes/in_memory_secure_storage_service.dart';
import '../../test/fakes/mock_abs_server.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Complete v1 E2E journey: auth, library sync, search, offline download, '
    'local playback, bookmark, conflict resolution, theme, diagnostics, '
    'and sign out',
    (tester) async {
      final server = await MockAbsServer.start(
        basePathPrefix: '/audiobookshelf',
        requiredHeaders: const <String, String>{
          'CF-Access-Client-Secret': 'proxy-secret-v1',
        },
      );
      addTearDown(server.close);

      final tempDir = Directory.systemTemp.createTempSync('shelf_v1_e2e_');
      addTearDown(() {
        if (tempDir.existsSync()) {
          tempDir.deleteSync(recursive: true);
        }
      });

      final connectivity = FakeConnectivityService();
      final engine = FakeAudioPlayerEngine();
      final exporter = FakeLogExporter();
      final storage = InMemorySecureStorageService();
      final db = AppDatabase.inMemory();
      final deps = AppDependencies.create(
        flavorConfig: const FlavorConfig.dev(),
        database: db,
        secureStorage: storage,
        socketService: FakeAbsSocketService(),
        audioPlayerEngine: engine,
        connectivityService: connectivity,
        downloadTransport: FakeDownloadTransport(),
        getDownloadsRoot: () async => tempDir,
        logExporter: exporter,
        useGoogleFonts: false,
        enableNetworkImages: false,
        autoSyncOnStart: false,
      )..logger.level = Level.FINE;
      addTearDown(deps.dispose);

      await deps.authController.initialize();
      await tester.pumpWidget(ShelfPlusApp(dependencies: deps));
      await tester.pumpAndSettle();

      // 1. Authenticate against reverse-proxy subpath server.
      await tester.enterText(
        find.byKey(const Key('login_server_url_field')),
        server.baseUrl,
      );
      await tester.tap(find.byKey(const Key('login_custom_headers_tile')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('login_add_header_button')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('custom_header_name_0')),
        'CF-Access-Client-Secret',
      );
      await tester.enterText(
        find.byKey(const Key('custom_header_value_0')),
        'proxy-secret-v1',
      );
      await tester.tap(find.byKey(const Key('login_test_connection_button')));
      await tester.pumpAndSettle();
      check(find.text('Connected (2.26.0)').evaluate().length).equals(1);

      await tester.enterText(
        find.byKey(const Key('login_username_field')),
        server.validUsername,
      );
      await tester.enterText(
        find.byKey(const Key('login_password_field')),
        server.validPassword,
      );
      await tester.ensureVisible(find.byKey(const Key('login_sign_in_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('login_sign_in_button')));
      await tester.pumpAndSettle();

      // 2. Sync library and browse Home & Library tabs.
      final session = deps.authController.session!;
      await deps.libraryRepository.syncAll(session);
      await tester.pumpAndSettle();
      check(find.text('Project Hail Mary').evaluate().length).isGreaterThan(0);

      await tester.tap(find.text('Library'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('home_hero_book_item-1')).first);
      await tester.pumpAndSettle();

      // 3. Download book for offline playback.
      await tester.tap(find.byKey(const Key('book_detail_download_button')));
      await Future<void>.delayed(const Duration(milliseconds: 120));
      await tester.pumpAndSettle();
      check(deps.downloadController.taskForBook('item-1')?.status)
          .equals(DownloadStatus.completed.name);

      // 4. Go offline, play locally, create bookmark, and pause.
      connectivity.setStatus(NetworkConnectionType.offline);
      await tester.tap(find.byKey(const Key('book_detail_play_button')));
      await tester.pumpAndSettle();
      check(deps.playerController.playMethod).equals(AbsPlayMethod.local);
      check(find.text('Downloaded').evaluate().length).equals(1);

      await deps.playerController.seekToBookPosition(720);
      await deps.playerController.createBookmark(title: 'E2E Bookmark');
      await deps.playerController.pause();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      await tester.tap(find.byKey(const Key('player_close_button')));
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();

      // 5. Simulate concurrent server advance -> reconnect -> resolve conflict.
      server.serverProgressOverrides['item-1'] = <String, Object?>{
        'libraryItemId': 'item-1',
        'duration': 58200,
        'currentTime': 2400,
        'progress': 2400 / 58200,
        'isFinished': false,
        'hideFromContinueListening': false,
        'lastUpdate': DateTime.now().toUtc().millisecondsSinceEpoch,
      };
      connectivity.setStatus(NetworkConnectionType.wifi);
      await deps.libraryRepository.syncAll(session);

      await tester.tap(find.text('Downloads'));
      await tester.pumpAndSettle();
      check(
        find.byKey(const Key('downloads_conflict_banner')).evaluate().length,
      ).equals(1);

      await tester.tap(
        find.byKey(const Key('downloads_conflict_resolve_button')),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('conflict_use_server_item-1')));
      await tester.pumpAndSettle();

      final history = await db
          .watchPlaybackHistory(session.serverId, 'item-1')
          .first;
      check(history.any((h) => h.reason == 'conflict_device')).isTrue;
      check(history.any((h) => h.reason == 'conflict_server')).isTrue;

      // 6. Switch theme to AMOLED, export redacted diagnostics, and sign out.
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('AMOLED'));
      await tester.pumpAndSettle();
      check(deps.themeController.mode).equals(AppThemeMode.amoled);

      await tester.ensureVisible(
        find.byKey(const Key('settings_diagnostics_tile')),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('settings_diagnostics_tile')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('diagnostics_export_button')));
      await tester.pumpAndSettle();
      check(exporter.exportedPayloads.length).equals(1);
      check(exporter.exportedPayloads.single.contains('proxy-secret-v1'))
          .isFalse;

      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.ensureVisible(
        find.byKey(const Key('settings_sign_out_tile')),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('settings_sign_out_tile')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('confirm_sign_out_button')));
      await tester.pumpAndSettle();
      check(find.text('Connect to Audiobookshelf').evaluate().length).equals(1);
    },
  );
}
