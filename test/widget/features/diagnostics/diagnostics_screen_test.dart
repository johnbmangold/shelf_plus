import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/logging/log_redactor.dart';
import 'package:shelf_plus/features/diagnostics/presentation/diagnostics_screen.dart';

import '../../../fakes/fake_log_exporter.dart';
import '../../../helpers/pump_app.dart';

void main() {
  group('DiagnosticsScreen', () {
    testWidgets(
      'displays redacted logs, filters by level, exports, and clears',
      (tester) async {
        final logger =
            AppLogger(level: Level.FINE, forwardToDeveloperLog: false)
              ..fine('Fine probe log')
              ..info('User signed in with Bearer super_secret_token')
              ..warning('Slow response')
              ..severe('Sync failed', error: 'token=raw_secret');
        final exporter = FakeLogExporter();

        await tester.pumpLocalizedWidget(
          DiagnosticsScreen(logger: logger, logExporter: exporter),
        );

        // Secrets are redacted in rendered output.
        check(find.textContaining('super_secret_token').evaluate()).isEmpty;
        check(find.textContaining('raw_secret').evaluate()).isEmpty;
        check(find.textContaining(redactedPlaceholder).evaluate().length)
            .isGreaterThan(0);
        check(find.text('Fine probe log').evaluate().length).equals(1);

        // Filter to Errors only.
        await tester.tap(find.text('Errors'));
        await tester.pumpAndSettle();
        check(find.text('Fine probe log').evaluate()).isEmpty;
        check(find.text('Sync failed').evaluate().length).equals(1);

        // Export logs via LogExporter.
        await tester.tap(find.byKey(const Key('diagnostics_export_button')));
        await tester.pumpAndSettle();
        check(exporter.exportedPayloads.length).equals(1);
        check(exporter.exportedPayloads.single.contains('super_secret_token'))
            .isFalse;

        // Clear logs.
        await tester.tap(find.byKey(const Key('diagnostics_clear_button')));
        await tester.pumpAndSettle();
        check(
          find
              .text('No diagnostic logs matching this filter.')
              .evaluate()
              .length,
        ).equals(1);
      },
    );

    testWidgets('meets accessibility guidelines', (tester) async {
      final handle = tester.ensureSemantics();
      try {
        final logger = AppLogger(forwardToDeveloperLog: false)
          ..info('Diagnostic boot event');
        await tester.pumpLocalizedWidget(
          DiagnosticsScreen(logger: logger, logExporter: FakeLogExporter()),
        );
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
      } finally {
        handle.dispose();
      }
    });
  });
}
