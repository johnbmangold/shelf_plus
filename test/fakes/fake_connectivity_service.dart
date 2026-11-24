import 'dart:async';

import 'package:shelf_plus/core/network/connectivity_service.dart';

/// Deterministic [ConnectivityService] fake for offline/Wi-Fi gating tests.
class FakeConnectivityService implements ConnectivityService {
  /// Creates a [FakeConnectivityService].
  new({NetworkConnectionType initialStatus = NetworkConnectionType.wifi})
    : _status = initialStatus;

  NetworkConnectionType _status;
  final StreamController<NetworkConnectionType> _controller =
      StreamController<NetworkConnectionType>.broadcast();

  @override
  NetworkConnectionType get currentStatus => _status;

  @override
  Stream<NetworkConnectionType> get onStatusChanged => _controller.stream;

  @override
  Future<NetworkConnectionType> checkStatus() async => _status;

  /// Updates the simulated connection status and emits on [onStatusChanged].
  void setStatus(NetworkConnectionType next) {
    if (next == _status) return;
    _status = next;
    if (!_controller.isClosed) {
      _controller.add(next);
    }
  }

  @override
  Future<void> dispose() async {
    await _controller.close();
  }
}
