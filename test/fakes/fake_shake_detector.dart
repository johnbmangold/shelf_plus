import 'dart:async';

import 'package:shelf_plus/features/player/domain/shake_detector.dart';

/// Deterministic [ShakeDetector] fake recording start/stop lifecycle calls.
class FakeShakeDetector implements ShakeDetector {
  final StreamController<void> _controller = StreamController<void>.broadcast();
  bool _listening = false;

  /// Number of `start()` transitions.
  int startCount = 0;

  /// Number of `stop()` transitions.
  int stopCount = 0;

  @override
  Stream<void> get onShake => _controller.stream;

  @override
  bool get isListening => _listening;

  @override
  void start() {
    startCount++;
    _listening = true;
  }

  @override
  void stop() {
    stopCount++;
    _listening = false;
  }

  /// Simulates a phone shake event only when the detector is actively started.
  void triggerShake() {
    if (_listening && !_controller.isClosed) {
      _controller.add(null);
    }
  }

  @override
  Future<void> dispose() async {
    _listening = false;
    await _controller.close();
  }
}
