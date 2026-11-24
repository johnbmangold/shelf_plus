import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/logging/log_redactor.dart';

void main() {
  group('AppLogger', () {
    test('retains at most maxEntries in FIFO ring buffer', () {
      final logger = AppLogger(maxEntries: 3, forwardToDeveloperLog: false)
        ..info('one')
        ..info('two')
        ..info('three')
        ..info('four');

      check(logger.entries.length).equals(3);
      check(logger.entries.map((e) => e.message).toList())
          .deepEquals(<String>['two', 'three', 'four']);
    });

    test('redacts secrets in both message and error string', () {
      final logger = AppLogger(forwardToDeveloperLog: false)
        ..severe(
          'Auth failed with Bearer secret_abc',
          scope: 'auth',
          error: StateError('x-refresh-token: refresh_xyz'),
        );

      check(logger.entries.length).equals(1);
      final entry = logger.entries.single;
      check(entry.loggerName).equals('shelf_plus.auth');
      check(entry.message.contains('secret_abc')).isFalse;
      check(entry.message).contains(redactedPlaceholder);
      check(entry.error).isNotNull();
      check(entry.error!.contains('refresh_xyz')).isFalse;
      check(entry.error!).contains(redactedPlaceholder);
    });

    test(
      'filters out fine messages when level is INFO and enables on FINE',
      () {
        final logger = AppLogger(forwardToDeveloperLog: false)..fine('hidden');

        check(logger.entries).isEmpty;

        logger
          ..level = Level.FINE
          ..fine('visible');
        check(logger.entries.length).equals(1);
        check(logger.entries.single.message).equals('visible');
      },
    );

    test('exportAsText formats lines and clear empties buffer', () {
      final logger = AppLogger(forwardToDeveloperLog: false)
        ..info('boot')
        ..warning('retry', scope: 'sync', error: 'timeout');

      final exported = logger.exportAsText();
      check(exported).contains('INFO [shelf_plus.app] boot');
      check(exported)
          .contains('WARNING [shelf_plus.sync] retry | error: timeout');

      logger.clear();
      check(logger.entries).isEmpty;
      check(logger.exportAsText()).equals('');
    });
  });
}
