import 'package:drift/drift.dart';

/// Cached user bookmarks for an audiobook.
class Bookmarks extends Table {
  /// Owning server profile ID.
  TextColumn get serverId => text()();

  /// Owning library item ID.
  TextColumn get libraryItemId => text()();

  /// Bookmark timestamp in seconds.
  RealColumn get timeSec => real()();

  /// Bookmark title.
  TextColumn get title => text()();

  /// Optional extended note added by the user.
  TextColumn get note => text().nullable()();

  /// Epoch milliseconds when the bookmark was created.
  IntColumn get createdAtMs => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{
    serverId,
    libraryItemId,
    timeSec,
  };
}
