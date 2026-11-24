import 'package:checks/checks.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:shelf_plus/core/database/app_database.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/network/abs_api_client.dart';
import 'package:shelf_plus/core/network/abs_library_models.dart';
import 'package:shelf_plus/core/network/auth_tokens.dart';
import 'package:shelf_plus/core/network/connectivity_service.dart';
import 'package:shelf_plus/features/auth/data/auth_repository_impl.dart';
import 'package:shelf_plus/features/auth/domain/server_session.dart';
import 'package:shelf_plus/features/auth/presentation/auth_controller.dart';
import 'package:shelf_plus/features/sync/domain/progress_conflict_resolver.dart';
import 'package:shelf_plus/features/sync/presentation/offline_sync_controller.dart';

import '../../../fakes/fake_connectivity_service.dart';
import '../../../fakes/in_memory_secure_storage_service.dart';
import '../../../fakes/mock_abs_server.dart';

void main() {
  group('OfflineSyncController', () {
    late MockAbsServer server;
    late AppDatabase db;
    late FakeConnectivityService connectivity;
    late AuthController authController;
    late OfflineSyncController syncController;
    late DateTime clock;

    setUp(() async {
      server = await MockAbsServer.start();
      clock = DateTime.utc(2026, 6, 1, 12);
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
      await db.upsertLibraryItems('srv-1', <LibraryItemsCompanion>[
        LibraryItemsCompanion.insert(
          serverId: 'srv-1',
          id: 'item-1',
          libraryId: 'lib-main',
          title: 'Project Hail Mary',
        ),
      ]);

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
      connectivity = FakeConnectivityService(
        initialStatus: NetworkConnectionType.offline,
      );
      syncController = OfflineSyncController(
        apiClient: apiClient,
        database: db,
        authController: authController,
        connectivityService: connectivity,
        logger: logger,
        now: () => clock,
      );
    });

    tearDown(() async {
      syncController.dispose();
      await connectivity.dispose();
      authController.dispose();
      await db.close();
      await server.close();
    });

    test(
      'coalesces progress mutations while offline and flushes on reconnect',
      () async {
        await syncController.enqueueProgressSync(
          itemId: 'item-1',
          currentTimeSec: 300,
          durationSec: 3600,
          isFinished: false,
        );
        await syncController.enqueueProgressSync(
          itemId: 'item-1',
          currentTimeSec: 450,
          durationSec: 3600,
          isFinished: false,
        );
        await syncController.enqueueBookmarkCreate(
          itemId: 'item-1',
          timeSec: 450,
          title: 'Offline note',
        );
        await syncController.enqueueBookmarkDelete(
          itemId: 'item-1',
          timeSec: 120,
        );

        await Future<void>.delayed(const Duration(milliseconds: 50));
        // 1 coalesced progress + 1 bookmarkCreate + 1 bookmarkDelete = 3.
        check(syncController.pendingCount).equals(3);

        // Transitions offline -> wifi triggers automatic flush.
        connectivity.setStatus(NetworkConnectionType.wifi);
        await Future<void>.delayed(const Duration(milliseconds: 120));

        check(syncController.pendingCount).equals(0);
        check(server.patchedProgress.length).equals(1);
        check(server.patchedProgress.first['currentTime']).equals(450);
        check(server.createdBookmarks.length).equals(1);
        check(server.deletedBookmarkPaths.length).equals(1);
      },
    );

    test(
      'resolves conflicts cleanly for keepDevice and useServer choices',
      () async {
        connectivity.setStatus(NetworkConnectionType.wifi);
        await db.upsertMediaProgressEntries(<MediaProgressEntriesCompanion>[
          ProgressConflictResolver.mergeToCompanion(
            serverId: 'srv-1',
            remote: const AbsMediaProgressDto(
              libraryItemId: 'item-1',
              durationSec: 3600,
              currentTimeSec: 1400,
              progress: 1400 / 3600,
              isFinished: false,
              hideFromContinueListening: false,
              lastUpdateMs: 9000,
            ),
            local: const MediaProgressEntry(
              serverId: 'srv-1',
              libraryItemId: 'item-1',
              durationSec: 3600,
              localPositionSec: 850,
              serverPositionSec: 100,
              lastSyncedPositionSec: 100,
              progress: 850 / 3600,
              isFinished: false,
              hideFromContinueListening: false,
              localUpdatedAtMs: 8000,
              serverUpdatedAtMs: 7000,
              syncState: 'pendingPush',
            ),
          ),
        ]);
        await Future<void>.delayed(const Duration(milliseconds: 50));
        check(syncController.hasConflicts).isTrue;

        await syncController.resolveConflict(
          itemId: 'item-1',
          choice: ConflictResolutionChoice.keepDevice,
        );
        await Future<void>.delayed(const Duration(milliseconds: 50));
        check(syncController.hasConflicts).isFalse;
        check(server.patchedProgress.last['currentTime']).equals(850);

        // Re-create a conflict and choose useServer.
        await db.upsertMediaProgressEntries(<MediaProgressEntriesCompanion>[
          MediaProgressEntriesCompanion.insert(
            serverId: 'srv-1',
            libraryItemId: 'item-1',
            durationSec: const Value<double>(3600),
            localPositionSec: const Value<double>(900),
            serverPositionSec: const Value<double>(1600),
            lastSyncedPositionSec: const Value<double>(850),
            syncState: const Value<String>('conflict'),
          ),
        ]);
        await syncController.resolveConflict(
          itemId: 'item-1',
          choice: ConflictResolutionChoice.useServer,
        );
        final updated = await db.getMediaProgress('srv-1', 'item-1');
        check(updated?.localPositionSec).equals(1600);
        check(updated?.syncState).equals('synced');
      },
    );
  });
}
