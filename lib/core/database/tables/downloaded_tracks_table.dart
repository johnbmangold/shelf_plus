import 'package:drift/drift.dart';

/// Persisted metadata and byte progress for an individual offline audio track.
class DownloadedTracks extends Table {
  /// Owning server profile ID.
  TextColumn get serverId => text()();

  /// Owning library item ID.
  TextColumn get libraryItemId => text()();

  /// Zero-based track index within the audiobook.
  IntColumn get trackIndex => integer()();

  /// Server audio file `ino` identifier.
  TextColumn get ino => text()();

  /// Track display title.
  TextColumn get title => text()();

  /// Relative server content endpoint used to fetch this track.
  TextColumn get contentUrl => text()();

  /// Absolute finalized local file path on device storage.
  TextColumn get localPath => text()();

  /// Cumulative start offset within the audiobook timeline in seconds.
  RealColumn get startOffsetSec => real().withDefault(const Constant(0))();

  /// Track audio duration in seconds.
  RealColumn get durationSec => real().withDefault(const Constant(0))();

  /// Expected size of this audio file in bytes (0 if unknown).
  IntColumn get expectedBytes => integer().withDefault(const Constant(0))();

  /// Bytes persisted on disk for this track so far.
  IntColumn get downloadedBytes => integer().withDefault(const Constant(0))();

  /// Whether this track has completed transfer and been finalized on disk.
  BoolColumn get isComplete => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{
    serverId,
    libraryItemId,
    trackIndex,
  };
}
