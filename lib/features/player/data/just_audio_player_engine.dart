import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/features/player/data/shelf_audio_handler.dart';
import 'package:shelf_plus/features/player/domain/audio_player_engine.dart';

/// [AudioPlayerEngine] implementation backed by `just_audio`, `audio_service`,
/// and `audio_session`.
class JustAudioPlayerEngine implements AudioPlayerEngine {
  /// Creates a [JustAudioPlayerEngine].
  new({
    required this._logger,
    this.notificationChannelId = 'com.shcworks.shelfplus.channel.audio',
  });

  final AppLogger _logger;

  /// Android notification channel identifier registered with `audio_service`.
  final String notificationChannelId;

  AudioPlayer? _player;
  ShelfAudioHandler? _handler;
  Future<void>? _initFuture;
  bool _disposed = false;
  bool _needsPlayerReset = false;
  bool _resumeAfterInterruption = false;

  AudioEngineState _state = const AudioEngineState();
  final StreamController<AudioEngineState> _stateController =
      StreamController<AudioEngineState>.broadcast();
  final StreamController<void> _skipNextController =
      StreamController<void>.broadcast();
  final StreamController<void> _skipPreviousController =
      StreamController<void>.broadcast();
  final List<StreamSubscription<Object?>> _sessionAndHandlerSubscriptions =
      <StreamSubscription<Object?>>[];
  final List<StreamSubscription<Object?>> _playerSubscriptions =
      <StreamSubscription<Object?>>[];

  @override
  AudioEngineCapabilities get capabilities => AudioEngineCapabilities(
    supportsSkipSilence: defaultTargetPlatform == TargetPlatform.android,
  );

  @override
  AudioEngineState get currentState => _state;

  @override
  Stream<AudioEngineState> get stateStream => _stateController.stream;

  @override
  Stream<void> get onSkipNextRequest => _skipNextController.stream;

  @override
  Stream<void> get onSkipPreviousRequest => _skipPreviousController.stream;

  Future<void> _ensureInitialized() {
    if (_handler != null && _player != null) {
      return Future<void>.value();
    }
    return _initFuture ??= _initialize();
  }

  Future<void> _initialize() async {
    final player = AudioPlayer();
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    late final ShelfAudioHandler handler;
    handler = await AudioService.init(
      builder: () => ShelfAudioHandler(player: player),
      config: AudioServiceConfig(
        androidNotificationChannelId: notificationChannelId,
        androidNotificationChannelName: 'Audiobook Playback',
        androidNotificationOngoing: true,
        fastForwardInterval: const Duration(seconds: 30),
        rewindInterval: const Duration(seconds: 15),
      ),
    );

    _player = player;
    _handler = handler;

    _sessionAndHandlerSubscriptions.addAll(<StreamSubscription<Object?>>[
      session.becomingNoisyEventStream.listen((_) {
        unawaited(pause());
      }),
      session.interruptionEventStream.listen((event) {
        final activePlayer = _player;
        if (activePlayer == null) return;
        if (event.begin) {
          switch (event.type) {
            case AudioInterruptionType.duck:
              unawaited(activePlayer.setVolume(0.3));
            case AudioInterruptionType.pause:
            case AudioInterruptionType.unknown:
              _resumeAfterInterruption = activePlayer.playing;
              unawaited(pause());
          }
        } else {
          switch (event.type) {
            case AudioInterruptionType.duck:
              unawaited(activePlayer.setVolume(_state.volume));
            case AudioInterruptionType.pause:
              if (_resumeAfterInterruption) {
                _resumeAfterInterruption = false;
                unawaited(play());
              }
            case AudioInterruptionType.unknown:
              _resumeAfterInterruption = false;
          }
        }
      }),
      handler.onSkipNextRequest.listen((_) {
        if (!_skipNextController.isClosed) {
          _skipNextController.add(null);
        }
      }),
      handler.onSkipPreviousRequest.listen((_) {
        if (!_skipPreviousController.isClosed) {
          _skipPreviousController.add(null);
        }
      }),
    ]);

    _bindPlayerStreams(player);
  }

  void _bindPlayerStreams(AudioPlayer player) {
    _playerSubscriptions.addAll(<StreamSubscription<Object?>>[
      player.playerStateStream.listen((ps) {
        final mapped = switch (ps.processingState) {
          ProcessingState.idle => AudioPlaybackStatus.idle,
          ProcessingState.loading => AudioPlaybackStatus.loading,
          ProcessingState.buffering => AudioPlaybackStatus.buffering,
          ProcessingState.ready => AudioPlaybackStatus.ready,
          ProcessingState.completed => AudioPlaybackStatus.completed,
        };
        _emitState(
          _state.copyWith(
            status: mapped,
            playing: ps.playing,
            clearError: true,
          ),
        );
      }),
      player.positionStream.listen((pos) {
        _emitState(_state.copyWith(trackPosition: pos));
      }),
      player.bufferedPositionStream.listen((buf) {
        _emitState(_state.copyWith(bufferedPosition: buf));
      }),
      player.currentIndexStream.listen((idx) {
        if (idx != null) {
          _emitState(_state.copyWith(trackIndex: idx));
        }
      }),
      player.speedStream.listen((speed) {
        _emitState(_state.copyWith(speed: speed));
      }),
      player.skipSilenceEnabledStream.listen((enabled) {
        _emitState(_state.copyWith(skipSilence: enabled));
      }),
      player.volumeStream.listen((vol) {
        _emitState(_state.copyWith(volume: vol));
      }),
    ]);
  }

  Future<void> _resetPlayer() async {
    for (final sub in _playerSubscriptions) {
      await sub.cancel();
    }
    _playerSubscriptions.clear();
    final oldPlayer = _player;
    _player = null;
    if (oldPlayer != null) {
      try {
        await oldPlayer.dispose();
      } on Object catch (err) {
        _logger.fine(
          'Ignoring dispose error on wedged AudioPlayer: $err',
          scope: 'player',
        );
      }
    }
    final nextPlayer = AudioPlayer();
    _player = nextPlayer;
    await _handler?.replaceBackend(JustAudioShelfBackend(nextPlayer));
    _bindPlayerStreams(nextPlayer);
  }

  @override
  Future<void> loadBook({
    required AudioBookMetadata metadata,
    required List<AudioEngineTrack> tracks,
    required int initialTrackIndex,
    required Duration initialTrackPosition,
  }) async {
    if (tracks.isEmpty) {
      throw StateError('Cannot load an empty track list.');
    }
    await _ensureInitialized();
    if (_needsPlayerReset) {
      _needsPlayerReset = false;
      await _resetPlayer();
    }
    final player = _player;
    final handler = _handler;
    if (player == null || handler == null) return;

    handler.setNowPlaying(
      MediaItem(
        id: metadata.itemId,
        title: metadata.title,
        artist: metadata.author.isEmpty ? null : metadata.author,
        duration: Duration(milliseconds: (metadata.durationSec * 1000).round()),
        artUri: metadata.coverUri,
        artHeaders: metadata.coverHeaders.isEmpty
            ? null
            : metadata.coverHeaders,
      ),
    );

    final sources = tracks
        .map(
          (t) => AudioSource.uri(
            t.uri,
            headers: t.headers.isEmpty ? null : t.headers,
          ),
        )
        .toList(growable: false);
    final safeIndex = initialTrackIndex.clamp(0, sources.length - 1);
    final safePosition = initialTrackPosition.isNegative
        ? Duration.zero
        : initialTrackPosition;

    try {
      _emitState(
        _state.copyWith(
          status: AudioPlaybackStatus.loading,
          trackIndex: safeIndex,
          trackPosition: safePosition,
          clearError: true,
        ),
      );
      await player.setAudioSources(
        sources,
        initialIndex: safeIndex,
        initialPosition: safePosition,
      );
    } catch (err, stackTrace) {
      _needsPlayerReset = true;
      _logger.warning(
        'Failed loading audio sources for ${metadata.itemId}',
        scope: 'player',
        error: err,
        stackTrace: stackTrace,
      );
      _emitState(
        _state.copyWith(
          status: AudioPlaybackStatus.error,
          errorMessage: err.toString(),
        ),
      );
      rethrow;
    }
  }

  @override
  Future<void> play() async {
    final handler = _handler;
    if (handler == null) return;
    await handler.play();
  }

  @override
  Future<void> pause() async {
    final handler = _handler;
    if (handler == null) return;
    await handler.pause();
  }

  @override
  Future<void> stop() async {
    final handler = _handler;
    if (handler == null) return;
    await handler.stop();
  }

  @override
  Future<void> seekToTrack({
    required int trackIndex,
    required Duration position,
  }) async {
    final player = _player;
    if (player == null) return;
    await player.seek(position, index: trackIndex);
  }

  @override
  Future<void> setSpeed(double speed) async {
    final handler = _handler;
    if (handler == null) return;
    await handler.setSpeed(speed);
  }

  @override
  Future<void> setSkipSilence(bool enabled) async {
    if (!capabilities.supportsSkipSilence) return;
    final player = _player;
    if (player == null) return;
    await player.setSkipSilenceEnabled(enabled);
  }

  @override
  Future<void> setVolume(double volume) async {
    final player = _player;
    if (player == null) return;
    await player.setVolume(volume.clamp(0.0, 1.0));
  }

  void _emitState(AudioEngineState next) {
    _state = next;
    if (!_stateController.isClosed) {
      _stateController.add(next);
    }
  }

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    for (final sub in _playerSubscriptions) {
      await sub.cancel();
    }
    _playerSubscriptions.clear();
    for (final sub in _sessionAndHandlerSubscriptions) {
      await sub.cancel();
    }
    _sessionAndHandlerSubscriptions.clear();
    await _handler?.dispose();
    await _player?.dispose();
    await _stateController.close();
    await _skipNextController.close();
    await _skipPreviousController.close();
  }
}
