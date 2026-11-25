import 'dart:async';

import 'package:checks/checks.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_plus/core/network/connectivity_service.dart';
import 'package:shelf_plus/features/downloads/domain/download_models.dart';

class _StubConnectivity implements Connectivity {
  new(this._initial);

  List<ConnectivityResult> _initial;
  final StreamController<List<ConnectivityResult>> controller =
      StreamController<List<ConnectivityResult>>.broadcast();

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async => _initial;

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      controller.stream;

  void emit(List<ConnectivityResult> next) {
    _initial = next;
    controller.add(next);
  }
}

void main() {
  group('ConnectivityPlusService & DownloadModels', () {
    test('mapConnectivityResults classifies wifi, cellular, and offline', () {
      check(
        mapConnectivityResults(const <ConnectivityResult>[
          ConnectivityResult.wifi,
        ]),
      ).equals(NetworkConnectionType.wifi);
      check(
        mapConnectivityResults(const <ConnectivityResult>[
          ConnectivityResult.ethernet,
        ]),
      ).equals(NetworkConnectionType.wifi);
      check(
        mapConnectivityResults(const <ConnectivityResult>[
          ConnectivityResult.vpn,
        ]),
      ).equals(NetworkConnectionType.wifi);
      check(
        mapConnectivityResults(const <ConnectivityResult>[
          ConnectivityResult.mobile,
        ]),
      ).equals(NetworkConnectionType.cellular);
      check(
        mapConnectivityResults(const <ConnectivityResult>[
          ConnectivityResult.none,
        ]),
      ).equals(NetworkConnectionType.offline);
    });

    test('ConnectivityPlusService emits deduplicated status changes', () async {
      final stub = _StubConnectivity(const <ConnectivityResult>[
        ConnectivityResult.mobile,
      ]);
      final service = ConnectivityPlusService(connectivity: stub);
      final emitted = <NetworkConnectionType>[];
      final sub = service.onStatusChanged.listen(emitted.add);

      final checked = await service.checkStatus();
      check(checked).equals(NetworkConnectionType.cellular);
      check(service.currentStatus).equals(NetworkConnectionType.cellular);

      // Duplicate status does not emit again.
      stub
        ..emit(const <ConnectivityResult>[ConnectivityResult.mobile])
        ..emit(const <ConnectivityResult>[ConnectivityResult.none])
        ..emit(const <ConnectivityResult>[ConnectivityResult.wifi]);
      await Future<void>.delayed(Duration.zero);

      check(emitted).deepEquals(const <NetworkConnectionType>[
        NetworkConnectionType.cellular,
        NetworkConnectionType.offline,
        NetworkConnectionType.wifi,
      ]);

      await sub.cancel();
      await service.dispose();
      await service.dispose();
      await stub.controller.close();
    });

    test('ByteFormatter and parseDownloadStatus cover all ranges', () {
      check(ByteFormatter.format(0)).equals('0 B');
      check(ByteFormatter.format(512)).equals('512 B');
      check(ByteFormatter.format(2048)).equals('2 KB');
      check(ByteFormatter.format(2 * 1024 * 1024)).equals('2.0 MB');
      check(ByteFormatter.format(2 * 1024 * 1024 * 1024)).equals('2.00 GB');

      check(parseDownloadStatus('queued')).equals(DownloadStatus.queued);
      check(parseDownloadStatus('downloading'))
          .equals(DownloadStatus.downloading);
      check(parseDownloadStatus('paused')).equals(DownloadStatus.paused);
      check(parseDownloadStatus('completed')).equals(DownloadStatus.completed);
      check(parseDownloadStatus('failed')).equals(DownloadStatus.failed);
      check(parseDownloadStatus('unknown')).equals(DownloadStatus.queued);
    });
  });
}
