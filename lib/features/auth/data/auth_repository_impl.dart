import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:shelf_plus/core/database/app_database.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/network/abs_api_client.dart';
import 'package:shelf_plus/core/network/abs_api_models.dart';
import 'package:shelf_plus/core/network/abs_url_builder.dart';
import 'package:shelf_plus/core/network/auth_tokens.dart';
import 'package:shelf_plus/core/storage/secure_storage_service.dart';
import 'package:shelf_plus/features/auth/domain/auth_repository.dart';
import 'package:shelf_plus/features/auth/domain/server_session.dart';
import 'package:uuid/uuid.dart';

/// Persists server metadata in Drift and tokens/custom headers in
/// [SecureStorageService].
class AuthCredentialsStore {
  /// Creates an [AuthCredentialsStore].
  const new({required this._database, required this._secureStorage});

  final AppDatabase _database;
  final SecureStorageService _secureStorage;

  static String _accessTokenKey(String serverId) =>
      'server_${serverId}_access_token';
  static String _refreshTokenKey(String serverId) =>
      'server_${serverId}_refresh_token';
  static String _customHeadersKey(String serverId) =>
      'server_${serverId}_custom_headers';

  /// Returns the normalized base URL of the active server, if any.
  Future<String?> loadActiveBaseUrl() async {
    final active = await _database.getActiveServer();
    return active?.baseUrl;
  }

  /// Loads stored [AuthTokens] for the active server, or `null`.
  Future<AuthTokens?> loadActiveTokens() async {
    final active = await _database.getActiveServer();
    if (active == null) return null;
    return await loadTokensForServer(active.id);
  }

  /// Loads stored [AuthTokens] for [serverId], or `null`.
  Future<AuthTokens?> loadTokensForServer(String serverId) async {
    final accessToken = await _secureStorage.read(_accessTokenKey(serverId));
    if (accessToken == null || accessToken.isEmpty) return null;
    final refreshToken = await _secureStorage.read(_refreshTokenKey(serverId));
    return AuthTokens(accessToken: accessToken, refreshToken: refreshToken);
  }

  /// Saves refreshed [tokens] for the currently active server.
  Future<void> saveActiveTokens(AuthTokens tokens) async {
    final active = await _database.getActiveServer();
    if (active == null) return;
    await saveTokensForServer(active.id, tokens);
  }

  /// Saves [tokens] for [serverId].
  Future<void> saveTokensForServer(String serverId, AuthTokens tokens) async {
    await _secureStorage.write(_accessTokenKey(serverId), tokens.accessToken);
    if (tokens.refreshToken != null && tokens.refreshToken!.isNotEmpty) {
      await _secureStorage.write(
        _refreshTokenKey(serverId),
        tokens.refreshToken!,
      );
    } else {
      await _secureStorage.delete(_refreshTokenKey(serverId));
    }
  }

  /// Loads encrypted custom HTTP headers for the active server.
  Future<Map<String, String>> loadActiveCustomHeaders() async {
    final active = await _database.getActiveServer();
    if (active == null) return const <String, String>{};
    return await loadCustomHeadersForServer(active.id);
  }

  /// Loads encrypted custom HTTP headers for [serverId].
  Future<Map<String, String>> loadCustomHeadersForServer(
    String serverId,
  ) async {
    final raw = await _secureStorage.read(_customHeadersKey(serverId));
    if (raw == null || raw.isEmpty) return const <String, String>{};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return const <String, String>{};
      return decoded.map(
        (key, value) => MapEntry<String, String>(key, value.toString()),
      );
    } on FormatException {
      return const <String, String>{};
    }
  }

  /// Saves encrypted [headers] for [serverId].
  Future<void> saveCustomHeadersForServer(
    String serverId,
    Map<String, String> headers,
  ) async {
    if (headers.isEmpty) {
      await _secureStorage.delete(_customHeadersKey(serverId));
      return;
    }
    await _secureStorage.write(
      _customHeadersKey(serverId),
      jsonEncode(headers),
    );
  }

  /// Deletes tokens and custom headers for [serverId].
  Future<void> clearSecretsForServer(String serverId) async {
    await _secureStorage.delete(_accessTokenKey(serverId));
    await _secureStorage.delete(_refreshTokenKey(serverId));
    await _secureStorage.delete(_customHeadersKey(serverId));
  }
}

/// Production implementation of [AuthRepository].
class AuthRepositoryImpl implements AuthRepository {
  /// Creates an [AuthRepositoryImpl].
  const new({
    required this._apiClient,
    required this._database,
    required this._credentialsStore,
    required this._logger,
    this._uuid = const Uuid(),
  });

  final AbsApiClient _apiClient;
  final AppDatabase _database;
  final AuthCredentialsStore _credentialsStore;
  final AppLogger _logger;
  final Uuid _uuid;

  @override
  Future<ServerProbeResult> probeServer({
    required String serverUrl,
    Map<String, String> customHeaders = const <String, String>{},
  }) {
    _logger.info('Probing Audiobookshelf server', scope: 'auth');
    return _apiClient.probeServer(
      baseUrl: serverUrl,
      customHeaders: customHeaders,
    );
  }

  @override
  Future<ServerSession> login({
    required String serverUrl,
    required String username,
    required String password,
    Map<String, String> customHeaders = const <String, String>{},
  }) async {
    final normalizedUrl = AbsUrlBuilder.normalizeBaseUrl(serverUrl);
    final sanitizedHeaders = _sanitizeHeaders(customHeaders);

    _logger.info('Signing in to $normalizedUrl as $username', scope: 'auth');
    final response = await _apiClient.login(
      baseUrl: normalizedUrl,
      username: username,
      password: password,
      customHeaders: sanitizedHeaders,
    );

    final existing = await _database.findServerByUrl(normalizedUrl);
    final serverId = existing?.id ?? _uuid.v4();
    final displayName = AbsUrlBuilder.displayHost(normalizedUrl);

    await _credentialsStore.saveTokensForServer(serverId, response.tokens);
    await _credentialsStore.saveCustomHeadersForServer(
      serverId,
      sanitizedHeaders,
    );

    await _database.saveActiveServer(
      ServerProfilesCompanion.insert(
        id: serverId,
        baseUrl: normalizedUrl,
        displayName: displayName,
        serverVersion: Value(response.serverVersion),
        userId: response.userId,
        username: response.username,
        userType: Value(response.userType),
        defaultLibraryId: Value(response.defaultLibraryId),
        supportsRefreshTokens: Value(response.supportsRefreshTokens),
        isActive: const Value(true),
        lastConnectedAt: DateTime.now().toUtc(),
      ),
    );

    _logger.info(
      'Signed in to $displayName (refreshTokens: '
      '${response.supportsRefreshTokens})',
      scope: 'auth',
    );

    return ServerSession(
      serverId: serverId,
      baseUrl: normalizedUrl,
      displayName: displayName,
      userId: response.userId,
      username: response.username,
      supportsRefreshTokens: response.supportsRefreshTokens,
      serverVersion: response.serverVersion,
      userType: response.userType,
      defaultLibraryId: response.defaultLibraryId,
      customHeaders: sanitizedHeaders,
    );
  }

  @override
  Future<ServerSession?> loadActiveSession() async {
    final active = await _database.getActiveServer();
    if (active == null) return null;

    final tokens = await _credentialsStore.loadTokensForServer(active.id);
    if (tokens == null) {
      _logger.warning(
        'Active server found in database without stored tokens; clearing',
        scope: 'auth',
      );
      await _database.clearActiveServer();
      return null;
    }

    final headers = await _credentialsStore.loadCustomHeadersForServer(
      active.id,
    );

    return ServerSession(
      serverId: active.id,
      baseUrl: active.baseUrl,
      displayName: active.displayName,
      userId: active.userId,
      username: active.username,
      supportsRefreshTokens: active.supportsRefreshTokens,
      serverVersion: active.serverVersion,
      userType: active.userType,
      defaultLibraryId: active.defaultLibraryId,
      customHeaders: headers,
    );
  }

  @override
  Future<void> logout() async {
    final active = await _database.getActiveServer();
    if (active != null) {
      final tokens = await _credentialsStore.loadTokensForServer(active.id);
      final headers = await _credentialsStore.loadCustomHeadersForServer(
        active.id,
      );
      await _apiClient.logout(
        baseUrl: active.baseUrl,
        refreshToken: tokens?.refreshToken,
        customHeaders: headers,
      );
      await _credentialsStore.clearSecretsForServer(active.id);
      await _database.clearActiveServer();
      _logger.info('Signed out from ${active.displayName}', scope: 'auth');
    }
  }

  Map<String, String> _sanitizeHeaders(Map<String, String> raw) {
    final sanitized = <String, String>{};
    for (final entry in raw.entries) {
      final key = entry.key.trim();
      final value = entry.value.trim();
      if (key.isEmpty || value.isEmpty) continue;
      sanitized[key] = value;
    }
    return Map<String, String>.unmodifiable(sanitized);
  }
}
