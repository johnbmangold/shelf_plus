import 'package:drift/drift.dart';

/// Persisted Audiobookshelf server connection and active user metadata.
///
/// Sensitive credentials (access/refresh tokens and custom proxy headers) are
/// stored separately in `SecureStorageService` keyed by [id].
class ServerProfiles extends Table {
  /// Stable UUID identifying this server profile.
  TextColumn get id => text()();

  /// Normalized server base URL (including optional subpath prefix).
  TextColumn get baseUrl => text().unique()();

  /// User-facing display name (host or server title).
  TextColumn get displayName => text()();

  /// Reported Audiobookshelf server version string, if known.
  TextColumn get serverVersion => text().nullable()();

  /// Authenticated Audiobookshelf user ID.
  TextColumn get userId => text()();

  /// Authenticated Audiobookshelf username.
  TextColumn get username => text()();

  /// User role/type reported by Audiobookshelf (`admin`, `user`, etc.).
  TextColumn get userType => text().nullable()();

  /// Default library ID reported by the user profile, if any.
  TextColumn get defaultLibraryId => text().nullable()();

  /// Whether the server returned a refresh token (ABS v2.26+).
  BoolColumn get supportsRefreshTokens =>
      boolean().withDefault(const Constant(false))();

  /// Whether this profile is the currently active server.
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();

  /// UTC timestamp of the most recent successful connection.
  DateTimeColumn get lastConnectedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}
