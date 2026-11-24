import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/network/abs_api_models.dart';
import 'package:shelf_plus/core/network/abs_url_builder.dart';
import 'package:shelf_plus/core/network/auth_token_refresh_interceptor.dart';
import 'package:shelf_plus/core/network/auth_tokens.dart';
import 'package:shelf_plus/core/network/custom_headers_interceptor.dart';
import 'package:shelf_plus/core/network/redacted_logging_interceptor.dart';

/// HTTP client for Audiobookshelf REST endpoints.
class AbsApiClient {
  /// Creates an [AbsApiClient] wired with custom headers, redacted logging, and
  /// automatic serialized token refresh.
  factory create({
    required Future<String?> Function() loadBaseUrl,
    required Future<AuthTokens?> Function() loadTokens,
    required Future<void> Function(AuthTokens tokens) saveTokens,
    required Future<Map<String, String>> Function() loadCustomHeaders,
    required Future<void> Function() onSessionExpired,
    required AppLogger logger,
    Duration connectTimeout = const Duration(seconds: 15),
    Duration receiveTimeout = const Duration(seconds: 20),
    HttpClientAdapter? adapter,
  }) {
    final baseOptions = BaseOptions(
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      headers: const <String, Object?>{'Accept': 'application/json'},
    );

    final unauthenticatedDio = Dio(baseOptions);
    final authenticatedDio = Dio(baseOptions);
    if (adapter != null) {
      unauthenticatedDio.httpClientAdapter = adapter;
      authenticatedDio.httpClientAdapter = adapter;
    }

    final loggingInterceptor = RedactedLoggingInterceptor(logger: logger);
    unauthenticatedDio.interceptors.add(loggingInterceptor);

    authenticatedDio.interceptors.addAll(<Interceptor>[
      CustomHeadersInterceptor(loadHeaders: loadCustomHeaders),
      AuthTokenRefreshInterceptor(
        loadBaseUrl: loadBaseUrl,
        loadTokens: loadTokens,
        saveTokens: saveTokens,
        loadCustomHeaders: loadCustomHeaders,
        onSessionExpired: onSessionExpired,
        refreshDio: unauthenticatedDio,
        logger: logger,
      ),
      loggingInterceptor,
    ]);

    return AbsApiClient._(
      unauthenticatedDio: unauthenticatedDio,
      authenticatedDio: authenticatedDio,
    );
  }

  new _({required this._unauthenticatedDio, required this._authenticatedDio});

  final Dio _unauthenticatedDio;
  final Dio _authenticatedDio;

  /// Validates [baseUrl], verifies `/ping`, and inspects `/status`.
  Future<ServerProbeResult> probeServer({
    required String baseUrl,
    Map<String, String> customHeaders = const <String, String>{},
  }) async {
    final normalized = _normalizeOrThrow(baseUrl);

    try {
      final pingUrl = AbsUrlBuilder.resolve(normalized, '/ping');
      final pingResponse = await _unauthenticatedDio.get<Map<String, dynamic>>(
        pingUrl,
        options: Options(headers: customHeaders),
      );
      final pingData = pingResponse.data;
      if (pingData == null || pingData['success'] != true) {
        throw const AbsApiException(
          kind: AbsApiErrorKind.invalidServerResponse,
          message: 'Ping did not confirm Audiobookshelf.',
        );
      }

      final statusUrl = AbsUrlBuilder.resolve(normalized, '/status');
      final statusResponse = await _unauthenticatedDio
          .get<Map<String, dynamic>>(
            statusUrl,
            options: Options(headers: customHeaders),
          );
      final statusData = statusResponse.data;
      if (statusData == null) {
        throw const AbsApiException(
          kind: AbsApiErrorKind.invalidServerResponse,
          message: 'Status response was empty.',
        );
      }

      final isInit = statusData['isInit'] == true;
      final serverVersion = statusData['serverVersion'] as String?;
      final rawMethods = statusData['authMethods'];
      final authMethods = rawMethods is List
          ? rawMethods.whereType<String>().toList(growable: false)
          : const <String>[];

      return ServerProbeResult(
        normalizedBaseUrl: normalized,
        isInitialized: isInit,
        serverVersion: serverVersion,
        authMethods: authMethods,
      );
    } on AbsApiException {
      rethrow;
    } on DioException catch (err) {
      throw _mapDioException(err, isProbe: true);
    }
  }

  /// Authenticates with `POST /login` using `x-return-tokens: true`.
  ///
  /// Supports both modern ABS v2.26+ responses (`accessToken` + `refreshToken`)
  /// and legacy token-only (`user.token`) responses.
  Future<AbsLoginResponse> login({
    required String baseUrl,
    required String username,
    required String password,
    Map<String, String> customHeaders = const <String, String>{},
  }) async {
    final normalized = _normalizeOrThrow(baseUrl);
    final loginUrl = AbsUrlBuilder.resolve(normalized, '/login');

    try {
      final response = await _unauthenticatedDio.post<Map<String, dynamic>>(
        loginUrl,
        data: <String, Object?>{'username': username, 'password': password},
        options: Options(
          headers: <String, Object?>{
            ...customHeaders,
            'x-return-tokens': 'true',
          },
        ),
      );

      final data = response.data;
      final user = data?['user'];
      if (data == null || user is! Map<String, dynamic>) {
        throw const AbsApiException(
          kind: AbsApiErrorKind.invalidServerResponse,
          message: 'Login response did not include a user object.',
        );
      }

      final userId = user['id'];
      final resolvedUsername = user['username'];
      final accessToken =
          _nonEmptyString(user['accessToken']) ??
          _nonEmptyString(data['accessToken']) ??
          _nonEmptyString(user['token']) ??
          _nonEmptyString(data['token']);

      if (userId is! String ||
          resolvedUsername is! String ||
          accessToken == null) {
        throw const AbsApiException(
          kind: AbsApiErrorKind.invalidServerResponse,
          message: 'Login response missed required user or token fields.',
        );
      }

      final refreshToken =
          _nonEmptyString(user['refreshToken']) ??
          _nonEmptyString(data['refreshToken']);

      final serverSettings = data['serverSettings'];
      final serverVersion = serverSettings is Map<String, dynamic>
          ? _nonEmptyString(serverSettings['version'])
          : null;

      return AbsLoginResponse(
        userId: userId,
        username: resolvedUsername,
        tokens: AuthTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        ),
        supportsRefreshTokens: refreshToken != null,
        userType: _nonEmptyString(user['type']),
        defaultLibraryId: _nonEmptyString(data['userDefaultLibraryId']),
        serverVersion: serverVersion,
      );
    } on AbsApiException {
      rethrow;
    } on DioException catch (err) {
      throw _mapDioException(err);
    }
  }

  /// Validates the active session via `POST /api/authorize`.
  Future<AbsAuthorizeResponse> authorize({required String baseUrl}) async {
    final normalized = _normalizeOrThrow(baseUrl);
    final url = AbsUrlBuilder.resolve(normalized, '/api/authorize');

    try {
      final response = await _authenticatedDio.post<Map<String, dynamic>>(url);
      final data = response.data;
      final user = data?['user'];
      if (data == null || user is! Map<String, dynamic>) {
        throw const AbsApiException(
          kind: AbsApiErrorKind.invalidServerResponse,
          message: 'Authorize response did not include a user object.',
        );
      }

      final userId = user['id'];
      final username = user['username'];
      if (userId is! String || username is! String) {
        throw const AbsApiException(
          kind: AbsApiErrorKind.invalidServerResponse,
          message: 'Authorize response missed required user fields.',
        );
      }

      final serverSettings = data['serverSettings'];
      final serverVersion = serverSettings is Map<String, dynamic>
          ? _nonEmptyString(serverSettings['version'])
          : null;

      return AbsAuthorizeResponse(
        userId: userId,
        username: username,
        userType: _nonEmptyString(user['type']),
        defaultLibraryId: _nonEmptyString(data['userDefaultLibraryId']),
        serverVersion: serverVersion,
      );
    } on AbsApiException {
      rethrow;
    } on DioException catch (err) {
      throw _mapDioException(err);
    }
  }

  /// Sends a best-effort `POST /logout` request.
  Future<void> logout({
    required String baseUrl,
    String? refreshToken,
    Map<String, String> customHeaders = const <String, String>{},
  }) async {
    final normalized = _normalizeOrThrow(baseUrl);
    final url = AbsUrlBuilder.resolve(normalized, '/logout');
    try {
      await _unauthenticatedDio.post<dynamic>(
        url,
        options: Options(
          headers: <String, Object?>{
            ...customHeaders,
            if (refreshToken != null && refreshToken.isNotEmpty)
              'x-refresh-token': refreshToken,
          },
        ),
      );
    } on DioException {
      // Best-effort logout; local credential cleanup proceeds regardless.
    }
  }

  String _normalizeOrThrow(String rawUrl) {
    try {
      return AbsUrlBuilder.normalizeBaseUrl(rawUrl);
    } on FormatException catch (err) {
      throw AbsApiException(
        kind: AbsApiErrorKind.invalidUrl,
        message: err.message,
      );
    }
  }

  AbsApiException _mapDioException(DioException err, {bool isProbe = false}) {
    final statusCode = err.response?.statusCode;
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return AbsApiException(
          kind: AbsApiErrorKind.timeout,
          statusCode: statusCode,
          message: err.message,
        );
      case DioExceptionType.badCertificate:
        return AbsApiException(
          kind: AbsApiErrorKind.tlsCertificate,
          statusCode: statusCode,
          message: err.message,
        );
      case DioExceptionType.connectionError:
        return AbsApiException(
          kind: AbsApiErrorKind.unreachable,
          statusCode: statusCode,
          message: err.message,
        );
      case DioExceptionType.badResponse:
        if (isProbe && (statusCode == 401 || statusCode == 403)) {
          return AbsApiException(
            kind: AbsApiErrorKind.proxyAuthRequired,
            statusCode: statusCode,
            message: err.message,
          );
        }
        if (!isProbe && statusCode == 401) {
          return AbsApiException(
            kind: AbsApiErrorKind.invalidCredentials,
            statusCode: statusCode,
            message: err.message,
          );
        }
        if (!isProbe && statusCode == 403) {
          return AbsApiException(
            kind: AbsApiErrorKind.proxyAuthRequired,
            statusCode: statusCode,
            message: err.message,
          );
        }
        return AbsApiException(
          kind: AbsApiErrorKind.invalidServerResponse,
          statusCode: statusCode,
          message: err.message,
        );
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        if (err.error is HandshakeException ||
            err.error is TlsException ||
            err.error is CertificateException) {
          return AbsApiException(
            kind: AbsApiErrorKind.tlsCertificate,
            statusCode: statusCode,
            message: err.message,
          );
        }
        if (err.error is SocketException) {
          return AbsApiException(
            kind: AbsApiErrorKind.unreachable,
            statusCode: statusCode,
            message: err.message,
          );
        }
        return AbsApiException(
          kind: AbsApiErrorKind.unknown,
          statusCode: statusCode,
          message: err.message,
        );
    }
  }

  static String? _nonEmptyString(Object? value) {
    if (value is String && value.isNotEmpty) return value;
    return null;
  }
}
