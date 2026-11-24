import 'dart:io';

import 'package:checks/checks.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:shelf_plus/core/database/app_database.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/network/abs_api_client.dart';
import 'package:shelf_plus/core/network/auth_tokens.dart';
import 'package:shelf_plus/core/network/connectivity_service.dart';
import 'package:shelf_plus/features/auth/data/auth_repository_impl.dart';
import 'package:shelf_plus/features/auth/domain/server_session.dart';
import 'package:shelf_plus/features/auth/presentation/auth_controller.dart';
import 'package:shelf_plus/features/downloads/data/dio_download_transport.dart';
import 'package:shelf_plus/features/downloads/domain/download_models.dart';
import 'package:shelf_plus/features/downloads/presentation/download_controller.dart';

import '../../../fakes/fake_connectivity_service.dart';
import '../../../fakes/in_memory_secure_storage_service.dart';
import '../../../fakes/mock_abs_server.dart';
import '../../../fixtures/abs_library_fixtures.dart';

void main() {
  group('DownloadController & DioDownloadTransport', () {
    late MockAbsServer server;
    late AppDatabase db;
    late FakeConnectivityService connectivity;
    late AuthController authController;
    late DownloadController downloadController;
    late Directory tempRoot;
    late AbsApiClient apiClient;

    setUp(() async {
      server = await MockAbsServer.start();
      tempRoot = await Directory.systemTemp.createTemp('shelf_plus_dl_unit_');
      db = AppDatabase.inMemory();
      final storage = InMemorySecureStorageService();
      final credentialsStore = AuthCredentialsStore(
        database: db,
        secureStorage: storage,
      );
      await db.saveActiveServer(
        ServerProfilesCompanion.insert(
          id: 'srv-1',
          baseUrl: server.baseUrl,
          displayName: 'Test ABS',
          username: 'reader',
          userId: 'abs-user-1',
          supportsRefreshTokens: const Value<bool>(true),
          lastConnectedAt: DateTime.utc(2026, 6),
        ),
      );
      await credentialsStore.saveTokensForServer(
        'srv-1',
        AuthTokens(
          accessToken: server.currentAccessToken,
          refreshToken: server.currentRefreshToken,
        ),
      );
      await db.upsertLibraryItems('srv-1', <LibraryItemsCompanion>[
        LibraryItemsCompanion.insert(
          serverId: 'srv-1',
          id: 'item-1',
          libraryId: 'lib-main',
          title: 'Project Hail Mary',
          durationSec: const Value<double>(58200),
          hasCover: const Value<bool>(true),
        ),
      ]);

      final logger = AppLogger(level: Level.FINE, forwardToDeveloperLog: false);
      apiClient = AbsApiClient.create(
        loadBaseUrl: credentialsStore.loadActiveBaseUrl,
        loadTokens: credentialsStore.loadActiveTokens,
        saveTokens: credentialsStore.saveActiveTokens,
        loadCustomHeaders: credentialsStore.loadActiveCustomHeaders,
        onSessionExpired: () async {},
        logger: logger,
      );
      final authRepo = AuthRepositoryImpl(
        apiClient: apiClient,
        database: db,
        credentialsStore: credentialsStore,
        logger: logger,
      );
      authController = AuthController(
        authRepository: authRepo,
        initialStatus: AuthStatus.authenticated,
        initialSession: ServerSession(
          serverId: 'srv-1',
          baseUrl: server.baseUrl,
          displayName: 'Test ABS',
          userId: 'abs-user-1',
          username: 'reader',
          supportsRefreshTokens: true,
        ),
      );
      connectivity = FakeConnectivityService();
      downloadController = DownloadController(
        apiClient: apiClient,
        database: db,
        authController: authController,
        connectivityService: connectivity,
        transport: DioDownloadTransport(apiClient.authenticatedDio),
        logger: logger,
        getDownloadsRoot: () async => tempRoot,
      );
    });

    tearDown(() async {
      downloadController.dispose();
      await connectivity.dispose();
      authController.dispose();
      await db.close();
      await server.close();
      if (tempRoot.existsSync()) {
        await tempRoot.delete(recursive: true);
      }
    });

    test('downloads multi-track book, resolves local tracks, and honors '
        'auto-delete when finished', () async {
      await downloadController.enqueueDownload(AbsLibraryFixtures.bookOne);
      await Future<void>.delayed(const Duration(milliseconds: 250));

      final task = downloadController.taskForBook('item-1');
      check(task?.status).equals(DownloadStatus.completed.name);
      check(downloadController.totalBytesUsed).equals(4096);

      final localTracks = await downloadController.resolveLocalTracks(
        'srv-1',
        'item-1',
      );
      check(localTracks).isNotNull();
      check(localTracks!.length).equals(2);
      check(File(localTracks.first.localPath).readAsBytesSync())
          .deepEquals(server.mockAudioBytes);

      await downloadController.setAutoDeleteFinished(true);
      await downloadController.handleBookFinished('item-1');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      check(downloadController.taskForBook('item-1')).isNull;
      check(File(localTracks.first.localPath).existsSync()).isFalse;
    });

    test(
      'resumes partial HTTP Range downloads and enforces Wi-Fi only',
      () async {
        final dest = '${tempRoot.path}/partial_track.m4b';
        final partFile = File('$dest.part');
        await partFile.writeAsBytes(server.mockAudioBytes.sublist(0, 512));

        final transport = DioDownloadTransport(apiClient.authenticatedDio);
        final result = await transport.downloadTrack(
          url: '${server.baseUrl}/api/items/item-1/file/ino-1',
          destinationPath: dest,
          existingBytes: 512,
          cancelToken: CancelToken(),
        );

        check(server.audioFileRangeHeaders.last).equals('bytes=512-');
        check(result.totalBytes).equals(server.mockAudioBytes.length);
        check(File(dest).readAsBytesSync()).deepEquals(server.mockAudioBytes);

        // Cellular when wifiOnly == true puts task into Waiting for Wi-Fi.
        connectivity.setStatus(NetworkConnectionType.cellular);
        await downloadController.enqueueDownload(AbsLibraryFixtures.bookOne);
        await Future<void>.delayed(const Duration(milliseconds: 50));
        var paused = downloadController.taskForBook('item-1');
        check(paused?.status).equals(DownloadStatus.paused.name);
        check(paused?.errorMessage)
            .equals(DownloadController.waitingForWifiMarker);

        // Restoring Wi-Fi auto-resumes waiting tasks cleanly.
        connectivity.setStatus(NetworkConnectionType.wifi);
        await Future<void>.delayed(const Duration(milliseconds: 250));
        paused = downloadController.taskForBook('item-1');
        check(paused?.status).equals(DownloadStatus.completed.name);
      },
    );
  });
}
