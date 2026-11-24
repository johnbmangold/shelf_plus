import 'package:dio/dio.dart';

/// Attaches user-configured custom HTTP headers (such as reverse-proxy auth
/// headers) to outgoing requests without overwriting per-request headers.
class CustomHeadersInterceptor extends Interceptor {
  /// Creates a [CustomHeadersInterceptor].
  new({required this._loadHeaders});

  final Future<Map<String, String>> Function() _loadHeaders;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final headers = await _loadHeaders();
    for (final entry in headers.entries) {
      if (entry.key.trim().isEmpty) continue;
      options.headers.putIfAbsent(entry.key, () => entry.value);
    }
    handler.next(options);
  }
}
