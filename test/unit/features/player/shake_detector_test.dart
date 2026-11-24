import 'dart:async';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shelf_plus/features/player/domain/shake_detector.dart';

void main() {
  group('SensorsShakeDetector', () {
    test(
      'detects threshold spikes, debounces bursts, and stops cleanly',
      () async {
        final source = StreamController<AccelerometerEvent>.broadcast();
        var currentTime = DateTime.utc(2026, 1, 1, 12);
        final detector = SensorsShakeDetector(
          streamFactory: () => source.stream,
          now: () => currentTime,
        );

        final shakes = <void>[];
        final sub = detector.onShake.listen(shakes.add);

        check(detector.isListening).isFalse;
        source.add(AccelerometerEvent(30, 0, 0, currentTime));
        await Future<void>.delayed(Duration.zero);
        check(shakes).isEmpty;

        detector.start();
        check(detector.isListening).isTrue;

        // Gentle tilt (~1G) ignored; first ~3G spike triggers; immediate burst
        // within 1s cooldown debounced.
        source
          ..add(AccelerometerEvent(0, 9.8, 0, currentTime))
          ..add(AccelerometerEvent(29.4, 0, 0, currentTime));
        currentTime = currentTime.add(const Duration(milliseconds: 300));
        source.add(AccelerometerEvent(29.4, 0, 0, currentTime));
        await Future<void>.delayed(Duration.zero);
        check(shakes.length).equals(1);

        // Spike after cooldown triggers again.
        currentTime = currentTime.add(const Duration(seconds: 2));
        source.add(AccelerometerEvent(29.4, 0, 0, currentTime));
        await Future<void>.delayed(Duration.zero);
        check(shakes.length).equals(2);

        detector.stop();
        check(detector.isListening).isFalse;
        source.add(AccelerometerEvent(35, 0, 0, currentTime));
        await Future<void>.delayed(Duration.zero);
        check(shakes.length).equals(2);

        await sub.cancel();
        await detector.dispose();
        await source.close();
      },
    );
  });
}
