import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_plus/features/library/domain/library_models.dart';
import 'package:shelf_plus/features/player/domain/book_timeline_mapper.dart';

void main() {
  group('BookTimelineMapper', () {
    final mapper = BookTimelineMapper(const <TrackSegment>[
      TrackSegment(index: 0, startOffsetSec: 0, durationSec: 1200),
      TrackSegment(index: 1, startOffsetSec: 1200, durationSec: 1800),
      TrackSegment(index: 2, startOffsetSec: 3000, durationSec: 600),
    ]);

    test('computes total duration and maps book offset across tracks', () {
      check(mapper.totalDurationSec).equals(3600);

      check(mapper.toTrackPosition(0)).equals(
        const TrackPosition(trackIndex: 0, trackPosition: Duration.zero),
      );
      check(mapper.toTrackPosition(600)).equals(
        const TrackPosition(
          trackIndex: 0,
          trackPosition: Duration(seconds: 600),
        ),
      );
      check(mapper.toTrackPosition(1200)).equals(
        const TrackPosition(trackIndex: 1, trackPosition: Duration.zero),
      );
      check(mapper.toTrackPosition(3300)).equals(
        const TrackPosition(
          trackIndex: 2,
          trackPosition: Duration(seconds: 300),
        ),
      );
      check(mapper.toTrackPosition(9999)).equals(
        const TrackPosition(
          trackIndex: 2,
          trackPosition: Duration(seconds: 600),
        ),
      );
    });

    test('maps track index and position back to unified book seconds', () {
      check(
        mapper.toBookPosition(
          trackIndex: 1,
          trackPosition: const Duration(seconds: 450),
        ),
      ).equals(1650);
      check(
        mapper.toBookPosition(
          trackIndex: 2,
          trackPosition: const Duration(seconds: 700),
        ),
      ).equals(3600);
    });

    test('resolves active chapter cleanly across boundaries', () {
      const chapters = <ChapterInfo>[
        ChapterInfo(index: 0, title: 'Ch 1', startSec: 0, endSec: 500),
        ChapterInfo(index: 1, title: 'Ch 2', startSec: 500, endSec: 1500),
        ChapterInfo(index: 2, title: 'Ch 3', startSec: 1500, endSec: 3600),
      ];

      check(BookTimelineMapper.activeChapterIndex(chapters, 0)).equals(0);
      check(BookTimelineMapper.activeChapterIndex(chapters, 499.9)).equals(0);
      check(BookTimelineMapper.activeChapterIndex(chapters, 500)).equals(1);
      check(BookTimelineMapper.activeChapter(chapters, 2000)?.title)
          .equals('Ch 3');
      check(BookTimelineMapper.activeChapter(const <ChapterInfo>[], 10)).isNull;
    });
  });
}
