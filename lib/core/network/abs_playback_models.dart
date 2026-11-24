import 'package:flutter/foundation.dart';

/// How the Audiobookshelf server delivers audio for a playback session.
enum AbsPlayMethod {
  /// Direct file streaming with byte-range seeking.
  directPlay,

  /// Direct remuxed stream.
  directStream,

  /// HLS transcoded stream.
  transcode,

  /// Local offline file playback.
  local,
}

/// Parses an integer `playMethod` from ABS `/api/items/:id/play`.
AbsPlayMethod parseAbsPlayMethod(Object? raw) {
  final value = (raw as num?)?.toInt();
  return switch (value) {
    0 => AbsPlayMethod.directPlay,
    1 => AbsPlayMethod.directStream,
    2 => AbsPlayMethod.transcode,
    3 => AbsPlayMethod.local,
    _ => AbsPlayMethod.directPlay,
  };
}

/// Single audio file or HLS stream track returned in a playback session.
@immutable
class AbsAudioTrackDto {
  /// Creates an [AbsAudioTrackDto].
  const new({
    required this.index,
    required this.startOffsetSec,
    required this.durationSec,
    required this.contentUrl,
    this.title = '',
    this.mimeType,
    this.codec,
  });

  /// Parses an [AbsAudioTrackDto] from JSON.
  factory fromJson(Map<String, dynamic> json) {
    return AbsAudioTrackDto(
      index: (json['index'] as num?)?.toInt() ?? 0,
      startOffsetSec: (json['startOffset'] as num?)?.toDouble() ?? 0,
      durationSec: (json['duration'] as num?)?.toDouble() ?? 0,
      contentUrl: json['contentUrl'] as String? ?? '',
      title: json['title'] as String? ?? '',
      mimeType: json['mimeType'] as String?,
      codec: json['codec'] as String?,
    );
  }

  /// Zero-based track index within the book's ordered track list.
  final int index;

  /// Cumulative start offset of this track within the book timeline (seconds).
  final double startOffsetSec;

  /// Duration of this audio track in seconds.
  final double durationSec;

  /// Relative or absolute URL to stream this track.
  final String contentUrl;

  /// Optional display title for the track.
  final String title;

  /// Optional MIME type reported by the server.
  final String? mimeType;

  /// Optional audio codec reported by the server.
  final String? codec;
}

/// Playback session payload returned by `POST /api/items/:id/play`.
@immutable
class AbsPlaybackSessionDto {
  /// Creates an [AbsPlaybackSessionDto].
  const new({
    required this.sessionId,
    required this.libraryItemId,
    required this.playMethod,
    required this.startTimeSec,
    required this.currentTimeSec,
    required this.durationSec,
    required this.audioTracks,
  });

  /// Parses an [AbsPlaybackSessionDto] from JSON.
  factory fromJson(Map<String, dynamic> json) {
    final rawTracks =
        json['audioTracks'] as List<dynamic>? ?? const <Object?>[];
    final tracks = rawTracks
        .whereType<Map<String, dynamic>>()
        .map(AbsAudioTrackDto.fromJson)
        .where((t) => t.contentUrl.isNotEmpty)
        .toList(growable: false);

    return AbsPlaybackSessionDto(
      sessionId: json['id'] as String? ?? '',
      libraryItemId: json['libraryItemId'] as String? ?? '',
      playMethod: parseAbsPlayMethod(json['playMethod']),
      startTimeSec: (json['startTime'] as num?)?.toDouble() ?? 0,
      currentTimeSec: (json['currentTime'] as num?)?.toDouble() ?? 0,
      durationSec: (json['duration'] as num?)?.toDouble() ?? 0,
      audioTracks: tracks,
    );
  }

  /// Server-assigned session identifier used for `/sync` and `/close`.
  final String sessionId;

  /// Library item identifier being played.
  final String libraryItemId;

  /// Delivery method negotiated by the server.
  final AbsPlayMethod playMethod;

  /// Position at session start in seconds.
  final double startTimeSec;

  /// Authoritative resume position in seconds.
  final double currentTimeSec;

  /// Total audiobook duration in seconds.
  final double durationSec;

  /// Ordered audio tracks forming the playback timeline.
  final List<AbsAudioTrackDto> audioTracks;

  /// Whether this session uses transcoded HLS delivery.
  bool get isHls => playMethod == AbsPlayMethod.transcode;
}
