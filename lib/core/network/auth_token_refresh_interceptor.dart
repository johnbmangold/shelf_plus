import 'dart:async';

import 'package:dio/dio.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/network/abs_url_builder.dart';
import 'package:shelf_plus/core/network/auth_tokens.dart';

/// Key in [RequestOptions.extra] to bypass bearer injection and 401 refresh.
const String skipAuthExtraKey = 'skipAuth';

const String _retriedAfterRefreshKey = 'retriedAfterRefresh';
const String _sentAccessTokenKey = 'sentAccessToken';

/// Serialized `QueuedInterceptor` that injects Bearer access tokens and
/// transparently refreshes expired tokens via `POST /auth/refresh` on 401.
class AuthTokenRefreshInterceptor extends QueuedInterceptor {
  /// Creates an [AuthTokenRefreshInterceptor].
  new({
    required this._loadBaseUrl,
    required this._loadTokens,
    required this._saveTokens,
    required this._loadCustomHeaders,
    required this._onSessionExpired,
    required this._refreshDio,
    required this._logger,
  });

  final Future<String?> Function() _loadBaseUrl;
  final Future<AuthTokens?> Function() _loadTokens;
  final Future<void> Function(AuthTokens tokens) _saveTokens;
  final Future<Map<String, String>> Function() _loadCustomHeaders;
  final Future<void> Function() _onSessionExpired;
  final Dio _refreshDio;
  final AppLogger _logger;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[skipAuthExtraKey] == true) {
      handler.next(options);
      return;
    }

    final tokens = await _loadTokens();
    if (tokens != null && tokens.accessToken.isNotEmpty) {
      options.headers.putIfAbsent(
        'Authorization',
        () => 'Bearer ${tokens.accessToken}',
      );
      options.extra[_sentAccessTokenKey] = tokens.accessToken;
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = err.requestOptions;
    final statusCode = err.response?.statusCode;

    if (statusCode != 401 ||
        requestOptions.extra[skipAuthExtraKey] == true ||
        requestOptions.extra[_retriedAfterRefreshKey] == true) {
      handler.next(err);
      return;
    }

    final storedTokens = await _loadTokens();
    final baseUrl = await _loadBaseUrl();
    if (storedTokens == null ||
        !storedTokens.hasRefreshToken ||
        baseUrl == null ||
        baseUrl.isEmpty) {
      handler.next(err);
      return;
    }

    final sentToken = requestOptions.extra[_sentAccessTokenKey] as String?;
    if (sentToken != null && storedTokens.accessToken != sentToken) {
      await _retryRequest(
        requestOptions: requestOptions,
        accessToken: storedTokens.accessToken,
        handler: handler,
      );
      return;
    }

    try {
      final customHeaders = await _loadCustomHeaders();
      final refreshUrl = AbsUrlBuilder.resolve(baseUrl, '/auth/refresh');
      _logger.fine('Refreshing expired access token', scope: 'auth');

      final response = await _refreshDio.post<Map<String, dynamic>>(
        refreshUrl,
        options: Options(
          headers: <String, Object?>{
            ...customHeaders,
            'x-refresh-token': storedTokens.refreshToken,
          },
          extra: const <String, Object?>{skipAuthExtraKey: true},
        ),
      );

      final refreshedTokens = parseRefreshResponse(
        response.data,
        fallbackRefreshToken: storedTokens.refreshToken,
      );
      if (refreshedTokens == null) {
        _logger.warning(
          'Token refresh response did not contain an access token',
          scope: 'auth',
        );
        await _onSessionExpired();
        handler.next(err);
        return;
      }

      await _saveTokens(refreshedTokens);
      await _retryRequest(
        requestOptions: requestOptions,
        accessToken: refreshedTokens.accessToken,
        handler: handler,
      );
    } on DioException catch (refreshErr) {
      final refreshStatus = refreshErr.response?.statusCode;
      _logger.warning(
        'Token refresh failed (status: $refreshStatus)',
        scope: 'auth',
        error: refreshErr.message,
      );
      if (refreshStatus == 401 || refreshStatus == 403) {
        await _onSessionExpired();
      }
      handler.next(err);
    }
  }

  Future<void> _retryRequest({
    required RequestOptions requestOptions,
    required String accessToken,
    required ErrorInterceptorHandler handler,
  }) async {
    final customHeaders = await _loadCustomHeaders();
    final headers = <String, Object?>{
      ...customHeaders,
      ...requestOptions.headers,
      'Authorization': 'Bearer $accessToken',
    };
    final extra = <String, Object?>{
      ...requestOptions.extra,
      _retriedAfterRefreshKey: true,
      _sentAccessTokenKey: accessToken,
    };

    try {
      final response = await _refreshDio.fetch<dynamic>(
        requestOptions.copyWith(headers: headers, extra: extra),
      );
      handler.resolve(response);
    } on DioException catch (retryErr) {
      handler.next(retryErr);
    }
  }

  /// Extracts [AuthTokens] from an Audiobookshelf `/auth/refresh` response.
  static AuthTokens? parseRefreshResponse(
    Map<String, dynamic>? body, {
    String? fallbackRefreshToken,
  }) {
    if (body == null) return null;
    final userMap = body['user'] is Map<String, dynamic>
        ? body['user'] as Map<String, dynamic>
        : null;

    final accessToken =
        _nonEmptyString(userMap?['accessToken']) ??
        _nonEmptyString(body['accessToken']) ??
        _nonEmptyString(userMap?['token']) ??
        _nonEmptyString(body['token']);

    if (accessToken == null) return null;

    final refreshToken =
        _nonEmptyString(userMap?['refreshToken']) ??
        _nonEmptyString(body['refreshToken']) ??
        fallbackRefreshToken;

    return AuthTokens(accessToken: accessToken, refreshToken: refreshToken);
  }

  static String? _nonEmptyString(Object? value) {
    if (value is String && value.isNotEmpty) return value;
    return null;
  }
}
