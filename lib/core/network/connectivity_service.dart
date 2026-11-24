import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// High-level network availability state used for download gating and
/// automatic offline sync flushing.
enum NetworkConnectionType {
  /// Unmetered Wi-Fi, Ethernet, or VPN transport.
  wifi,

  /// Metered cellular data connection.
  cellular,

  /// No active network connectivity.
  offline,
}

/// Maps `connectivity_plus` result flags to [NetworkConnectionType].
NetworkConnectionType mapConnectivityResults(List<ConnectivityResult> results) {
  if (results.contains(ConnectivityResult.wifi) ||
      results.contains(ConnectivityResult.ethernet) ||
      results.contains(ConnectivityResult.vpn)) {
    return NetworkConnectionType.wifi;
  }
  if (results.contains(ConnectivityResult.mobile) ||
      results.contains(ConnectivityResult.other)) {
    return NetworkConnectionType.cellular;
  }
  return NetworkConnectionType.offline;
}

/// Abstract connectivity monitor enabling deterministic offline/Wi-Fi tests.
abstract class ConnectivityService {
  /// Latest known network state.
  NetworkConnectionType get currentStatus;

  /// Broadcast stream emitting updates whenever network type changes.
  Stream<NetworkConnectionType> get onStatusChanged;

  /// Actively queries the OS for current connectivity status.
  Future<NetworkConnectionType> checkStatus();

  /// Releases subscriptions and stream controllers.
  Future<void> dispose();
}

/// Production [ConnectivityService] backed by `connectivity_plus`.
class ConnectivityPlusService implements ConnectivityService {
  /// Creates a [ConnectivityPlusService].
  new({
    Connectivity? connectivity,
    NetworkConnectionType initialStatus = NetworkConnectionType.wifi,
  }) : _connectivity = connectivity ?? Connectivity(),
       _currentStatus = initialStatus {
    _sub = _connectivity.onConnectivityChanged.listen((results) {
      _updateStatus(mapConnectivityResults(results));
    });
  }

  final Connectivity _connectivity;
  NetworkConnectionType _currentStatus;
  late final StreamSubscription<List<ConnectivityResult>> _sub;
  final StreamController<NetworkConnectionType> _controller =
      StreamController<NetworkConnectionType>.broadcast();
  bool _disposed = false;

  @override
  NetworkConnectionType get currentStatus => _currentStatus;

  @override
  Stream<NetworkConnectionType> get onStatusChanged => _controller.stream;

  @override
  Future<NetworkConnectionType> checkStatus() async {
    final results = await _connectivity.checkConnectivity();
    return _updateStatus(mapConnectivityResults(results));
  }

  NetworkConnectionType _updateStatus(NetworkConnectionType next) {
    if (next == _currentStatus) return _currentStatus;
    _currentStatus = next;
    if (!_controller.isClosed) {
      _controller.add(next);
    }
    return _currentStatus;
  }

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    await _sub.cancel();
    await _controller.close();
  }
}
