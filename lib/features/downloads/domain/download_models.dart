import 'package:flutter/foundation.dart';

/// Lifecycle states for an audiobook offline download task.
enum DownloadStatus {
  /// Waiting in queue to start or waiting for Wi-Fi.
  queued,

  /// Actively streaming bytes to a `.part` file.
  downloading,

  /// Paused by the user or by Wi-Fi-only gating; `.part` bytes retained.
  paused,

  /// All tracks completed and verified on local storage.
  completed,

  /// Transfer failed due to a network or I/O error.
  failed,
}

/// Parses a persisted [raw] status string into [DownloadStatus].
DownloadStatus parseDownloadStatus(String raw) {
  return switch (raw) {
    'queued' => DownloadStatus.queued,
    'downloading' => DownloadStatus.downloading,
    'paused' => DownloadStatus.paused,
    'completed' => DownloadStatus.completed,
    'failed' => DownloadStatus.failed,
    _ => DownloadStatus.queued,
  };
}

/// Byte formatting helpers for storage meters and download cards.
abstract final class ByteFormatter {
  /// Formats [bytes] into compact human-readable storage units.
  static String format(int bytes) {
    if (bytes <= 0) return '0 B';
    const kb = 1024;
    const mb = kb * 1024;
    const gb = mb * 1024;
    if (bytes >= gb) {
      return '${(bytes / gb).toStringAsFixed(2)} GB';
    }
    if (bytes >= mb) {
      return '${(bytes / mb).toStringAsFixed(1)} MB';
    }
    if (bytes >= kb) {
      return '${(bytes / kb).toStringAsFixed(0)} KB';
    }
    return '$bytes B';
  }
}

/// Progress snapshot reported during an active track download.
@immutable
class DownloadTransferResult {
  /// Creates a [DownloadTransferResult].
  const new({required this.finalPath, required this.totalBytes});

  /// Finalized local file path on disk.
  final String finalPath;

  /// Total finalized file size in bytes.
  final int totalBytes;
}
