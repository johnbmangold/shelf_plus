/// Abstraction for exporting redacted diagnostic log text out of the app.
abstract interface class LogExporter {
  /// Exports [redactedText] via the platform share sheet or file handler.
  Future<void> exportLogs(String redactedText);
}
