import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/network/abs_api_client.dart';
import 'package:shelf_plus/core/network/abs_api_models.dart';
import 'package:shelf_plus/core/network/auth_tokens.dart';

import '../../../fakes/mock_abs_server.dart';

void main() {
  group('AbsApiClient', () {
    test('probes subpath server with required custom headers', () async {
      final server = await MockAbsServer.start(
        basePathPrefix: '/audiobookshelf',
        requiredHeaders: const <String, String>{
          'CF-Access-Client-Id': 'client-123',
          'CF-Access-Client-Secret': 'cf-super-secret',
        },
      );
      addTearDown(server.close);

      final logger = AppLogger(level: Level.FINE, forwardToDeveloperLog: false);
      final client = AbsApiClient.create(
        loadBaseUrl: () async => server.baseUrl,
        loadTokens: () async => null,
        saveTokens: (_) async {},
        loadCustomHeaders: () async => const <String, String>{},
        onSessionExpired: () async {},
        logger: logger,
      );

      final probe = await client.probeServer(
        baseUrl: '${server.baseUrl}/',
        customHeaders: const <String, String>{
          'CF-Access-Client-Id': 'client-123',
          'CF-Access-Client-Secret': 'cf-super-secret',
        },
      );

      check(probe.normalizedBaseUrl).equals(server.baseUrl);
      check(probe.isInitialized).isTrue;
      check(probe.serverVersion).equals('2.26.0');
      check(probe.authMethods).deepEquals(<String>['local']);
      check(logger.exportAsText().contains('cf-super-secret')).isFalse;
    });

    test('maps proxy 403 on probe to proxyAuthRequired', () async {
      final server = await MockAbsServer.start(
        requiredHeaders: const <String, String>{'X-Proxy-Auth': 'yes'},
      );
      addTearDown(server.close);

      final client = AbsApiClient.create(
        loadBaseUrl: () async => null,
        loadTokens: () async => null,
        saveTokens: (_) async {},
        loadCustomHeaders: () async => const <String, String>{},
        onSessionExpired: () async {},
        logger: AppLogger(forwardToDeveloperLog: false),
      );

      try {
        await client.probeServer(baseUrl: server.baseUrl);
        fail('Expected AbsApiException');
      } on AbsApiException catch (err) {
        check(err.kind).equals(AbsApiErrorKind.proxyAuthRequired);
      }
    });

    test('maps non-ABS ping payload to invalidServerResponse', () async {
      final server = await MockAbsServer.start()
        ..invalidPingPayload = true;
      addTearDown(server.close);

      final client = AbsApiClient.create(
        loadBaseUrl: () async => null,
        loadTokens: () async => null,
        saveTokens: (_) async {},
        loadCustomHeaders: () async => const <String, String>{},
        onSessionExpired: () async {},
        logger: AppLogger(forwardToDeveloperLog: false),
      );

      try {
        await client.probeServer(baseUrl: server.baseUrl);
        fail('Expected AbsApiException');
      } on AbsApiException catch (err) {
        check(err.kind).equals(AbsApiErrorKind.invalidServerResponse);
      }
    });

    test(
      'logs in with v2.26+ refresh tokens and legacy token fallback',
      () async {
        final modernServer = await MockAbsServer.start();
        addTearDown(modernServer.close);

        final logger = AppLogger(
          level: Level.FINE,
          forwardToDeveloperLog: false,
        );
        final client = AbsApiClient.create(
          loadBaseUrl: () async => null,
          loadTokens: () async => null,
          saveTokens: (_) async {},
          loadCustomHeaders: () async => const <String, String>{},
          onSessionExpired: () async {},
          logger: logger,
        );

        final modern = await client.login(
          baseUrl: modernServer.baseUrl,
          username: 'reader',
          password: 'secret-password',
        );
        check(modern.supportsRefreshTokens).isTrue;
        check(modern.tokens).equals(
          const AuthTokens(
            accessToken: 'access_token_1',
            refreshToken: 'refresh_token_1',
          ),
        );
        check(modern.serverVersion).equals('2.26.0');
        check(logger.exportAsText().contains('secret-password')).isFalse;
        check(logger.exportAsText().contains('access_token_1')).isFalse;

        final legacyServer = await MockAbsServer.start(
          supportsRefreshTokens: false,
          serverVersion: '2.20.0',
        );
        addTearDown(legacyServer.close);

        final legacy = await client.login(
          baseUrl: legacyServer.baseUrl,
          username: 'reader',
          password: 'secret-password',
        );
        check(legacy.supportsRefreshTokens).isFalse;
        check(legacy.tokens.refreshToken).isNull;
        check(legacy.tokens.accessToken).equals('access_token_1');
      },
    );

    test('maps wrong credentials to invalidCredentials', () async {
      final server = await MockAbsServer.start();
      addTearDown(server.close);

      final client = AbsApiClient.create(
        loadBaseUrl: () async => null,
        loadTokens: () async => null,
        saveTokens: (_) async {},
        loadCustomHeaders: () async => const <String, String>{},
        onSessionExpired: () async {},
        logger: AppLogger(forwardToDeveloperLog: false),
      );

      try {
        await client.login(
          baseUrl: server.baseUrl,
          username: 'reader',
          password: 'wrong',
        );
        fail('Expected AbsApiException');
      } on AbsApiException catch (err) {
        check(err.kind).equals(AbsApiErrorKind.invalidCredentials);
      }
    });
  });
}
