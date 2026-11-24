import 'package:material_ui/material_ui.dart';

/// Authenticated connection state for an Audiobookshelf server.
@immutable
class ServerSession {
  /// Creates a [ServerSession].
  const new({
    required this.serverId,
    required this.baseUrl,
    required this.displayName,
    required this.userId,
    required this.username,
    required this.supportsRefreshTokens,
    this.serverVersion,
    this.userType,
    this.defaultLibraryId,
    this.customHeaders = const <String, String>{},
  });

  /// Stable UUID for this server profile.
  final String serverId;

  /// Normalized server base URL (including optional subpath prefix).
  final String baseUrl;

  /// User-facing server display name.
  final String displayName;

  /// Authenticated Audiobookshelf user ID.
  final String userId;

  /// Authenticated username.
  final String username;

  /// Whether the server supports v2.26+ refresh tokens.
  final bool supportsRefreshTokens;

  /// Reported server version string, if available.
  final String? serverVersion;

  /// Reported user role/type, if available.
  final String? userType;

  /// Default library ID, if reported.
  final String? defaultLibraryId;

  /// Optional custom HTTP headers required by reverse proxies.
  final Map<String, String> customHeaders;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ServerSession) return false;
    return other.serverId == serverId &&
        other.baseUrl == baseUrl &&
        other.displayName == displayName &&
        other.userId == userId &&
        other.username == username &&
        other.supportsRefreshTokens == supportsRefreshTokens &&
        other.serverVersion == serverVersion &&
        other.userType == userType &&
        other.defaultLibraryId == defaultLibraryId &&
        _mapsEqual(other.customHeaders, customHeaders);
  }

  @override
  int get hashCode => Object.hash(
    serverId,
    baseUrl,
    displayName,
    userId,
    username,
    supportsRefreshTokens,
    serverVersion,
    userType,
    defaultLibraryId,
    Object.hashAllUnordered(
      customHeaders.entries.map((e) => Object.hash(e.key, e.value)),
    ),
  );

  static bool _mapsEqual(Map<String, String> a, Map<String, String> b) {
    if (a.length != b.length) return false;
    for (final entry in a.entries) {
      if (b[entry.key] != entry.value) return false;
    }
    return true;
  }
}
