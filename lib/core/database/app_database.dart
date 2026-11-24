import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:shelf_plus/core/database/tables/server_profiles_table.dart';

part 'app_database.g.dart';

/// Local SQLite database powered by Drift.
@DriftDatabase(tables: <Type>[ServerProfiles])
class AppDatabase extends _$AppDatabase {
  /// Opens the persistent on-device database, or wraps a custom [executor].
  new([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'shelf_plus'));

  /// Creates an isolated in-memory database for unit and widget tests.
  factory inMemory() => AppDatabase(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  /// Returns the currently active [ServerProfile], or `null` if signed out.
  Future<ServerProfile?> getActiveServer() {
    return (select(serverProfiles)
          ..where((tbl) => tbl.isActive.equals(true))
          ..limit(1))
        .getSingleOrNull();
  }

  /// Watches the currently active [ServerProfile].
  Stream<ServerProfile?> watchActiveServer() {
    return (select(serverProfiles)
          ..where((tbl) => tbl.isActive.equals(true))
          ..limit(1))
        .watchSingleOrNull();
  }

  /// Finds a stored server profile by its normalized [baseUrl].
  Future<ServerProfile?> findServerByUrl(String baseUrl) {
    return (select(serverProfiles)
          ..where((tbl) => tbl.baseUrl.equals(baseUrl))
          ..limit(1))
        .getSingleOrNull();
  }

  /// Persists [companion] and marks it as the sole active server profile.
  Future<void> saveActiveServer(ServerProfilesCompanion companion) {
    return transaction(() async {
      await update(serverProfiles)
          .write(const ServerProfilesCompanion(isActive: Value(false)));
      await into(
        serverProfiles,
      ).insertOnConflictUpdate(companion.copyWith(isActive: const Value(true)));
    });
  }

  /// Marks all server profiles inactive without deleting cached metadata.
  Future<void> clearActiveServer() {
    return update(serverProfiles)
        .write(const ServerProfilesCompanion(isActive: Value(false)));
  }

  /// Deletes the server profile identified by [id].
  Future<void> deleteServer(String id) {
    return (delete(serverProfiles)..where((tbl) => tbl.id.equals(id))).go();
  }
}
