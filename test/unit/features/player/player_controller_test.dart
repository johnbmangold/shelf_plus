import 'dart:io';

import 'package:checks/checks.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:shelf_plus/core/database/app_database.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/network/abs_api_client.dart';
import 'package:shelf_plus/core/network/abs_playback_models.dart';
import 'package:shelf_plus/core/network/auth_tokens.dart';
import 'package:shelf_plus/core/network/connectivity_service.dart';
import 'package:shelf_plus/features/auth/data/auth_repository_impl.dart';
import 'package:shelf_plus/features/auth/domain/server_session.dart';
import 'package:shelf_plus/features/auth/presentation/auth_controller.dart';
import 'package:shelf_plus/features/downloads/presentation/download_controller.dart';
import 'package:shelf_plus/features/library/domain/library_models.dart';
import 'package:shelf_plus/features/player/presentation/player_controller.dart';
import 'package:shelf_plus/features/sync/presentation/offline_sync_controller.dart';

import '../../../fakes/fake_abs_socket_service.dart';
import '../../../fakes/fake_audio_player_engine.dart';
import '../../../fakes/fake_connectivity_service.dart';
import '../../../fakes/fake_cover_theme_extractor.dart';
import '../../../fakes/fake_download_transport.dart';
import '../../../fakes/fake_shake_detector.dart';
import '../../../fakes/in_memory_secure_storage_service.dart';
import '../../../fakes/mock_abs_server.dart';
import '../../../fixtures/abs_library_fixtures.dart';

void main() {
  group('PlayerController', () {
    late MockAbsServer server;
    late AppDatabase db;
    late FakeAudioPlayerEngine engine;
    late FakeShakeDetector shakeDetector;
    late FakeAbsSocketService socketService;
    late AuthController authController;
    late AuthCredentialsStore credentialsStore;
    late PlayerController controller;
    late DateTime clock;

    setUp(() async {
      server = await MockAbsServer.start();
      clock = DateTime.utc(2026, 6, 1, 10);
      db = AppDatabase.inMemory();
      final storage = InMemorySecureStorageService();
      credentialsStore = AuthCredentialsStore(
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
          isActive: const Value<bool>(true),
          lastConnectedAt: clock,
        ),
      );
      await credentialsStore.saveTokensForServer(
        'srv-1',
        AuthTokens(
          accessToken: server.currentAccessToken,
          refreshToken: server.currentRefreshToken,
        ),
      );

      final logger = AppLogger(level: Level.FINE, forwardToDeveloperLog: false);
      final apiClient = AbsApiClient.create(
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

      engine = FakeAudioPlayerEngine();
      shakeDetector = FakeShakeDetector();
      socketService = FakeAbsSocketService();

      controller = PlayerController(
        apiClient: apiClient,
        database: db,
        authController: authController,
        credentialsStore: credentialsStore,
        engine: engine,
        socketService: socketService,
        coverThemeExtractor: FakeCoverThemeExtractor(),
        logger: logger,
        shakeDetector: shakeDetector,
        now: () => clock,
        deviceIdGenerator: () => 'device-123',
      );
    });

    tearDown(() async {
      controller.dispose();
      authController.dispose();
      await db.close();
      await server.close();
    });

    const chapters = <ChapterInfo>[
      ChapterInfo(index: 0, title: 'Chapter 1', startSec: 0, endSec: 1800),
      ChapterInfo(index: 1, title: 'Chapter 2', startSec: 1800, endSec: 3600),
    ];

    test('prefers Direct Play, falls back to HLS on decode failure, and '
        'registers self session ID', () async {
      engine.throwOnDirectLoad = true;
      await controller.playBook(
        AbsLibraryFixtures.bookOne,
        chapters: chapters,
        startPositionSec: 2000,
      );

      check(server.playRequests.length).equals(2);
      check(server.playRequests.first['forceDirectPlay']).equals(true);
      check(server.playRequests.last['forceDirectPlay']).equals(false);
      check(server.closeRequests.length).equals(1);
      check(controller.playMethod).equals(AbsPlayMethod.transcode);
      check(controller.isPlaying).isTrue;
      check(controller.activeSessionId).equals('session-2');
      check(controller.positionSec).equals(2000);
      check(controller.currentChapterIndex).equals(1);
    });

    test('applies smart rewind after pause, syncs progress, and manages '
        'bookmarks and history', () async {
      await controller.playBook(
        AbsLibraryFixtures.bookOne,
        chapters: chapters,
        startPositionSec: 1900,
      );

      check(controller.playMethod).equals(AbsPlayMethod.directPlay);
      await controller.pause();
      check(server.syncRequests.length).equals(1);

      // Wait 10 minutes before resuming -> 12s smart rewind -> 1888s.
      clock = clock.add(const Duration(minutes: 10));
      await controller.togglePlayPause();
      check(controller.lastSmartRewindSeconds).equals(12);
      check(controller.positionSec).equals(1888);

      // Chapter navigation.
      await controller.previousChapter();
      check(controller.positionSec).equals(1800);
      await controller.previousChapter();
      check(controller.positionSec).equals(0);
      await controller.nextChapter();
      check(controller.positionSec).equals(1800);

      // Bookmark creation with note + jump + delete.
      await controller.createBookmark(
        title: 'Airlock test',
        note: 'Great science moment',
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));
      check(controller.bookmarks.length).equals(1);
      check(controller.bookmarks.first.note).equals('Great science moment');
      check(server.createdBookmarks.length).equals(1);

      await controller.rewind();
      await controller.jumpToBookmark(controller.bookmarks.first);
      check(controller.positionSec).equals(1800);

      await controller.deleteBookmark(controller.bookmarks.first.timeSec);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      check(controller.bookmarks).isEmpty;
      check(server.deletedBookmarkPaths.length).equals(1);

      // History stream recorded jumps newest-first.
      check(controller.history.isNotEmpty).isTrue;
      await controller.stopAndClose();
      check(controller.hasActiveBook).isFalse;
      check(server.closeRequests.length).equals(1);
    });

    test('handles forward, speed clamping, skip silence, OS skip events, '
        'smart rewind toggle, sleep grace shake, and sign-out stop', () async {
      await controller.playBook(
        AbsLibraryFixtures.bookOne,
        chapters: chapters,
        startPositionSec: 100,
      );

      await controller.forward();
      check(controller.positionSec).equals(130);

      await controller.setSpeed(0.2);
      check(controller.speed).equals(0.5);
      await controller.setSpeed(4);
      check(controller.speed).equals(3);
      await controller.setSpeed(1.23);
      check(controller.speed).equals(1.25);

      await controller.setSkipSilence(true);
      check(controller.skipSilence).isTrue;

      controller.setSmartRewindEnabled(false);
      check(controller.smartRewindEnabled).isFalse;

      await controller.pause();
      clock = clock.add(const Duration(hours: 2));
      await controller.togglePlayPause();
      check(controller.positionSec).equals(130);

      engine.triggerSkipNext();
      await Future<void>.delayed(Duration.zero);
      check(controller.positionSec).equals(1800);

      engine.triggerSkipPrevious();
      await Future<void>.delayed(Duration.zero);
      check(controller.positionSec).equals(0);

      if (controller.history.isNotEmpty) {
        await controller.jumpToHistory(controller.history.first);
      }

      // Entering fade/grace starts shake detector and shake extends timer.
      await controller.sleepTimer.startDuration(const Duration(seconds: 8));
      check(shakeDetector.isListening).isTrue;
      shakeDetector.triggerShake();
      await Future<void>.delayed(Duration.zero);
      check(controller.sleepTimer.remaining)
          .equals(const Duration(minutes: 15));
      await controller.sleepTimer.cancel();
      check(shakeDetector.isListening).isFalse;

      // Sign-out stops active playback automatically.
      await authController.signOut();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      check(controller.hasActiveBook).isFalse;

      // Attempting playBook while signed out records an error message.
      await controller.playBook(AbsLibraryFixtures.bookOne);
      check(controller.errorMessage).isNotNull();
    });

    test('plays downloaded local files offline without /play and queues '
        'progress and bookmark mutations', () async {
      final tempDir = await Directory.systemTemp.createTemp(
        'shelf_plus_local_play_',
      );
      addTearDown(() async {
        if (tempDir.existsSync()) {
          await tempDir.delete(recursive: true);
        }
      });

      final localFile = File('${tempDir.path}/track_000.m4b');
      await localFile.writeAsBytes(const <int>[1, 2, 3, 4]);
      await db.upsertDownloadTask(
        DownloadTasksCompanion.insert(
          serverId: 'srv-1',
          libraryItemId: 'item-1',
          status: 'completed',
          bytesDownloaded: const Value<int>(4),
          totalBytes: const Value<int>(4),
          trackCount: const Value<int>(1),
          completedTracks: const Value<int>(1),
          createdAtMs: 100,
          updatedAtMs: 100,
        ),
      );
      await db.replaceDownloadedTracks(
        'srv-1',
        'item-1',
        <DownloadedTracksCompanion>[
          DownloadedTracksCompanion.insert(
            serverId: 'srv-1',
            libraryItemId: 'item-1',
            trackIndex: 0,
            ino: 'ino-1',
            title: 'Part 1',
            contentUrl: '/api/items/item-1/file/ino-1',
            localPath: localFile.path,
            durationSec: const Value<double>(3600),
            expectedBytes: const Value<int>(4),
            downloadedBytes: const Value<int>(4),
            isComplete: const Value<bool>(true),
          ),
        ],
      );

      final connectivity = FakeConnectivityService(
        initialStatus: NetworkConnectionType.offline,
      );
      final logger = AppLogger(forwardToDeveloperLog: false);
      final apiClient = AbsApiClient.create(
        loadBaseUrl: credentialsStore.loadActiveBaseUrl,
        loadTokens: credentialsStore.loadActiveTokens,
        saveTokens: credentialsStore.saveActiveTokens,
        loadCustomHeaders: credentialsStore.loadActiveCustomHeaders,
        onSessionExpired: () async {},
        logger: logger,
      );
      final dlController = DownloadController(
        apiClient: apiClient,
        database: db,
        authController: authController,
        connectivityService: connectivity,
        transport: FakeDownloadTransport(),
        logger: logger,
        getDownloadsRoot: () async => tempDir,
      );
      final syncController = OfflineSyncController(
        apiClient: apiClient,
        database: db,
        authController: authController,
        connectivityService: connectivity,
        logger: logger,
      );
      final offlinePlayer = PlayerController(
        apiClient: apiClient,
        database: db,
        authController: authController,
        credentialsStore: credentialsStore,
        engine: FakeAudioPlayerEngine(),
        socketService: socketService,
        coverThemeExtractor: FakeCoverThemeExtractor(),
        logger: logger,
        downloadController: dlController,
        offlineSyncController: syncController,
        shakeDetector: FakeShakeDetector(),
      );

      final playCountBefore = server.playRequests.length;
      await offlinePlayer.playBook(
        AbsLibraryFixtures.bookOne,
        chapters: chapters,
        startPositionSec: 250,
      );

      check(server.playRequests.length).equals(playCountBefore);
      check(offlinePlayer.playMethod).equals(AbsPlayMethod.local);
      check(offlinePlayer.isPlaying).isTrue;
      check(offlinePlayer.positionSec).equals(250);

      await offlinePlayer.pause();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      check(syncController.pendingCount).equals(1);

      offlinePlayer.dispose();
      dlController.dispose();
      syncController.dispose();
      await connectivity.dispose();
    });
  });
}
