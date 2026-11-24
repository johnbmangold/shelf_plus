import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/network/auth_tokens.dart';

/// Categorized errors thrown by the Audiobookshelf API client.
enum AbsApiErrorKind {
  /// Malformed or unsupported server URL.
  invalidUrl,

  /// Host could not be reached or DNS/socket connection failed.
  unreachable,

  /// Request timed out waiting for the server.
  timeout,

  /// HTTPS TLS certificate verification failed.
  tlsCertificate,

  /// Reverse proxy or gateway rejected the request with 401/403 before ABS.
  proxyAuthRequired,

  /// Username or password rejected by `/login`.
  invalidCredentials,

  /// Server responded, but not with an expected Audiobookshelf payload.
  invalidServerResponse,

  /// Refresh token expired or revoked; user must re-authenticate.
  sessionExpired,

  /// Unclassified network or server failure.
  unknown,
}

/// Typed exception surfaced by Audiobookshelf network calls.
class AbsApiException implements Exception {
  /// Creates an [AbsApiException].
  const new({required this.kind, this.statusCode, this.message});

  /// High-level category describing the failure.
  final AbsApiErrorKind kind;

  /// Optional HTTP status code associated with the failure.
  final int? statusCode;

  /// Optional diagnostic detail message.
  final String? message;

  @override
  String toString() =>
      'AbsApiException(kind: $kind, statusCode: $statusCode, '
      'message: $message)';
}

/// Result returned by probing a candidate Audiobookshelf server.
@immutable
class ServerProbeResult {
  /// Creates a [ServerProbeResult].
  const new({
    required this.normalizedBaseUrl,
    required this.isInitialized,
    this.serverVersion,
    this.authMethods = const <String>[],
  });

  /// Canonical normalized server URL (including subpath prefix, if any).
  final String normalizedBaseUrl;

  /// Whether the server reports `isInit: true`.
  final bool isInitialized;

  /// Server version reported by `/status` (for example, `2.26.0`).
  final String? serverVersion;

  /// Supported auth methods reported by `/status` (e.g. `local`, `openid`).
  final List<String> authMethods;
}

/// Parsed response returned by `POST /login`.
@immutable
class AbsLoginResponse {
  /// Creates an [AbsLoginResponse].
  const new({
    required this.userId,
    required this.username,
    required this.tokens,
    required this.supportsRefreshTokens,
    this.userType,
    this.defaultLibraryId,
    this.serverVersion,
  });

  /// Audiobookshelf user ID.
  final String userId;

  /// Authenticated username.
  final String username;

  /// Access token and optional refresh token.
  final AuthTokens tokens;

  /// Whether the server issued a refresh token (ABS v2.26+).
  final bool supportsRefreshTokens;

  /// User role/type reported by Audiobookshelf.
  final String? userType;

  /// Default library ID reported in `userDefaultLibraryId`.
  final String? defaultLibraryId;

  /// Server version reported inside `serverSettings.version`, if present.
  final String? serverVersion;
}

/// Parsed response returned by `POST /api/authorize`.
@immutable
class AbsAuthorizeResponse {
  /// Creates an [AbsAuthorizeResponse].
  const new({
    required this.userId,
    required this.username,
    this.userType,
    this.defaultLibraryId,
    this.serverVersion,
  });

  /// Audiobookshelf user ID.
  final String userId;

  /// Authenticated username.
  final String username;

  /// User role/type reported by Audiobookshelf.
  final String? userType;

  /// Default library ID reported in `userDefaultLibraryId`.
  final String? defaultLibraryId;

  /// Server version reported inside `serverSettings.version`, if present.
  final String? serverVersion;
}
