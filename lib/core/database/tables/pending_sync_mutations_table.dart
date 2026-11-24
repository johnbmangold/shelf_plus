import 'package:drift/drift.dart';

/// Queued offline sync mutation awaiting server delivery when connected.
class PendingSyncMutations extends Table {
  /// Auto-incrementing queue row ID.
  IntColumn get id => integer().autoIncrement()();

  /// Owning server profile ID.
  TextColumn get serverId => text()();

  /// Owning library item ID.
  TextColumn get libraryItemId => text()();

  /// Mutation kind (`progress`, `bookmarkCreate`, `bookmarkDelete`).
  TextColumn get mutationType => text()();

  /// JSON-serialized mutation payload.
  TextColumn get payloadJson => text()();

  /// UTC epoch milliseconds when queued or last coalesced.
  IntColumn get createdAtMs => integer()();

  /// Number of failed flush attempts so far.
  IntColumn get retryCount => integer().withDefault(const Constant(0))();

  /// Latest sync failure description, if any.
  TextColumn get lastError => text().nullable()();
}
