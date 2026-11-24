import 'dart:async';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_plus/features/player/domain/sleep_timer_controller.dart';

void main() {
  group('SleepTimerController', () {
    testWidgets(
      'fades volume over 10s, pauses into 60s grace, and resets on expiry',
      (tester) async {
        final volumes = <double>[];
        var pauseCount = 0;
        var resumeCount = 0;
        final shakeStates = <bool>[];

        final timer = SleepTimerController(
          setVolume: (v) async => volumes.add(v),
          pausePlayback: () async => pauseCount++,
          resumePlayback: () async => resumeCount++,
          onFadeOrGraceChanged: shakeStates.add,
        );
        addTearDown(timer.dispose);

        await timer.startDuration(const Duration(seconds: 20));
        check(timer.phase).equals(SleepTimerPhase.counting);
        check(timer.isFadeOrGraceActive).isFalse;

        // Advance 10s -> remaining is 10s -> enters fade + enables shake.
        await tester.pump(const Duration(seconds: 10));
        check(timer.phase).equals(SleepTimerPhase.fading);
        check(timer.isFadeOrGraceActive).isTrue;
        check(shakeStates.last).isTrue;

        // Advance 5s into fade -> volume near 0.5.
        await tester.pump(const Duration(seconds: 5));
        check(volumes.last).isLessThan(0.6);

        // Finish countdown -> pauses, enters 60s grace, restores volume=1.
        await tester.pump(const Duration(seconds: 5));
        check(timer.phase).equals(SleepTimerPhase.grace);
        check(pauseCount).equals(1);
        check(volumes.last).equals(1);

        // Expire 60s grace -> timer off, shake disabled.
        await tester.pump(const Duration(seconds: 60));
        check(timer.phase).equals(SleepTimerPhase.off);
        check(shakeStates.last).isFalse;
        check(resumeCount).equals(0);
      },
    );

    testWidgets('extend during grace resumes playback and resets timer', (
      tester,
    ) async {
      var pauseCount = 0;
      var resumeCount = 0;
      final timer = SleepTimerController(
        setVolume: (_) async {},
        pausePlayback: () async => pauseCount++,
        resumePlayback: () async => resumeCount++,
      );
      addTearDown(timer.dispose);

      unawaited(timer.startDuration(const Duration(seconds: 12)));
      await tester.pump();
      await tester.pump(const Duration(seconds: 12));
      check(timer.phase).equals(SleepTimerPhase.grace);
      check(pauseCount).equals(1);

      await timer.extend(const Duration(minutes: 15));
      check(resumeCount).equals(1);
      check(timer.phase).equals(SleepTimerPhase.counting);
      check(timer.remaining).equals(const Duration(minutes: 15));

      await timer.cancel();
    });

    testWidgets('end-of-chapter mode pauses cleanly when chapter ends', (
      tester,
    ) async {
      var pauseCount = 0;
      final timer = SleepTimerController(
        setVolume: (_) async {},
        pausePlayback: () async => pauseCount++,
      );
      addTearDown(timer.dispose);

      await timer.startEndOfChapter(
        currentPositionSec: 90,
        activeChapterEndSec: 105,
      );
      check(timer.endOfChapterMode).isTrue;
      check(timer.phase).equals(SleepTimerPhase.counting);

      await tester.pump(const Duration(seconds: 5));
      check(timer.phase).equals(SleepTimerPhase.fading);

      await tester.pump(const Duration(seconds: 10));
      check(timer.phase).equals(SleepTimerPhase.grace);
      check(pauseCount).equals(1);

      await timer.cancel();
    });
  });
}
