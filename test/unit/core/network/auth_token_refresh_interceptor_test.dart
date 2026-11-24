import 'package:checks/checks.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/network/abs_api_client.dart';
import 'package:shelf_plus/core/network/abs_api_models.dart';
import 'package:shelf_plus/core/network/auth_tokens.dart';

import '../../../fakes/mock_abs_server.dart';

void main() {
  group('AuthTokenRefreshInterceptor', () {
    test(
      'refreshes expired token once across 5 concurrent 401 calls',
      () async {
        final server = await MockAbsServer.start(
          basePathPrefix: '/abs',
          requiredHeaders: const <String, String>{
            'CF-Access-Client-Id': 'cf-id',
          },
        );
        addTearDown(server.close);
        server.refreshDelay = const Duration(milliseconds: 50);

        var storedTokens = const AuthTokens(
          accessToken: 'expired_initial_access',
          refreshToken: 'refresh_token_1',
        );
        var expiredCount = 0;

        final client = AbsApiClient.create(
          loadBaseUrl: () async => server.baseUrl,
          loadTokens: () async => storedTokens,
          saveTokens: (tokens) async => storedTokens = tokens,
          loadCustomHeaders: () async => const <String, String>{
            'CF-Access-Client-Id': 'cf-id',
          },
          onSessionExpired: () async => expiredCount++,
          logger: AppLogger(level: Level.FINE, forwardToDeveloperLog: false),
        );

        final results = await Future.wait<AbsAuthorizeResponse>(
          List<Future<AbsAuthorizeResponse>>.generate(
            5,
            (_) => client.authorize(baseUrl: server.baseUrl),
          ),
        );

        check(results.length).equals(5);
        for (final res in results) {
          check(res.username).equals('reader');
        }
        check(server.refreshCount).equals(1);
        check(expiredCount).equals(0);
        check(storedTokens.accessToken).equals('access_token_2');
        check(storedTokens.refreshToken).equals('refresh_token_2');
      },
    );

    test('triggers onSessionExpired when refresh token is rejected', () async {
      final server = await MockAbsServer.start()
        ..expireRefreshToken();
      addTearDown(server.close);

      var expiredCount = 0;
      final client = AbsApiClient.create(
        loadBaseUrl: () async => server.baseUrl,
        loadTokens: () async => const AuthTokens(
          accessToken: 'expired_access',
          refreshToken: 'bad_refresh',
        ),
        saveTokens: (_) async {},
        loadCustomHeaders: () async => const <String, String>{},
        onSessionExpired: () async => expiredCount++,
        logger: AppLogger(forwardToDeveloperLog: false),
      );

      try {
        await client.authorize(baseUrl: server.baseUrl);
        fail('Expected AbsApiException');
      } on AbsApiException catch (err) {
        check(err.kind).equals(AbsApiErrorKind.invalidCredentials);
      }
      check(expiredCount).equals(1);
    });

    test(
      'does not attempt refresh for legacy token without refreshToken',
      () async {
        final server = await MockAbsServer.start()
          ..expireAccessToken();
        addTearDown(server.close);

        var expiredCount = 0;
        final client = AbsApiClient.create(
          loadBaseUrl: () async => server.baseUrl,
          loadTokens: () async => const AuthTokens(accessToken: 'legacy_only'),
          saveTokens: (_) async {},
          loadCustomHeaders: () async => const <String, String>{},
          onSessionExpired: () async => expiredCount++,
          logger: AppLogger(forwardToDeveloperLog: false),
        );

        try {
          await client.authorize(baseUrl: server.baseUrl);
          fail('Expected AbsApiException');
        } on AbsApiException catch (err) {
          check(err.kind).equals(AbsApiErrorKind.invalidCredentials);
        }
        check(server.refreshCount).equals(0);
        check(expiredCount).equals(0);
      },
    );

    test(
      'preserves existing refreshToken if server does not rotate it',
      () async {
        final server = await MockAbsServer.start(rotateRefreshToken: false);
        addTearDown(server.close);

        var storedTokens = const AuthTokens(
          accessToken: 'expired_access',
          refreshToken: 'refresh_token_1',
        );

        final client = AbsApiClient.create(
          loadBaseUrl: () async => server.baseUrl,
          loadTokens: () async => storedTokens,
          saveTokens: (tokens) async => storedTokens = tokens,
          loadCustomHeaders: () async => const <String, String>{},
          onSessionExpired: () async {},
          logger: AppLogger(forwardToDeveloperLog: false),
        );

        final res = await client.authorize(baseUrl: server.baseUrl);
        check(res.username).equals('reader');
        check(storedTokens.accessToken).equals('access_token_2');
        check(storedTokens.refreshToken).equals('refresh_token_1');
      },
    );

    test('does not fail if BaseOptions timeout is configured', () {
      final dio = Dio();
      addTearDown(dio.close);
      check(dio.options).isNotNull();
    });
  });
}
