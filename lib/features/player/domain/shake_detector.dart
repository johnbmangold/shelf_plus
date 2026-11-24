import 'dart:async';
import 'dart:math' as math;

import 'package:sensors_plus/sensors_plus.dart';

/// Standard Earth gravity in m/s^2 for normalizing accelerometer readings.
const double _standardGravity = 9.80665;

/// Evaluates whether an accelerometer sample [(x, y, z)] exceeds [thresholdG].
bool isShakeMagnitude(double x, double y, double z, {double thresholdG = 2.2}) {
  final magnitudeG = math.sqrt((x * x) + (y * y) + (z * z)) / _standardGravity;
  return magnitudeG >= thresholdG;
}

/// Abstract accelerometer shake detector active only while started.
abstract class ShakeDetector {
  /// Broadcast stream emitting an event when a debounced shake occurs.
  Stream<void> get onShake;

  /// Whether the underlying sensor listener is currently active.
  bool get isListening;

  /// Begins listening to accelerometer events.
  void start();

  /// Stops listening to accelerometer events to conserve battery.
  void stop();

  /// Releases stream controllers and subscriptions.
  Future<void> dispose();
}

/// Hardware accelerometer implementation backed by `sensors_plus`.
class SensorsShakeDetector implements ShakeDetector {
  /// Creates a [SensorsShakeDetector].
  new({
    Stream<AccelerometerEvent> Function()? streamFactory,
    this.thresholdG = 2.2,
    this.cooldown = const Duration(milliseconds: 1000),
    DateTime Function()? now,
  }) : _streamFactory = streamFactory ?? accelerometerEventStream,
       _now = now ?? DateTime.now;

  final Stream<AccelerometerEvent> Function() _streamFactory;
  final DateTime Function() _now;

  /// G-force threshold above which an acceleration spike counts as a shake.
  final double thresholdG;

  /// Minimum interval between consecutive shake events.
  final Duration cooldown;

  final StreamController<void> _controller = StreamController<void>.broadcast();
  StreamSubscription<AccelerometerEvent>? _subscription;
  DateTime? _lastShakeAt;
  bool _disposed = false;

  @override
  Stream<void> get onShake => _controller.stream;

  @override
  bool get isListening => _subscription != null;

  @override
  void start() {
    if (_disposed || _subscription != null) return;
    _subscription = _streamFactory().listen((event) {
      if (!isShakeMagnitude(
        event.x,
        event.y,
        event.z,
        thresholdG: thresholdG,
      )) {
        return;
      }
      final current = _now();
      final last = _lastShakeAt;
      if (last != null && current.difference(last) < cooldown) {
        return;
      }
      _lastShakeAt = current;
      if (!_controller.isClosed) {
        _controller.add(null);
      }
    });
  }

  @override
  void stop() {
    unawaited(_subscription?.cancel());
    _subscription = null;
  }

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    stop();
    await _controller.close();
  }
}
