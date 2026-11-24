import 'dart:async';

import 'package:flutter/foundation.dart';

/// Lifecycle phase of the sleep timer.
enum SleepTimerPhase {
  /// Sleep timer is inactive.
  off,

  /// Counting down cleanly at full output volume.
  counting,

  /// Ramping output volume down to zero during the final fade window.
  fading,

  /// Playback paused; awaiting a shake-to-extend gesture before reset.
  grace,
}

/// Audiobook sleep timer with 10-second volume fade-out and 60-second
/// shake-to-extend grace window.
class SleepTimerController extends ChangeNotifier {
  /// Creates a [SleepTimerController].
  new({
    required this._setVolume,
    required this._pausePlayback,
    this._resumePlayback,
    this._onFadeOrGraceChanged,
    this.fadeDuration = const Duration(seconds: 10),
    this.graceDuration = const Duration(seconds: 60),
    this.defaultExtendDuration = const Duration(minutes: 15),
    this.tickInterval = const Duration(seconds: 1),
  });

  final Future<void> Function(double volume) _setVolume;
  final Future<void> Function() _pausePlayback;
  final Future<void> Function()? _resumePlayback;
  final void Function(bool active)? _onFadeOrGraceChanged;

  /// Fade-out duration prior to auto-pausing.
  final Duration fadeDuration;

  /// Window after auto-pause during which shaking extends the sleep timer.
  final Duration graceDuration;

  /// Default duration added when extending via shake or quick action.
  final Duration defaultExtendDuration;

  /// Countdown tick granularity.
  final Duration tickInterval;

  Timer? _timer;
  SleepTimerPhase _phase = SleepTimerPhase.off;
  Duration _remaining = Duration.zero;
  Duration _graceRemaining = Duration.zero;
  bool _endOfChapterMode = false;
  bool _wasFadeOrGraceActive = false;
  double? _lastChapterEndSec;
  double _lastBookPositionSec = 0;

  /// Current sleep timer phase.
  SleepTimerPhase get phase => _phase;

  /// Remaining sleep duration (or `Duration.zero` if end-of-chapter hasn't
  /// computed or timer is off).
  Duration get remaining => _remaining;

  /// Remaining grace window duration while in [SleepTimerPhase.grace].
  Duration get graceRemaining => _graceRemaining;

  /// Whether end-of-chapter mode is active.
  bool get endOfChapterMode => _endOfChapterMode;

  /// Whether fade-out or post-pause shake grace is active.
  bool get isFadeOrGraceActive =>
      _phase == SleepTimerPhase.fading || _phase == SleepTimerPhase.grace;

  /// Starts a timed sleep countdown of [duration].
  Future<void> startDuration(Duration duration) async {
    _cancelTimer();
    _endOfChapterMode = false;
    _graceRemaining = Duration.zero;
    if (duration <= Duration.zero) {
      await cancel();
      return;
    }
    _remaining = duration;
    await _setVolume(1);
    _updatePhaseForRemaining();
    _startTicker();
    _notifyAndSyncShakeState();
  }

  /// Configures the timer to pause at the end of the active chapter.
  Future<void> startEndOfChapter({
    double? currentPositionSec,
    double? activeChapterEndSec,
  }) async {
    _cancelTimer();
    _endOfChapterMode = true;
    _graceRemaining = Duration.zero;
    _phase = SleepTimerPhase.counting;
    if (currentPositionSec != null) {
      _lastBookPositionSec = currentPositionSec;
    }
    _lastChapterEndSec = activeChapterEndSec;
    _recomputeChapterRemaining();
    await _setVolume(1);
    _startTicker();
    _notifyAndSyncShakeState();
  }

  /// Updates the chapter boundary and position for end-of-chapter sleep timing.
  void onBookPositionChanged({
    required double positionSec,
    required double? activeChapterEndSec,
  }) {
    _lastBookPositionSec = positionSec;
    _lastChapterEndSec = activeChapterEndSec;
    if (_endOfChapterMode &&
        (_phase == SleepTimerPhase.counting ||
            _phase == SleepTimerPhase.fading)) {
      _recomputeChapterRemaining();
      _notifyAndSyncShakeState();
    }
  }

  /// Extends the active timer or revives playback during the fade/grace window.
  Future<void> extend([Duration? extension]) async {
    if (_phase == SleepTimerPhase.off) return;
    final added = extension ?? defaultExtendDuration;
    final wasGrace = _phase == SleepTimerPhase.grace;
    _cancelTimer();
    _endOfChapterMode = false;
    _graceRemaining = Duration.zero;
    _remaining = added;
    await _setVolume(1);
    if (wasGrace) {
      await _resumePlayback?.call();
    }
    _updatePhaseForRemaining();
    _startTicker();
    _notifyAndSyncShakeState();
  }

  /// Cancels any active sleep timer and restores full volume.
  Future<void> cancel() async {
    _cancelTimer();
    _phase = SleepTimerPhase.off;
    _remaining = Duration.zero;
    _graceRemaining = Duration.zero;
    _endOfChapterMode = false;
    await _setVolume(1);
    _notifyAndSyncShakeState();
  }

  void _startTicker() {
    _timer = Timer.periodic(tickInterval, (_) {
      unawaited(_onTick());
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _recomputeChapterRemaining() {
    final chapterEnd = _lastChapterEndSec;
    if (chapterEnd == null) {
      _remaining = Duration.zero;
      return;
    }
    final diffMs = ((chapterEnd - _lastBookPositionSec) * 1000).round();
    _remaining = Duration(milliseconds: diffMs > 0 ? diffMs : 0);
    if (_remaining <= Duration.zero) {
      unawaited(_enterGraceWindow());
    } else {
      _updatePhaseForRemaining();
    }
  }

  Future<void> _onTick() async {
    if (_phase == SleepTimerPhase.off) {
      _cancelTimer();
      return;
    }
    if (_phase == SleepTimerPhase.grace) {
      _graceRemaining -= tickInterval;
      if (_graceRemaining <= Duration.zero) {
        await cancel();
      } else {
        notifyListeners();
      }
      return;
    }

    if (_endOfChapterMode) {
      if (_lastChapterEndSec == null) return;
      _remaining -= tickInterval;
    } else {
      _remaining -= tickInterval;
    }

    if (_remaining <= Duration.zero) {
      await _enterGraceWindow();
      return;
    }

    _updatePhaseForRemaining();
    if (_phase == SleepTimerPhase.fading && fadeDuration.inMilliseconds > 0) {
      final ratio = (_remaining.inMilliseconds / fadeDuration.inMilliseconds)
          .clamp(0.0, 1.0);
      await _setVolume(ratio);
    }
    _notifyAndSyncShakeState();
  }

  void _updatePhaseForRemaining() {
    if (_endOfChapterMode && _lastChapterEndSec == null) {
      _phase = SleepTimerPhase.counting;
      return;
    }
    if (_remaining <= fadeDuration) {
      _phase = SleepTimerPhase.fading;
    } else {
      _phase = SleepTimerPhase.counting;
    }
  }

  Future<void> _enterGraceWindow() async {
    _remaining = Duration.zero;
    _endOfChapterMode = false;
    _phase = SleepTimerPhase.grace;
    _graceRemaining = graceDuration;
    _notifyAndSyncShakeState();
    await _pausePlayback();
    await _setVolume(1);
  }

  void _notifyAndSyncShakeState() {
    final active = isFadeOrGraceActive;
    if (active != _wasFadeOrGraceActive) {
      _wasFadeOrGraceActive = active;
      _onFadeOrGraceChanged?.call(active);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}
