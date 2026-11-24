import 'dart:math' as math;

/// Escalating smart-rewind policy applied when resuming after a pause.
class SmartRewindPolicy {
  /// Creates a [SmartRewindPolicy].
  const new();

  /// Computes the rewind duration for a given [pauseDuration].
  Duration rewindDurationForPause(
    Duration pauseDuration, {
    bool isEnabled = true,
  }) {
    if (!isEnabled || pauseDuration.isNegative) {
      return Duration.zero;
    }
    final seconds = pauseDuration.inSeconds;
    if (seconds < 30) {
      return Duration.zero;
    }
    if (seconds < const Duration(minutes: 5).inSeconds) {
      return const Duration(seconds: 5);
    }
    if (seconds < const Duration(hours: 1).inSeconds) {
      return const Duration(seconds: 12);
    }
    if (seconds < const Duration(hours: 8).inSeconds) {
      return const Duration(seconds: 20);
    }
    return const Duration(seconds: 30);
  }

  /// Computes the clamped resume position in seconds after applying rewind.
  double computeResumePositionSec({
    required double currentPositionSec,
    required Duration pauseDuration,
    bool isEnabled = true,
  }) {
    final rewind = rewindDurationForPause(pauseDuration, isEnabled: isEnabled);
    final shifted = currentPositionSec - (rewind.inMilliseconds / 1000.0);
    return math.max(0, shifted);
  }
}
