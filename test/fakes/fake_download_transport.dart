import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shelf_plus/features/downloads/domain/download_models.dart';
import 'package:shelf_plus/features/downloads/domain/download_transport.dart';

/// Deterministic in-process [DownloadTransport] writing real bytes to disk for
/// fast widget and controller tests.
class FakeDownloadTransport implements DownloadTransport {
  /// Creates a [FakeDownloadTransport].
  new({this.trackSizeBytes = 1024, this.onBeforeFinish});

  /// Byte size generated for each downloaded track.
  final int trackSizeBytes;

  /// Optional external signal awaited mid-download so tests can pause or
  /// switch connectivity while a transfer is actively in flight.
  Future<void> Function(CancelToken cancelToken)? onBeforeFinish;

  /// Number of `downloadTrack` invocations.
  int callCount = 0;

  @override
  Future<DownloadTransferResult> downloadTrack({
    required String url,
    required String destinationPath,
    required int existingBytes,
    required CancelToken cancelToken,
    DownloadProgressCallback? onProgress,
  }) async {
    callCount++;
    final file = File(destinationPath);
    file.parent.createSync(recursive: true);
    onProgress?.call(trackSizeBytes ~/ 2, trackSizeBytes);

    if (onBeforeFinish != null) {
      await onBeforeFinish!(cancelToken);
    }
    if (cancelToken.isCancelled) {
      final partFile = File('$destinationPath.part');
      partFile.writeAsBytesSync(List<int>.filled(trackSizeBytes ~/ 2, 7));
      throw DioException.requestCancelled(
        requestOptions: RequestOptions(path: url),
        reason: cancelToken.cancelError?.error,
      );
    }

    file.writeAsBytesSync(List<int>.filled(trackSizeBytes, 7));
    onProgress?.call(trackSizeBytes, trackSizeBytes);
    return DownloadTransferResult(
      finalPath: destinationPath,
      totalBytes: trackSizeBytes,
    );
  }
}
