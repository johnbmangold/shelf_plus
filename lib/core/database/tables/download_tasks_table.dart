import 'package:drift/drift.dart';

/// Offline download queue task per server item.
class DownloadTasks extends Table {
  /// Owning server profile ID.
  TextColumn get serverId => text()();

  /// Owning library item ID.
  TextColumn get libraryItemId => text()();

  /// Status (`queued`, `downloading`, `paused`, `completed`, `failed`).
  TextColumn get status => text()();

  /// Cumulative bytes written to disk across all tracks.
  IntColumn get bytesDownloaded => integer().withDefault(const Constant(0))();

  /// Expected total byte count across all tracks (0 if unknown).
  IntColumn get totalBytes => integer().withDefault(const Constant(0))();

  /// Total track count for the book.
  IntColumn get trackCount => integer().withDefault(const Constant(0))();

  /// Number of completed tracks for the book.
  IntColumn get completedTracks => integer().withDefault(const Constant(0))();

  /// Optional human-readable error message when paused or failed.
  TextColumn get errorMessage => text().nullable()();

  /// UTC epoch milliseconds when queued.
  IntColumn get createdAtMs => integer()();

  /// UTC epoch milliseconds of the last status or progress update.
  IntColumn get updatedAtMs => integer()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{
    serverId,
    libraryItemId,
  };
}
