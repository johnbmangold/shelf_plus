import 'package:dio/dio.dart';
import 'package:shelf_plus/features/downloads/domain/download_models.dart';

/// Progress callback invoked while streaming chunks to disk.
typedef DownloadProgressCallback = void Function(
  int bytesReceived,
  int totalBytes,
);

/// Transport interface supporting HTTP byte-range resumption into `.part`
/// files and atomic finalization on completion.
abstract interface class DownloadTransport {
  /// Downloads [url] to [destinationPath], resuming from [existingBytes] if
  /// supported by the server, invoking [onProgress] as bytes land on disk.
  Future<DownloadTransferResult> downloadTrack({
    required String url,
    required String destinationPath,
    required int existingBytes,
    required CancelToken cancelToken,
    DownloadProgressCallback? onProgress,
  });
}
