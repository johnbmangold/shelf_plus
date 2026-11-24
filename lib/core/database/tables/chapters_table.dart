import 'package:drift/drift.dart';

/// Cached chapter entries for a library item record.
class Chapters extends Table {
  /// Owning server profile ID.
  TextColumn get serverId => text()();

  /// Owning library item ID.
  TextColumn get libraryItemId => text()();

  /// Zero-based chapter order index.
  IntColumn get chapterIndex => integer()();

  /// Chapter title.
  TextColumn get title => text()();

  /// Chapter start timestamp in seconds.
  RealColumn get startSec => real()();

  /// Chapter end timestamp in seconds.
  RealColumn get endSec => real()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{
    serverId,
    libraryItemId,
    chapterIndex,
  };
}
