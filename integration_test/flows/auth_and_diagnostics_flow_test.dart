import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/app/app.dart';
import 'package:shelf_plus/app/app_dependencies.dart';
import 'package:shelf_plus/app/flavor_config.dart';
import 'package:shelf_plus/core/database/app_database.dart';

import '../../test/fakes/fake_log_exporter.dart';
import '../../test/fakes/in_memory_secure_storage_service.dart';
import '../../test/fakes/mock_abs_server.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('E2E auth, subpath custom header, diagnostics, and sign out', (
    tester,
  ) async {
    final server = await MockAbsServer.start(
      basePathPrefix: '/audiobookshelf',
      requiredHeaders: const <String, String>{
        'CF-Access-Client-Secret': 'proxy-secret-e2e',
      },
    );
    addTearDown(server.close);

    final exporter = FakeLogExporter();
    final storage = InMemorySecureStorageService();
    final db = AppDatabase.inMemory();
    final deps = AppDependencies.create(
      flavorConfig: const FlavorConfig.dev(),
      database: db,
      secureStorage: storage,
      logExporter: exporter,
      useGoogleFonts: false,
    )..logger.level = Level.FINE;
    addTearDown(deps.dispose);

    await deps.authController.initialize();
    await tester.pumpWidget(ShelfPlusApp(dependencies: deps));
    await tester.pumpAndSettle();

    // Unauthenticated user starts on LoginScreen.
    check(find.text('Connect to Audiobookshelf').evaluate().length).equals(1);

    // Configure subpath server URL and required reverse-proxy header.
    await tester.enterText(
      find.byKey(const Key('login_server_url_field')),
      server.baseUrl,
    );
    await tester.tap(find.byKey(const Key('login_custom_headers_tile')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('login_add_header_button')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('custom_header_name_0')),
      'CF-Access-Client-Secret',
    );
    await tester.enterText(
      find.byKey(const Key('custom_header_value_0')),
      'proxy-secret-e2e',
    );

    // Probe server.
    await tester.tap(find.byKey(const Key('login_test_connection_button')));
    await tester.pumpAndSettle();
    check(find.text('Connected (2.26.0)').evaluate().length).equals(1);

    // Sign in.
    await tester.enterText(
      find.byKey(const Key('login_username_field')),
      'reader',
    );
    await tester.enterText(
      find.byKey(const Key('login_password_field')),
      'secret-password',
    );
    await tester.ensureVisible(find.byKey(const Key('login_sign_in_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('login_sign_in_button')));
    await tester.pumpAndSettle();

    // Lands on Home tab.
    check(find.text('Your listening shelf').evaluate().length).equals(1);

    // Navigate to Settings and verify server details.
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    check(find.textContaining('reader').evaluate().length).isGreaterThan(0);

    // Open Diagnostics, export logs, and assert secrets are redacted.
    await tester.ensureVisible(
      find.byKey(const Key('settings_diagnostics_tile')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('settings_diagnostics_tile')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('diagnostics_export_button')));
    await tester.pumpAndSettle();

    check(exporter.exportedPayloads.length).equals(1);
    final exported = exporter.exportedPayloads.single;
    check(exported.contains('secret-password')).isFalse;
    check(exported.contains('proxy-secret-e2e')).isFalse;
    check(exported.contains('access_token_1')).isFalse;

    // Back to Settings and sign out.
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('settings_sign_out_tile')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('settings_sign_out_tile')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm_sign_out_button')));
    await tester.pumpAndSettle();

    // Redirected back to LoginScreen and storage cleared.
    check(find.text('Connect to Audiobookshelf').evaluate().length).equals(1);
    check(storage.snapshot.isEmpty).isTrue;
  });
}
