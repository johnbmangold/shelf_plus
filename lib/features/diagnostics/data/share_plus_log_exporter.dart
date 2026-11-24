import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shelf_plus/features/diagnostics/domain/log_exporter.dart';

/// Platform [LogExporter] that writes a temporary log file and opens the OS
/// share sheet via `share_plus`.
class SharePlusLogExporter implements LogExporter {
  /// Creates a [SharePlusLogExporter].
  const new();

  @override
  Future<void> exportLogs(String redactedText) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/shelf_plus_diagnostics.log');
    await file.writeAsString(redactedText);

    await SharePlus.instance.share(
      ShareParams(
        files: <XFile>[XFile(file.path)],
        subject: 'Shelf Plus Diagnostics',
      ),
    );
  }
}
