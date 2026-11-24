import 'package:drift/drift.dart';

/// Cached Audiobookshelf collections scoped by `serverId` and `libraryId`.
class Collections extends Table {
  /// Owning server profile ID.
  TextColumn get serverId => text()();

  /// Audiobookshelf collection ID.
  TextColumn get id => text()();

  /// Owning library ID.
  TextColumn get libraryId => text()();

  /// Collection name.
  TextColumn get name => text()();

  /// Optional collection description.
  TextColumn get description => text().nullable()();

  /// JSON-encoded ordered list of library item IDs in this collection.
  TextColumn get bookIdsJson => text().withDefault(const Constant('[]'))();

  /// Epoch milliseconds when the collection was updated.
  IntColumn get updatedAtMs => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{serverId, id};
}
