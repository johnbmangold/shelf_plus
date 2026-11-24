import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

import '../fixtures/abs_library_fixtures.dart';

/// Embedded Audiobookshelf mock HTTP server for unit, widget, and E2E tests.
class MockAbsServer {
  new _({
    required this._server,
    required this.basePathPrefix,
    required this.requiredHeaders,
    required this.supportsRefreshTokens,
    required this.rotateRefreshToken,
    required this.serverVersion,
    required this.validUsername,
    required this.validPassword,
  });

  /// Starts an embedded [MockAbsServer] on `127.0.0.1` with an ephemeral port.
  static Future<MockAbsServer> start({
    String basePathPrefix = '',
    Map<String, String> requiredHeaders = const <String, String>{},
    bool supportsRefreshTokens = true,
    bool rotateRefreshToken = true,
    String serverVersion = '2.26.0',
    String validUsername = 'reader',
    String validPassword = 'secret-password',
  }) async {
    var normalizedPrefix = basePathPrefix.trim();
    if (normalizedPrefix.isNotEmpty && !normalizedPrefix.startsWith('/')) {
      normalizedPrefix = '/$normalizedPrefix';
    }
    while (normalizedPrefix.endsWith('/')) {
      normalizedPrefix = normalizedPrefix.substring(
        0,
        normalizedPrefix.length - 1,
      );
    }

    late MockAbsServer mock;
    final server = await shelf_io.serve(
      (request) => mock._handleRequest(request),
      InternetAddress.loopbackIPv4,
      0,
    );

    return mock = MockAbsServer._(
      server: server,
      basePathPrefix: normalizedPrefix,
      requiredHeaders: requiredHeaders,
      supportsRefreshTokens: supportsRefreshTokens,
      rotateRefreshToken: rotateRefreshToken,
      serverVersion: serverVersion,
      validUsername: validUsername,
      validPassword: validPassword,
    );
  }

  final HttpServer _server;

  /// Optional reverse-proxy subpath prefix (for example `/audiobookshelf`).
  final String basePathPrefix;

  /// Headers required on every request (simulating Cloudflare Access / proxy).
  final Map<String, String> requiredHeaders;

  /// Whether `/login` returns v2.26+ `accessToken` + `refreshToken`.
  final bool supportsRefreshTokens;

  /// Whether `/auth/refresh` rotates the refresh token on each call.
  final bool rotateRefreshToken;

  /// Reported server version string.
  final String serverVersion;

  /// Accepted username for `/login`.
  final String validUsername;

  /// Accepted password for `/login`.
  final String validPassword;

  /// Base URL including scheme, loopback host, ephemeral port, and subpath.
  String get baseUrl => 'http://127.0.0.1:${_server.port}$basePathPrefix';

  /// Currently active valid access token.
  String currentAccessToken = 'access_token_1';

  /// Currently active valid refresh token.
  String currentRefreshToken = 'refresh_token_1';

  /// Artificial delay before responding to `/auth/refresh` (for concurrency
  /// tests).
  Duration refreshDelay = Duration.zero;

  /// If `true`, `/ping` returns non-ABS JSON (`{'ok': true}`).
  bool invalidPingPayload = false;

  /// Number of `GET /ping` requests observed.
  int pingCount = 0;

  /// Number of `POST /login` requests observed.
  int loginCount = 0;

  /// Number of `POST /auth/refresh` requests observed.
  int refreshCount = 0;

  /// Number of `POST /api/authorize` requests observed.
  int authorizeCount = 0;

  /// Number of `POST /logout` requests observed.
  int logoutCount = 0;

  int _tokenGeneration = 1;

  /// Invalidates the current access token so subsequent authorized calls return
  /// HTTP 401 until refreshed.
  void expireAccessToken() {
    currentAccessToken = 'expired_${DateTime.now().microsecondsSinceEpoch}';
  }

  /// Invalidates the current refresh token so refresh attempts return 401.
  void expireRefreshToken() {
    currentRefreshToken = 'expired_refresh';
  }

  /// Stops the embedded HTTP server.
  Future<void> close() => _server.close(force: true);

  Future<Response> _handleRequest(Request request) async {
    for (final entry in requiredHeaders.entries) {
      final actual = _headerIgnoreCase(request.headers, entry.key);
      if (actual != entry.value) {
        return _jsonResponse(403, <String, Object?>{
          'error': 'Missing or invalid proxy header',
        });
      }
    }

    final rawPath = '/${request.url.path}';
    if (basePathPrefix.isNotEmpty && !rawPath.startsWith(basePathPrefix)) {
      return _jsonResponse(404, <String, Object?>{'error': 'Wrong subpath'});
    }

    final endpoint = basePathPrefix.isNotEmpty
        ? rawPath.substring(basePathPrefix.length)
        : rawPath;
    final normalizedEndpoint = endpoint.isEmpty ? '/' : endpoint;

    if (request.method == 'GET' && normalizedEndpoint == '/ping') {
      pingCount++;
      if (invalidPingPayload) {
        return _jsonResponse(200, <String, Object?>{'ok': true});
      }
      return _jsonResponse(200, <String, Object?>{'success': true});
    }

    if (request.method == 'GET' && normalizedEndpoint == '/status') {
      return _jsonResponse(200, <String, Object?>{
        'isInit': true,
        'serverVersion': serverVersion,
        'authMethods': <String>['local'],
      });
    }

    if (request.method == 'POST' && normalizedEndpoint == '/login') {
      loginCount++;
      final bodyText = await request.readAsString();
      final decoded = jsonDecode(bodyText) as Map<String, dynamic>;
      if (decoded['username'] != validUsername ||
          decoded['password'] != validPassword) {
        return _jsonResponse(401, <String, Object?>{'error': 'Unauthorized'});
      }

      final returnTokens =
          _headerIgnoreCase(request.headers, 'x-return-tokens') == 'true';

      final userMap = <String, Object?>{
        'id': 'abs-user-1',
        'username': validUsername,
        'type': 'admin',
        'token': currentAccessToken,
      };
      if (supportsRefreshTokens && returnTokens) {
        userMap['accessToken'] = currentAccessToken;
        userMap['refreshToken'] = currentRefreshToken;
      }

      return _jsonResponse(200, <String, Object?>{
        'user': userMap,
        'userDefaultLibraryId': 'lib-main',
        'serverSettings': <String, Object?>{'version': serverVersion},
      });
    }

    if (request.method == 'POST' && normalizedEndpoint == '/auth/refresh') {
      refreshCount++;
      if (refreshDelay > Duration.zero) {
        await Future<void>.delayed(refreshDelay);
      }
      final providedRefresh = _headerIgnoreCase(
        request.headers,
        'x-refresh-token',
      );
      if (providedRefresh == null ||
          providedRefresh != currentRefreshToken ||
          currentRefreshToken == 'expired_refresh') {
        return _jsonResponse(401, <String, Object?>{
          'error': 'Invalid refresh',
        });
      }

      _tokenGeneration++;
      currentAccessToken = 'access_token_$_tokenGeneration';
      if (rotateRefreshToken) {
        currentRefreshToken = 'refresh_token_$_tokenGeneration';
      }

      return _jsonResponse(200, <String, Object?>{
        'user': <String, Object?>{
          'id': 'abs-user-1',
          'username': validUsername,
          'accessToken': currentAccessToken,
          if (rotateRefreshToken) 'refreshToken': currentRefreshToken,
        },
      });
    }

    if (request.method == 'POST' && normalizedEndpoint == '/api/authorize') {
      authorizeCount++;
      final authHeader = _headerIgnoreCase(request.headers, 'authorization');
      if (authHeader != 'Bearer $currentAccessToken') {
        return _jsonResponse(401, <String, Object?>{'error': 'Expired token'});
      }
      return _jsonResponse(200, <String, Object?>{
        'user': <String, Object?>{
          'id': 'abs-user-1',
          'username': validUsername,
          'type': 'admin',
        },
        'userDefaultLibraryId': 'lib-main',
        'serverSettings': <String, Object?>{'version': serverVersion},
      });
    }

    if (request.method == 'POST' && normalizedEndpoint == '/logout') {
      logoutCount++;
      return _jsonResponse(200, <String, Object?>{'success': true});
    }

    if (request.method == 'GET' && normalizedEndpoint == '/api/libraries') {
      final authHeader = _headerIgnoreCase(request.headers, 'authorization');
      if (authHeader != 'Bearer $currentAccessToken') {
        return _jsonResponse(401, <String, Object?>{'error': 'Expired token'});
      }
      return _jsonResponse(200, AbsLibraryFixtures.librariesResponseJson());
    }

    if (request.method == 'GET' &&
        normalizedEndpoint == '/api/libraries/lib-main/items') {
      final authHeader = _headerIgnoreCase(request.headers, 'authorization');
      if (authHeader != 'Bearer $currentAccessToken') {
        return _jsonResponse(401, <String, Object?>{'error': 'Expired token'});
      }
      return _jsonResponse(200, AbsLibraryFixtures.libraryItemsPageJson());
    }

    if (request.method == 'GET' &&
        normalizedEndpoint == '/api/libraries/lib-scifi/items') {
      final authHeader = _headerIgnoreCase(request.headers, 'authorization');
      if (authHeader != 'Bearer $currentAccessToken') {
        return _jsonResponse(401, <String, Object?>{'error': 'Expired token'});
      }
      return _jsonResponse(200, <String, Object?>{
        'results': <Object>[],
        'total': 0,
        'limit': 100,
        'page': 0,
      });
    }

    if (request.method == 'GET' &&
        normalizedEndpoint == '/api/libraries/lib-main/collections') {
      final authHeader = _headerIgnoreCase(request.headers, 'authorization');
      if (authHeader != 'Bearer $currentAccessToken') {
        return _jsonResponse(401, <String, Object?>{'error': 'Expired token'});
      }
      return _jsonResponse(200, AbsLibraryFixtures.collectionsResponseJson());
    }

    if (request.method == 'GET' &&
        normalizedEndpoint == '/api/libraries/lib-scifi/collections') {
      final authHeader = _headerIgnoreCase(request.headers, 'authorization');
      if (authHeader != 'Bearer $currentAccessToken') {
        return _jsonResponse(401, <String, Object?>{'error': 'Expired token'});
      }
      return _jsonResponse(200, <String, Object?>{'results': <Object>[]});
    }

    if (request.method == 'GET' && normalizedEndpoint == '/api/items/item-1') {
      final authHeader = _headerIgnoreCase(request.headers, 'authorization');
      if (authHeader != 'Bearer $currentAccessToken') {
        return _jsonResponse(401, <String, Object?>{'error': 'Expired token'});
      }
      return _jsonResponse(200, AbsLibraryFixtures.expandedItem1Json());
    }

    if (request.method == 'GET' && normalizedEndpoint == '/api/me') {
      final authHeader = _headerIgnoreCase(request.headers, 'authorization');
      if (authHeader != 'Bearer $currentAccessToken') {
        return _jsonResponse(401, <String, Object?>{'error': 'Expired token'});
      }
      return _jsonResponse(200, AbsLibraryFixtures.meResponseJson());
    }

    return _jsonResponse(404, <String, Object?>{'error': 'Not found'});
  }

  String? _headerIgnoreCase(Map<String, String> headers, String name) {
    final target = name.toLowerCase();
    for (final entry in headers.entries) {
      if (entry.key.toLowerCase() == target) {
        return entry.value;
      }
    }
    return null;
  }

  Response _jsonResponse(int statusCode, Map<String, Object?> payload) {
    return Response(
      statusCode,
      body: jsonEncode(payload),
      headers: const <String, String>{'content-type': 'application/json'},
    );
  }
}
