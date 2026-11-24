import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_plus/features/player/domain/smart_rewind_policy.dart';

void main() {
  group('SmartRewindPolicy', () {
    const policy = SmartRewindPolicy();

    test('scales rewind duration with pause length', () {
      check(policy.rewindDurationForPause(const Duration(seconds: 10)))
          .equals(Duration.zero);
      check(policy.rewindDurationForPause(const Duration(seconds: 30)))
          .equals(const Duration(seconds: 5));
      check(policy.rewindDurationForPause(const Duration(minutes: 10)))
          .equals(const Duration(seconds: 12));
      check(policy.rewindDurationForPause(const Duration(hours: 2)))
          .equals(const Duration(seconds: 20));
      check(policy.rewindDurationForPause(const Duration(hours: 12)))
          .equals(const Duration(seconds: 30));
    });

    test('clamps resumed position at zero and honors disabled flag', () {
      check(
        policy.computeResumePositionSec(
          currentPositionSec: 4,
          pauseDuration: const Duration(hours: 12),
        ),
      ).equals(0);
      check(
        policy.computeResumePositionSec(
          currentPositionSec: 100,
          pauseDuration: const Duration(hours: 12),
          isEnabled: false,
        ),
      ).equals(100);
    });
  });
}
