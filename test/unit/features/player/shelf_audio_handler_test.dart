import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shelf_plus/features/player/data/shelf_audio_handler.dart';

class _FakeShelfAudioBackend implements ShelfAudioBackend {
  final StreamController<PlaybackEvent> _events =
      StreamController<PlaybackEvent>.broadcast();

  @override
  bool playing = false;

  @override
  ProcessingState processingState = ProcessingState.idle;

  @override
  Duration position = Duration.zero;

  @override
  Duration bufferedPosition = Duration.zero;

  @override
  Duration? duration = const Duration(minutes: 10);

  @override
  double speed = 1;

  int playCalls = 0;
  int pauseCalls = 0;
  int stopCalls = 0;
  Duration? lastSeek;
  double? lastSpeed;

  @override
  Stream<PlaybackEvent> get playbackEventStream => _events.stream;

  @override
  Future<void> play() async {
    playCalls++;
    playing = true;
    emitEvent();
  }

  @override
  Future<void> pause() async {
    pauseCalls++;
    playing = false;
    emitEvent();
  }

  @override
  Future<void> stop() async {
    stopCalls++;
    playing = false;
    processingState = ProcessingState.idle;
    emitEvent();
  }

  @override
  Future<void> seek(Duration position) async {
    this.position = position;
    lastSeek = position;
    emitEvent();
  }

  @override
  Future<void> setSpeed(double speed) async {
    this.speed = speed;
    lastSpeed = speed;
    emitEvent();
  }

  void emitEvent({int? currentIndex}) {
    _events.add(PlaybackEvent(currentIndex: currentIndex));
  }

  Future<void> dispose() => _events.close();
}

void main() {
  group('ShelfAudioHandler', () {
    late _FakeShelfAudioBackend backend;
    late ShelfAudioHandler handler;

    setUp(() {
      backend = _FakeShelfAudioBackend();
      handler = ShelfAudioHandler(backend: backend);
    });

    tearDown(() async {
      await handler.dispose();
      await backend.dispose();
    });

    test('forwards transport, clamped rewind/fastForward, and speed', () async {
      handler.setNowPlaying(const MediaItem(id: 'item-1', title: 'Hail Mary'));
      check(handler.mediaItem.value?.id).equals('item-1');

      await handler.play();
      check(backend.playCalls).equals(1);
      check(handler.playbackState.value.playing).isTrue;

      await handler.setSpeed(1.5);
      check(backend.lastSpeed).equals(1.5);

      backend.position = const Duration(seconds: 5);
      await handler.rewind();
      check(backend.lastSeek).equals(Duration.zero);

      backend.position = const Duration(minutes: 9, seconds: 50);
      await handler.fastForward();
      check(backend.lastSeek).equals(const Duration(minutes: 10));

      await handler.seek(const Duration(seconds: 42));
      check(backend.lastSeek).equals(const Duration(seconds: 42));

      await handler.pause();
      check(backend.pauseCalls).equals(1);
      await handler.stop();
      check(backend.stopCalls).equals(1);
    });

    test('broadcasts all processing states and emits skip requests', () async {
      var nextCount = 0;
      var prevCount = 0;
      final subNext = handler.onSkipNextRequest.listen((_) => nextCount++);
      final subPrev = handler.onSkipPreviousRequest.listen((_) => prevCount++);

      await handler.skipToNext();
      await handler.skipToPrevious();
      await Future<void>.delayed(Duration.zero);
      check(nextCount).equals(1);
      check(prevCount).equals(1);

      for (final state in ProcessingState.values) {
        backend
          ..processingState = state
          ..emitEvent(currentIndex: 1);
      }
      await Future<void>.delayed(Duration.zero);
      check(handler.playbackState.value.processingState)
          .equals(AudioProcessingState.completed);
      check(handler.playbackState.value.queueIndex).equals(1);

      await subNext.cancel();
      await subPrev.cancel();
    });

    test(
      'replaceBackend switches control delegation and stream updates',
      () async {
        final replacement = _FakeShelfAudioBackend();
        addTearDown(replacement.dispose);

        await handler.replaceBackend(replacement);
        await handler.play();
        check(backend.playCalls).equals(0);
        check(replacement.playCalls).equals(1);
        check(handler.playbackState.value.playing).isTrue;

        // Old backend events should be ignored after replacement.
        backend
          ..processingState = ProcessingState.completed
          ..emitEvent(currentIndex: 99);
        await Future<void>.delayed(Duration.zero);
        check(handler.playbackState.value.queueIndex).isNull;

        replacement
          ..processingState = ProcessingState.ready
          ..emitEvent(currentIndex: 0);
        await Future<void>.delayed(Duration.zero);
        check(handler.playbackState.value.processingState)
            .equals(AudioProcessingState.ready);
        check(handler.playbackState.value.queueIndex).equals(0);
      },
    );
  });
}
