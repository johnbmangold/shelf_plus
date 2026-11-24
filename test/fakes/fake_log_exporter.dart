import 'package:shelf_plus/features/diagnostics/domain/log_exporter.dart';

/// Test double for [LogExporter] recording exported payloads in memory.
class FakeLogExporter implements LogExporter {
  /// History of exported diagnostic log payloads.
  final List<String> exportedPayloads = <String>[];

  /// Optional error to throw on the next [exportLogs] call.
  Exception? errorToThrow;

  @override
  Future<void> exportLogs(String redactedText) async {
    if (errorToThrow != null) {
      throw errorToThrow!;
    }
    exportedPayloads.add(redactedText);
  }
}
