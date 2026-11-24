import 'package:drift/drift.dart';

/// Timestamped playback jump history entries for quick resume/jump-back.
class PlaybackHistoryEntries extends Table {
  /// Auto-incrementing row ID.
  IntColumn get id => integer().autoIncrement()();

  /// Owning server profile ID.
  TextColumn get serverId => text()();

  /// Owning library item ID.
  TextColumn get libraryItemId => text()();

  /// Playback position in seconds when the entry was recorded.
  RealColumn get positionSec => real()();

  /// Event reason (`play`, `seek`, `chapter`, `pause`, `rewind`, `bookmark`).
  TextColumn get reason => text()();

  /// UTC epoch milliseconds when the event occurred.
  IntColumn get createdAtMs => integer()();
}
