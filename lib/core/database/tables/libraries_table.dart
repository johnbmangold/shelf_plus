import 'package:drift/drift.dart';

/// Cached Audiobookshelf libraries scoped by `serverId`.
class Libraries extends Table {
  /// Owning server profile ID.
  TextColumn get serverId => text()();

  /// Audiobookshelf library ID.
  TextColumn get id => text()();

  /// User-facing library name.
  TextColumn get name => text()();

  /// Media type discriminator (`book` in v1; `podcast` / `ebook` later).
  TextColumn get mediaType => text()();

  /// Library icon key reported by Audiobookshelf.
  TextColumn get icon => text().withDefault(const Constant('book'))();

  /// Display sort index.
  IntColumn get displayOrder => integer().withDefault(const Constant(0))();

  /// UTC epoch milliseconds when this library was last synced.
  IntColumn get lastSyncedAtMs => integer()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{serverId, id};
}
