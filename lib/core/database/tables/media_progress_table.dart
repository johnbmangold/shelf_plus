import 'package:drift/drift.dart';

/// Cached user listening progress per audiobook, supporting offline sync state.
class MediaProgressEntries extends Table {
  /// Owning server profile ID.
  TextColumn get serverId => text()();

  /// Owning library item ID.
  TextColumn get libraryItemId => text()();

  /// Media duration in seconds.
  RealColumn get durationSec => real().withDefault(const Constant(0))();

  /// Active local listening position in seconds.
  RealColumn get localPositionSec => real().withDefault(const Constant(0))();

  /// Last known server listening position in seconds.
  RealColumn get serverPositionSec => real().withDefault(const Constant(0))();

  /// Baseline position in seconds at the last clean sync.
  RealColumn get lastSyncedPositionSec =>
      real().withDefault(const Constant(0))();

  /// Normalized completion ratio in `[0.0, 1.0]`.
  RealColumn get progress => real().withDefault(const Constant(0))();

  /// Whether the book is marked finished.
  BoolColumn get isFinished => boolean().withDefault(const Constant(false))();

  /// Whether the item is hidden from Continue Listening.
  BoolColumn get hideFromContinueListening =>
      boolean().withDefault(const Constant(false))();

  /// UTC epoch milliseconds of the latest local listening change.
  IntColumn get localUpdatedAtMs => integer().withDefault(const Constant(0))();

  /// UTC epoch milliseconds reported by the server.
  IntColumn get serverUpdatedAtMs => integer().withDefault(const Constant(0))();

  /// Sync status (`synced`, `pendingPush`, or `conflict`).
  TextColumn get syncState => text().withDefault(const Constant('synced'))();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{
    serverId,
    libraryItemId,
  };
}
