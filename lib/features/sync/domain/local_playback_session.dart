import 'package:flutter/foundation.dart';

/// Offline listening session queued for replay via `POST /api/syncLocalSession`.
@immutable
class LocalPlaybackSession {
  /// Creates a [LocalPlaybackSession].
  const new({
    required this.id,
    required this.libraryItemId,
    required this.durationSec,
    required this.startTimeSec,
    required this.currentTimeSec,
    required this.timeListeningSec,
    required this.startedAtMs,
    required this.updatedAtMs,
    required this.isFinished,
  });

  /// Deserializes a queued [LocalPlaybackSession] from JSON.
  factory fromJson(Map<String, dynamic> json) {
    return LocalPlaybackSession(
      id: json['id'] as String? ?? '',
      libraryItemId: json['libraryItemId'] as String? ?? '',
      durationSec: (json['duration'] as num?)?.toDouble() ?? 0,
      startTimeSec: (json['startTime'] as num?)?.toDouble() ?? 0,
      currentTimeSec: (json['currentTime'] as num?)?.toDouble() ?? 0,
      timeListeningSec: (json['timeListening'] as num?)?.toDouble() ?? 0,
      startedAtMs: (json['startedAt'] as num?)?.toInt() ?? 0,
      updatedAtMs: (json['updatedAt'] as num?)?.toInt() ?? 0,
      isFinished: json['isFinished'] as bool? ?? false,
    );
  }

  /// Client-generated UUIDv4 session identifier.
  final String id;

  /// Associated Audiobookshelf library item ID.
  final String libraryItemId;

  /// Total audiobook duration in seconds.
  final double durationSec;

  /// Starting listening position in seconds for this offline session.
  final double startTimeSec;

  /// Latest listening position in seconds reached in this session.
  final double currentTimeSec;

  /// Elapsed listening seconds accumulated during this session.
  final double timeListeningSec;

  /// Epoch milliseconds (UTC) when this local session began.
  final int startedAtMs;

  /// Epoch milliseconds (UTC) when this local session was last updated.
  final int updatedAtMs;

  /// Whether the listener reached the end of the book.
  final bool isFinished;

  /// Serializes this session into the Audiobookshelf `/api/syncLocalSession`
  /// JSON payload.
  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'libraryItemId': libraryItemId,
      'mediaType': 'book',
      'playMethod': 3,
      'duration': durationSec,
      'startTime': startTimeSec,
      'currentTime': currentTimeSec,
      'timeListening': timeListeningSec,
      'startedAt': startedAtMs,
      'updatedAt': updatedAtMs,
      'isFinished': isFinished,
    };
  }
}
