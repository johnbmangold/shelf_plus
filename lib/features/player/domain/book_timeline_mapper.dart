import 'package:flutter/foundation.dart';
import 'package:shelf_plus/features/library/domain/library_models.dart';

/// Contiguous track segment within a multi-file audiobook timeline.
@immutable
class TrackSegment {
  /// Creates a [TrackSegment].
  const new({
    required this.index,
    required this.startOffsetSec,
    required this.durationSec,
  });

  /// Zero-based index in the track playlist.
  final int index;

  /// Cumulative start offset of this track in seconds.
  final double startOffsetSec;

  /// Track duration in seconds.
  final double durationSec;

  /// Cumulative end offset of this track in seconds.
  double get endOffsetSec => startOffsetSec + durationSec;
}

/// Position inside a specific playlist track.
@immutable
class TrackPosition {
  /// Creates a [TrackPosition].
  const new({required this.trackIndex, required this.trackPosition});

  /// Zero-based playlist index.
  final int trackIndex;

  /// Offset within the track.
  final Duration trackPosition;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackPosition &&
          runtimeType == other.runtimeType &&
          trackIndex == other.trackIndex &&
          trackPosition == other.trackPosition;

  @override
  int get hashCode => Object.hash(trackIndex, trackPosition);
}

/// Maps between unified book-level timestamps and multi-track positions.
class BookTimelineMapper {
  /// Creates a [BookTimelineMapper] from ordered [segments].
  new(List<TrackSegment> segments)
    : _segments = List<TrackSegment>.unmodifiable(
        List<TrackSegment>.from(segments)
          ..sort((a, b) => a.startOffsetSec.compareTo(b.startOffsetSec)),
      );

  final List<TrackSegment> _segments;

  /// Unmodifiable ordered track segments.
  List<TrackSegment> get segments => _segments;

  /// Total duration across all tracks in seconds.
  double get totalDurationSec {
    if (_segments.isEmpty) return 0;
    return _segments.last.endOffsetSec;
  }

  /// Maps a book-level offset in seconds to a track index and track offset.
  TrackPosition toTrackPosition(double bookPositionSec) {
    if (_segments.isEmpty) {
      return const TrackPosition(trackIndex: 0, trackPosition: Duration.zero);
    }
    final clamped = bookPositionSec.clamp(0.0, totalDurationSec);
    for (var i = 0; i < _segments.length; i++) {
      final segment = _segments[i];
      final isLast = i == _segments.length - 1;
      if (clamped < segment.endOffsetSec || isLast) {
        final offsetSec = (clamped - segment.startOffsetSec).clamp(
          0.0,
          segment.durationSec > 0 ? segment.durationSec : clamped,
        );
        return TrackPosition(
          trackIndex: segment.index,
          trackPosition: Duration(milliseconds: (offsetSec * 1000).round()),
        );
      }
    }
    final last = _segments.last;
    return TrackPosition(
      trackIndex: last.index,
      trackPosition: Duration(milliseconds: (last.durationSec * 1000).round()),
    );
  }

  /// Maps a [trackIndex] and [trackPosition] back to book-level seconds.
  double toBookPosition({
    required int trackIndex,
    required Duration trackPosition,
  }) {
    if (_segments.isEmpty) return 0;
    final match = _segments.where((s) => s.index == trackIndex);
    final segment = match.isNotEmpty
        ? match.first
        : _segments[trackIndex.clamp(0, _segments.length - 1)];
    final rawSec =
        segment.startOffsetSec + (trackPosition.inMilliseconds / 1000.0);
    if (totalDurationSec <= 0) {
      return rawSec < 0 ? 0.0 : rawSec;
    }
    return rawSec.clamp(0.0, totalDurationSec);
  }

  /// Returns the index of the active chapter at [bookPositionSec], or `-1`.
  static int activeChapterIndex(
    List<ChapterInfo> chapters,
    double bookPositionSec,
  ) {
    if (chapters.isEmpty) return -1;
    final pos = bookPositionSec < 0 ? 0.0 : bookPositionSec;
    for (var i = 0; i < chapters.length; i++) {
      final chapter = chapters[i];
      final isLast = i == chapters.length - 1;
      if ((pos >= chapter.startSec && pos < chapter.endSec) ||
          (isLast && pos >= chapter.startSec)) {
        return i;
      }
    }
    return 0;
  }

  /// Returns the active [ChapterInfo] at [bookPositionSec], or `null`.
  static ChapterInfo? activeChapter(
    List<ChapterInfo> chapters,
    double bookPositionSec,
  ) {
    final index = activeChapterIndex(chapters, bookPositionSec);
    if (index < 0 || index >= chapters.length) return null;
    return chapters[index];
  }
}
