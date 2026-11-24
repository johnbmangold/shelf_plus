import 'dart:async';

import 'package:shelf_plus/core/socket/abs_socket_events.dart';
import 'package:shelf_plus/core/socket/abs_socket_service.dart';

/// In-memory [AbsSocketService] fake for testing foreground lifecycle and
/// real-time event emission without network sockets.
class FakeAbsSocketService implements AbsSocketService {
  final StreamController<AbsSocketEvent> _controller =
      StreamController<AbsSocketEvent>.broadcast();
  final Set<String> _selfSessionIds = <String>{};

  bool _isConnected = false;

  /// Number of [connect] invocations.
  int connectCalls = 0;

  /// Number of [disconnect] invocations.
  int disconnectCalls = 0;

  @override
  Stream<AbsSocketEvent> get events => _controller.stream;

  @override
  bool get isConnected => _isConnected;

  @override
  Future<void> connect({
    required String baseUrl,
    required String accessToken,
    Map<String, String> customHeaders = const <String, String>{},
  }) async {
    connectCalls++;
    _isConnected = true;
  }

  @override
  Future<void> disconnect() async {
    disconnectCalls++;
    _isConnected = false;
  }

  /// Pushes a synthetic [event] to listeners.
  void emit(AbsSocketEvent event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  @override
  void registerSelfSessionId(String sessionId) {
    _selfSessionIds.add(sessionId);
  }

  @override
  void unregisterSelfSessionId(String sessionId) {
    _selfSessionIds.remove(sessionId);
  }

  @override
  void dispose() {
    unawaited(_controller.close());
  }
}
