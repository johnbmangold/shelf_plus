import 'package:dio/dio.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/logging/log_redactor.dart';

const String _startTimeExtraKey = '_shelf_request_start_ms';

/// Logs HTTP requests, response statuses, and redacted errors to [AppLogger]
/// without logging request/response bodies or raw credential headers.
class RedactedLoggingInterceptor extends Interceptor {
  /// Creates a [RedactedLoggingInterceptor].
  new({required this._logger});

  final AppLogger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startTimeExtraKey] = DateTime.now().millisecondsSinceEpoch;
    final redactedUri = LogRedactor.redact(options.uri.toString());
    _logger.fine('--> ${options.method} $redactedUri', scope: 'network');
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final elapsedMs = _elapsedMs(response.requestOptions);
    final redactedUri = LogRedactor.redact(
      response.requestOptions.uri.toString(),
    );
    _logger.fine(
      '<-- ${response.statusCode} ${response.requestOptions.method} '
      '$redactedUri (${elapsedMs}ms)',
      scope: 'network',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final elapsedMs = _elapsedMs(err.requestOptions);
    final redactedUri = LogRedactor.redact(err.requestOptions.uri.toString());
    final status = err.response?.statusCode;
    _logger.warning(
      '<-- ERROR ${status ?? err.type.name} ${err.requestOptions.method} '
      '$redactedUri (${elapsedMs}ms)',
      scope: 'network',
      error: err.message ?? err.type.name,
    );
    handler.next(err);
  }

  int _elapsedMs(RequestOptions options) {
    final startedAt = options.extra[_startTimeExtraKey];
    if (startedAt is int) {
      return DateTime.now().millisecondsSinceEpoch - startedAt;
    }
    return 0;
  }
}
