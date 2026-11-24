import 'package:drift/drift.dart';

/// Cached Audiobookshelf library items scoped by `serverId`.
class LibraryItems extends Table {
  /// Owning server profile ID.
  TextColumn get serverId => text()();

  /// Audiobookshelf library item ID.
  TextColumn get id => text()();

  /// Owning library ID.
  TextColumn get libraryId => text()();

  /// Media type discriminator (`book` in v1).
  TextColumn get mediaType => text().withDefault(const Constant('book'))();

  /// Book title.
  TextColumn get title => text()();

  /// Optional subtitle.
  TextColumn get subtitle => text().nullable()();

  /// Display-formatted comma-separated author names.
  TextColumn get authors => text().withDefault(const Constant(''))();

  /// JSON-encoded author names array for structured grouping.
  TextColumn get authorsJson => text().withDefault(const Constant('[]'))();

  /// Display-formatted comma-separated narrator names.
  TextColumn get narrators => text().withDefault(const Constant(''))();

  /// JSON-encoded narrator names array.
  TextColumn get narratorsJson => text().withDefault(const Constant('[]'))();

  /// Primary series name, if any.
  TextColumn get seriesName => text().nullable()();

  /// Sequence string within the primary series (for example, `"1"` or `"2.5"`).
  TextColumn get seriesSequence => text().nullable()();

  /// JSON-encoded list of `{id, name, sequence}` series entries.
  TextColumn get seriesJson => text().withDefault(const Constant('[]'))();

  /// JSON-encoded genres array.
  TextColumn get genresJson => text().withDefault(const Constant('[]'))();

  /// JSON-encoded tags array.
  TextColumn get tagsJson => text().withDefault(const Constant('[]'))();

  /// Synopsis/description text.
  TextColumn get description => text().nullable()();

  /// Publisher name, if available.
  TextColumn get publisher => text().nullable()();

  /// Published year string, if available.
  TextColumn get publishedYear => text().nullable()();

  /// Total audio duration in seconds.
  RealColumn get durationSec => real().withDefault(const Constant(0))();

  /// Number of chapters reported on the item.
  IntColumn get numChapters => integer().withDefault(const Constant(0))();

  /// Whether the item has a cover image on the server.
  BoolColumn get hasCover => boolean().withDefault(const Constant(false))();

  /// Epoch milliseconds when the item was added to Audiobookshelf.
  IntColumn get addedAtMs => integer().withDefault(const Constant(0))();

  /// Epoch milliseconds when the item metadata was last updated.
  IntColumn get updatedAtMs => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{serverId, id};
}
