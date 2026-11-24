import 'dart:collection';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:shelf_plus/core/logging/log_redactor.dart';

/// A single redacted diagnostic log entry.
@immutable
class LogEntry {
  /// Creates a [LogEntry].
  const new({
    required this.timestamp,
    required this.level,
    required this.loggerName,
    required this.message,
    this.error,
  });

  /// UTC timestamp when the record was created.
  final DateTime timestamp;

  /// Log severity level.
  final Level level;

  /// Logical logger name (for example, `shelf_plus.auth`).
  final String loggerName;

  /// Redacted log message.
  final String message;

  /// Optional redacted error description.
  final String? error;

  /// Formats this entry as a single human-readable diagnostic line.
  String formatLine() {
    final iso = timestamp.toUtc().toIso8601String();
    final base = '[$iso] ${level.name} [$loggerName] $message';
    if (error == null || error!.isEmpty) {
      return base;
    }
    return '$base | error: $error';
  }
}

/// Structured application logger backed by `package:logging`, `dart:developer`,
/// and a bounded in-memory ring buffer of redacted entries.
class AppLogger {
  /// Creates an [AppLogger] with a bounded buffer of [maxEntries].
  new({
    String rootName = 'shelf_plus',
    Level level = Level.INFO,
    this.maxEntries = 500,
    this._forwardToDeveloperLog = true,
  }) : assert(maxEntries > 0, 'maxEntries must be positive.'),
       _root = Logger.detached(rootName)..level = level {
    _root.onRecord.listen(_handleRecord);
  }

  final Logger _root;
  final bool _forwardToDeveloperLog;
  final ListQueue<LogEntry> _buffer = ListQueue<LogEntry>();

  /// Maximum number of log entries retained in memory.
  final int maxEntries;

  /// Unmodifiable snapshot of retained diagnostic log entries.
  List<LogEntry> get entries => List<LogEntry>.unmodifiable(_buffer);

  /// Active minimum logging level.
  Level get level => _root.level;

  /// Updates the active minimum logging level.
  set level(Level value) {
    _root.level = value;
  }

  /// Records a fine-grained diagnostic [message].
  void fine(String message, {String scope = 'app'}) {
    _log(Level.FINE, scope, message);
  }

  /// Records an informational [message].
  void info(String message, {String scope = 'app'}) {
    _log(Level.INFO, scope, message);
  }

  /// Records a warning [message] with optional [error] and [stackTrace].
  void warning(
    String message, {
    String scope = 'app',
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(Level.WARNING, scope, message, error: error, stackTrace: stackTrace);
  }

  /// Records a severe error [message] with optional [error] and [stackTrace].
  void severe(
    String message, {
    String scope = 'app',
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(Level.SEVERE, scope, message, error: error, stackTrace: stackTrace);
  }

  /// Clears all retained entries from the in-memory buffer.
  void clear() {
    _buffer.clear();
  }

  /// Exports all retained entries as newline-separated redacted text.
  String exportAsText() {
    return _buffer.map((entry) => entry.formatLine()).join('\n');
  }

  void _log(
    Level level,
    String scope,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    final scopedName = '${_root.name}.$scope';
    final record = LogRecord(
      level,
      LogRedactor.redact(message),
      scopedName,
      error == null ? null : LogRedactor.redact(error.toString()),
      stackTrace,
    );
    if (record.level >= _root.level) {
      _handleRecord(record);
    }
  }

  void _handleRecord(LogRecord record) {
    final entry = LogEntry(
      timestamp: record.time,
      level: record.level,
      loggerName: record.loggerName,
      message: LogRedactor.redact(record.message),
      error: record.error == null
          ? null
          : LogRedactor.redact(record.error.toString()),
    );

    if (_buffer.length >= maxEntries) {
      _buffer.removeFirst();
    }
    _buffer.addLast(entry);

    if (_forwardToDeveloperLog) {
      developer.log(
        entry.message,
        time: entry.timestamp,
        level: entry.level.value,
        name: entry.loggerName,
        error: entry.error,
        stackTrace: record.stackTrace,
      );
    }
  }
}
