import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shelf_plus/features/downloads/domain/download_models.dart';
import 'package:shelf_plus/features/downloads/domain/download_transport.dart';

/// Resumable HTTP range [DownloadTransport] backed by an authenticated [Dio]
/// instance.
class DioDownloadTransport implements DownloadTransport {
  /// Creates a [DioDownloadTransport] using `_dio`.
  const new(this._dio);

  final Dio _dio;

  @override
  Future<DownloadTransferResult> downloadTrack({
    required String url,
    required String destinationPath,
    required int existingBytes,
    required CancelToken cancelToken,
    DownloadProgressCallback? onProgress,
  }) async {
    final destFile = File(destinationPath);
    await destFile.parent.create(recursive: true);

    final partFile = File('$destinationPath.part');
    final actualExisting = partFile.existsSync() ? partFile.lengthSync() : 0;
    final resumeOffset = existingBytes > 0 && actualExisting >= existingBytes
        ? existingBytes
        : actualExisting;

    final headers = <String, String>{
      if (resumeOffset > 0) 'range': 'bytes=$resumeOffset-',
    };

    final response = await _dio.get<ResponseBody>(
      url,
      cancelToken: cancelToken,
      options: Options(
        responseType: ResponseType.stream,
        headers: headers,
        receiveTimeout: const Duration(minutes: 10),
      ),
    );

    final status = response.statusCode ?? 200;
    final isPartial = status == 206 && resumeOffset > 0;
    final baseOffset = isPartial ? resumeOffset : 0;

    final totalBytes = _resolveTotalBytes(
      headers: response.headers,
      baseOffset: baseOffset,
    );

    final sink = partFile.openWrite(
      mode: isPartial ? FileMode.append : FileMode.writeOnly,
    );
    var received = baseOffset;
    var lastReportedBytes = received;

    final completer = Completer<void>();
    late final StreamSubscription<List<int>> sub;

    sub = response.data!.stream.listen(
      (chunk) {
        sink.add(chunk);
        received += chunk.length;
        if (onProgress != null &&
            (received - lastReportedBytes >= 65536 ||
                (totalBytes > 0 && received >= totalBytes))) {
          lastReportedBytes = received;
          onProgress(received, totalBytes > 0 ? totalBytes : received);
        }
      },
      onError: (Object err, StackTrace st) async {
        await sink.flush();
        await sink.close();
        if (!completer.isCompleted) {
          completer.completeError(err, st);
        }
      },
      onDone: () async {
        await sink.flush();
        await sink.close();
        if (!completer.isCompleted) {
          completer.complete();
        }
      },
      cancelOnError: true,
    );

    unawaited(
      cancelToken.whenCancel.then((err) async {
        await sub.cancel();
        await sink.flush();
        await sink.close();
        if (!completer.isCompleted) {
          completer.completeError(err);
        }
      }),
    );

    await completer.future;

    if (onProgress != null && received != lastReportedBytes) {
      onProgress(received, totalBytes > 0 ? totalBytes : received);
    }

    if (destFile.existsSync()) {
      await destFile.delete();
    }
    await partFile.rename(destinationPath);

    return DownloadTransferResult(
      finalPath: destinationPath,
      totalBytes: received,
    );
  }

  static int _resolveTotalBytes({
    required Headers headers,
    required int baseOffset,
  }) {
    final contentRange = headers.value('content-range');
    if (contentRange != null) {
      final slashIndex = contentRange.lastIndexOf('/');
      if (slashIndex != -1) {
        final rawTotal = contentRange.substring(slashIndex + 1).trim();
        final parsed = int.tryParse(rawTotal);
        if (parsed != null && parsed > 0) return parsed;
      }
    }
    final rawLength = headers.value(Headers.contentLengthHeader);
    final parsedLength = rawLength == null ? null : int.tryParse(rawLength);
    if (parsedLength != null && parsedLength > 0) {
      return baseOffset + parsedLength;
    }
    return 0;
  }
}
