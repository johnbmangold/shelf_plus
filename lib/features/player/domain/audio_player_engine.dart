import 'package:flutter/foundation.dart';

/// Platform capabilities supported by an [AudioPlayerEngine] implementation.
@immutable
class AudioEngineCapabilities {
  /// Creates an [AudioEngineCapabilities].
  const new({required this.supportsSkipSilence});

  /// Whether silence trimming is natively supported on this platform.
  final bool supportsSkipSilence;
}

/// Lifecycle state of the underlying audio playback engine.
enum AudioPlaybackStatus {
  /// No book is currently loaded.
  idle,

  /// Initial audio stream is loading.
  loading,

  /// Playback stalled temporarily while buffering network audio.
  buffering,

  /// Audio is loaded and ready to play or paused.
  ready,

  /// Playback reached the end of the final track.
  completed,

  /// Engine encountered a fatal load or decode failure.
  error,
}

/// Playable audio track passed to an [AudioPlayerEngine].
@immutable
class AudioEngineTrack {
  /// Creates an [AudioEngineTrack].
  const new({
    required this.id,
    required this.uri,
    required this.startOffsetSec,
    required this.durationSec,
    this.title = '',
    this.headers = const <String, String>{},
  });

  /// Unique track identifier.
  final String id;

  /// Streaming URI or local file URI.
  final Uri uri;

  /// Offset within the book timeline in seconds.
  final double startOffsetSec;

  /// Track duration in seconds.
  final double durationSec;

  /// Optional track display title.
  final String title;

  /// Optional HTTP request headers for protected servers.
  final Map<String, String> headers;
}

/// Book metadata displayed in platform media notifications and lock screens.
@immutable
class AudioBookMetadata {
  /// Creates an [AudioBookMetadata].
  const new({
    required this.itemId,
    required this.title,
    required this.author,
    required this.durationSec,
    this.coverUri,
    this.coverHeaders = const <String, String>{},
  });

  /// Library item identifier.
  final String itemId;

  /// Book title.
  final String title;

  /// Author display name.
  final String author;

  /// Total book duration in seconds.
  final double durationSec;

  /// Optional artwork URI for notification/lock-screen art.
  final Uri? coverUri;

  /// Optional HTTP headers needed to fetch [coverUri].
  final Map<String, String> coverHeaders;
}

/// Immutable snapshot of the engine's current playback state.
@immutable
class AudioEngineState {
  /// Creates an [AudioEngineState].
  const new({
    this.status = AudioPlaybackStatus.idle,
    this.playing = false,
    this.trackIndex = 0,
    this.trackPosition = Duration.zero,
    this.bufferedPosition = Duration.zero,
    this.speed = 1.0,
    this.skipSilence = false,
    this.volume = 1.0,
    this.errorMessage,
  });

  /// Current lifecycle status.
  final AudioPlaybackStatus status;

  /// Whether audio is actively outputting.
  final bool playing;

  /// Active zero-based track index.
  final int trackIndex;

  /// Position within [trackIndex].
  final Duration trackPosition;

  /// Buffered position within [trackIndex].
  final Duration bufferedPosition;

  /// Active playback speed multiplier.
  final double speed;

  /// Whether skip silence is currently enabled.
  final bool skipSilence;

  /// Active output gain in `[0.0, 1.0]`.
  final double volume;

  /// Error description when [status] is [AudioPlaybackStatus.error].
  final String? errorMessage;

  /// Returns a copy with overridden fields.
  AudioEngineState copyWith({
    AudioPlaybackStatus? status,
    bool? playing,
    int? trackIndex,
    Duration? trackPosition,
    Duration? bufferedPosition,
    double? speed,
    bool? skipSilence,
    double? volume,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AudioEngineState(
      status: status ?? this.status,
      playing: playing ?? this.playing,
      trackIndex: trackIndex ?? this.trackIndex,
      trackPosition: trackPosition ?? this.trackPosition,
      bufferedPosition: bufferedPosition ?? this.bufferedPosition,
      speed: speed ?? this.speed,
      skipSilence: skipSilence ?? this.skipSilence,
      volume: volume ?? this.volume,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Platform-agnostic interface for background audiobook playback engines.
abstract class AudioPlayerEngine {
  /// Capabilities exposed by this engine on the active platform.
  AudioEngineCapabilities get capabilities;

  /// Latest state snapshot.
  AudioEngineState get currentState;

  /// Broadcast stream of engine state updates.
  Stream<AudioEngineState> get stateStream;

  /// Stream of OS/notification next-chapter requests (optional convenience).
  Stream<void> get onSkipNextRequest;

  /// Stream of OS/notification previous-chapter requests.
  Stream<void> get onSkipPreviousRequest;

  /// Loads [tracks] and seeks cleanly to [initialTrackIndex]/[initialTrackPosition].
  Future<void> loadBook({
    required AudioBookMetadata metadata,
    required List<AudioEngineTrack> tracks,
    required int initialTrackIndex,
    required Duration initialTrackPosition,
  });

  /// Starts or resumes playback.
  Future<void> play();

  /// Pauses playback.
  Future<void> pause();

  /// Stops playback and clears notification state.
  Future<void> stop();

  /// Seeks to [position] within [trackIndex].
  Future<void> seekToTrack({
    required int trackIndex,
    required Duration position,
  });

  /// Sets playback speed multiplier.
  Future<void> setSpeed(double speed);

  /// Toggles silence skipping if supported by [capabilities].
  Future<void> setSkipSilence(bool enabled);

  /// Sets playback volume in `[0.0, 1.0]`.
  Future<void> setVolume(double volume);

  /// Releases audio resources.
  Future<void> dispose();
}
