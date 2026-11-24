import 'dart:async';

import 'package:shelf_plus/features/player/domain/audio_player_engine.dart';

/// Deterministic in-memory [AudioPlayerEngine] fake for unit and widget tests.
class FakeAudioPlayerEngine implements AudioPlayerEngine {
  /// Creates a [FakeAudioPlayerEngine].
  new({this.supportsSkipSilence = true, this.throwOnDirectLoad = false});

  /// Simulated platform skip-silence capability.
  final bool supportsSkipSilence;

  /// When true, fails the next load call whose first track URI does not
  /// contain `hls` or `m3u8` (used to verify Direct -> HLS fallback).
  bool throwOnDirectLoad;

  final StreamController<AudioEngineState> _stateController =
      StreamController<AudioEngineState>.broadcast();
  final StreamController<void> _skipNextController =
      StreamController<void>.broadcast();
  final StreamController<void> _skipPrevController =
      StreamController<void>.broadcast();

  AudioEngineState _state = const AudioEngineState();

  /// Recorded load calls.
  final List<List<AudioEngineTrack>> loadedTrackLists =
      <List<AudioEngineTrack>>[];

  /// Number of `play()` invocations.
  int playCount = 0;

  /// Number of `pause()` invocations.
  int pauseCount = 0;

  /// Number of `stop()` invocations.
  int stopCount = 0;

  /// Recorded `setVolume` levels.
  final List<double> volumeHistory = <double>[];

  @override
  AudioEngineCapabilities get capabilities =>
      AudioEngineCapabilities(supportsSkipSilence: supportsSkipSilence);

  @override
  AudioEngineState get currentState => _state;

  @override
  Stream<AudioEngineState> get stateStream => _stateController.stream;

  @override
  Stream<void> get onSkipNextRequest => _skipNextController.stream;

  @override
  Stream<void> get onSkipPreviousRequest => _skipPrevController.stream;

  @override
  Future<void> loadBook({
    required AudioBookMetadata metadata,
    required List<AudioEngineTrack> tracks,
    required int initialTrackIndex,
    required Duration initialTrackPosition,
  }) async {
    loadedTrackLists.add(tracks);
    final isHls = tracks.any(
      (t) => t.uri.path.contains('hls') || t.uri.path.endsWith('.m3u8'),
    );
    if (throwOnDirectLoad && !isHls) {
      throw StateError('Simulated direct codec decode failure');
    }
    _emit(
      _state.copyWith(
        status: AudioPlaybackStatus.ready,
        trackIndex: initialTrackIndex,
        trackPosition: initialTrackPosition,
        clearError: true,
      ),
    );
  }

  @override
  Future<void> play() async {
    playCount++;
    _emit(_state.copyWith(playing: true, status: AudioPlaybackStatus.ready));
  }

  @override
  Future<void> pause() async {
    pauseCount++;
    _emit(_state.copyWith(playing: false));
  }

  @override
  Future<void> stop() async {
    stopCount++;
    _emit(const AudioEngineState());
  }

  @override
  Future<void> seekToTrack({
    required int trackIndex,
    required Duration position,
  }) async {
    _emit(_state.copyWith(trackIndex: trackIndex, trackPosition: position));
  }

  @override
  Future<void> setSpeed(double speed) async {
    _emit(_state.copyWith(speed: speed));
  }

  @override
  Future<void> setSkipSilence(bool enabled) async {
    if (!supportsSkipSilence) return;
    _emit(_state.copyWith(skipSilence: enabled));
  }

  @override
  Future<void> setVolume(double volume) async {
    final clamped = volume.clamp(0.0, 1.0);
    volumeHistory.add(clamped);
    _emit(_state.copyWith(volume: clamped));
  }

  /// Advances simulated playback to [position] on [trackIndex].
  void emitTrackPosition(int trackIndex, Duration position) {
    _emit(
      _state.copyWith(
        status: AudioPlaybackStatus.ready,
        trackIndex: trackIndex,
        trackPosition: position,
      ),
    );
  }

  /// Simulates OS notification next-chapter action.
  void triggerSkipNext() {
    if (!_skipNextController.isClosed) {
      _skipNextController.add(null);
    }
  }

  /// Simulates OS notification previous-chapter action.
  void triggerSkipPrevious() {
    if (!_skipPrevController.isClosed) {
      _skipPrevController.add(null);
    }
  }

  void _emit(AudioEngineState next) {
    _state = next;
    if (!_stateController.isClosed) {
      _stateController.add(next);
    }
  }

  @override
  Future<void> dispose() async {
    await _stateController.close();
    await _skipNextController.close();
    await _skipPrevController.close();
  }
}
