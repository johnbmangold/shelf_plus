import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

/// Minimal audio player backend interface for [ShelfAudioHandler], allowing
/// deterministic unit testing without platform `AudioPlayer` channels.
abstract interface class ShelfAudioBackend {
  /// Broadcasts player state transitions and index updates.
  Stream<PlaybackEvent> get playbackEventStream;

  /// Whether audio is actively playing.
  bool get playing;

  /// Current `just_audio` processing state.
  ProcessingState get processingState;

  /// Active playback position within the current track.
  Duration get position;

  /// Buffered position within the current track.
  Duration get bufferedPosition;

  /// Active track duration, if known.
  Duration? get duration;

  /// Current playback speed multiplier.
  double get speed;

  /// Starts playback.
  Future<void> play();

  /// Pauses playback.
  Future<void> pause();

  /// Stops playback.
  Future<void> stop();

  /// Seeks to [position].
  Future<void> seek(Duration position);

  /// Updates playback [speed].
  Future<void> setSpeed(double speed);
}

/// Default [ShelfAudioBackend] delegating directly to a `just_audio`
/// [AudioPlayer].
class JustAudioShelfBackend implements ShelfAudioBackend {
  /// Creates a [JustAudioShelfBackend] wrapping `_player`.
  const new(this._player);

  final AudioPlayer _player;

  @override
  Stream<PlaybackEvent> get playbackEventStream => _player.playbackEventStream;

  @override
  bool get playing => _player.playing;

  @override
  ProcessingState get processingState => _player.processingState;

  @override
  Duration get position => _player.position;

  @override
  Duration get bufferedPosition => _player.bufferedPosition;

  @override
  Duration? get duration => _player.duration;

  @override
  double get speed => _player.speed;

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);
}

/// `audio_service` background handler bridging [ShelfAudioBackend] to Android
/// Media3 notifications and iOS Control Center / Now Playing controls.
class ShelfAudioHandler extends BaseAudioHandler with SeekHandler {
  /// Creates a [ShelfAudioHandler] wrapping either [backend] or [player].
  new({
    AudioPlayer? player,
    ShelfAudioBackend? backend,
    this.rewindInterval = const Duration(seconds: 15),
    this.fastForwardInterval = const Duration(seconds: 30),
  }) : assert(
         backend != null || player != null,
         'Either backend or player must be supplied.',
       ),
       _backend = backend ?? JustAudioShelfBackend(player!) {
    _eventSub = _backend.playbackEventStream.listen(_broadcastState);
  }

  final ShelfAudioBackend _backend;

  /// Interval jumped backward on notification/headset rewind.
  final Duration rewindInterval;

  /// Interval jumped forward on notification/headset fast-forward.
  final Duration fastForwardInterval;

  final StreamController<void> _skipNextController =
      StreamController<void>.broadcast();
  final StreamController<void> _skipPreviousController =
      StreamController<void>.broadcast();
  late final StreamSubscription<PlaybackEvent> _eventSub;

  /// Stream emitted when system media controls invoke skip-to-next.
  Stream<void> get onSkipNextRequest => _skipNextController.stream;

  /// Stream emitted when system media controls invoke skip-to-previous.
  Stream<void> get onSkipPreviousRequest => _skipPreviousController.stream;

  /// Updates the active OS media notification metadata.
  void setNowPlaying(MediaItem item) {
    mediaItem.add(item);
  }

  @override
  Future<void> play() => _backend.play();

  @override
  Future<void> pause() => _backend.pause();

  @override
  Future<void> stop() async {
    await _backend.stop();
    await super.stop();
  }

  @override
  Future<void> seek(Duration position) => _backend.seek(position);

  @override
  Future<void> setSpeed(double speed) => _backend.setSpeed(speed);

  @override
  Future<void> rewind() async {
    final target = _backend.position - rewindInterval;
    await _backend.seek(target.isNegative ? Duration.zero : target);
  }

  @override
  Future<void> fastForward() async {
    final duration = _backend.duration;
    var target = _backend.position + fastForwardInterval;
    if (duration != null && target > duration) {
      target = duration;
    }
    await _backend.seek(target);
  }

  @override
  Future<void> skipToNext() async {
    if (!_skipNextController.isClosed) {
      _skipNextController.add(null);
    }
  }

  @override
  Future<void> skipToPrevious() async {
    if (!_skipPreviousController.isClosed) {
      _skipPreviousController.add(null);
    }
  }

  void _broadcastState(PlaybackEvent event) {
    final isPlaying = _backend.playing;
    playbackState.add(
      playbackState.value.copyWith(
        controls: <MediaControl>[
          MediaControl.skipToPrevious,
          MediaControl.rewind,
          if (isPlaying) MediaControl.pause else MediaControl.play,
          MediaControl.fastForward,
          MediaControl.skipToNext,
        ],
        systemActions: const <MediaAction>{
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
          MediaAction.setSpeed,
        },
        androidCompactActionIndices: const <int>[1, 2, 3],
        processingState: switch (_backend.processingState) {
          ProcessingState.idle => AudioProcessingState.idle,
          ProcessingState.loading => AudioProcessingState.loading,
          ProcessingState.buffering => AudioProcessingState.buffering,
          ProcessingState.ready => AudioProcessingState.ready,
          ProcessingState.completed => AudioProcessingState.completed,
        },
        playing: isPlaying,
        updatePosition: _backend.position,
        bufferedPosition: _backend.bufferedPosition,
        speed: _backend.speed,
        queueIndex: event.currentIndex,
      ),
    );
  }

  /// Cancels playback listeners and closes skip-action streams.
  Future<void> dispose() async {
    await _eventSub.cancel();
    await _skipNextController.close();
    await _skipPreviousController.close();
  }
}
