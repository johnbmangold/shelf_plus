import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:shelf_plus/core/database/app_database.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/network/abs_api_client.dart';
import 'package:shelf_plus/features/auth/data/auth_repository_impl.dart';

import '../../../fakes/in_memory_secure_storage_service.dart';
import '../../../fakes/mock_abs_server.dart';

void main() {
  group('AuthRepositoryImpl', () {
    late AppDatabase db;
    late InMemorySecureStorageService storage;
    late AppLogger logger;
    late MockAbsServer server;
    late AuthRepositoryImpl repository;

    setUp(() async {
      db = AppDatabase.inMemory();
      storage = InMemorySecureStorageService();
      logger = AppLogger(level: Level.FINE, forwardToDeveloperLog: false);
      server = await MockAbsServer.start(
        basePathPrefix: '/abs',
        requiredHeaders: const <String, String>{
          'CF-Access-Client-Secret': 'proxy-secret-value',
        },
      );
      final store = AuthCredentialsStore(database: db, secureStorage: storage);
      final apiClient = AbsApiClient.create(
        loadBaseUrl: store.loadActiveBaseUrl,
        loadTokens: store.loadActiveTokens,
        saveTokens: store.saveActiveTokens,
        loadCustomHeaders: store.loadActiveCustomHeaders,
        onSessionExpired: () async {},
        logger: logger,
      );
      repository = AuthRepositoryImpl(
        apiClient: apiClient,
        database: db,
        credentialsStore: store,
        logger: logger,
      );
    });

    tearDown(() async {
      await db.close();
      await server.close();
    });

    test('login persists profile and secrets, loadActiveSession restores, '
        'and logout clears secrets', () async {
      final session = await repository.login(
        serverUrl: '${server.baseUrl}/',
        username: 'reader',
        password: 'secret-password',
        customHeaders: const <String, String>{
          'CF-Access-Client-Secret': 'proxy-secret-value',
          '  ': 'ignored',
        },
      );

      check(session.baseUrl).equals(server.baseUrl);
      check(session.username).equals('reader');
      check(session.supportsRefreshTokens).isTrue;
      check(session.customHeaders).deepEquals(const <String, String>{
        'CF-Access-Client-Secret': 'proxy-secret-value',
      });

      final loaded = await repository.loadActiveSession();
      check(loaded).equals(session);

      // Ensure raw secrets never appear in logger output.
      final logs = logger.exportAsText();
      check(logs.contains('secret-password')).isFalse;
      check(logs.contains('proxy-secret-value')).isFalse;
      check(logs.contains('access_token_1')).isFalse;

      await repository.logout();
      check(server.logoutCount).equals(1);
      check(await repository.loadActiveSession()).isNull;
      check(storage.snapshot.isEmpty).isTrue;
    });
  });
}
