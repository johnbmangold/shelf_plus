import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/app/flavor_config.dart';
import 'package:shelf_plus/core/theme/app_theme_mode.dart';

import '../../fakes/fake_auth_repository.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('App shell navigation, settings, and auth routing', () {
    testWidgets('redirects unauthenticated users to LoginScreen', (
      tester,
    ) async {
      final deps = createTestDependencies(authenticated: false);
      await tester.pumpShelfApp(dependencies: deps);

      check(find.text('Connect to Audiobookshelf').evaluate().length).equals(1);
    });

    testWidgets('navigates across all 4 tabs with persistent mini-player bar', (
      tester,
    ) async {
      await tester.pumpShelfApp();

      // Starts on Home tab.
      check(find.text('Your listening shelf').evaluate().length).equals(1);
      check(find.text('Nothing playing').evaluate().length).equals(1);

      // Navigate to Library.
      await tester.tap(find.text('Library'));
      await tester.pumpAndSettle();
      check(find.text('Library browser').evaluate().length).equals(1);
      check(find.text('Nothing playing').evaluate().length).equals(1);

      // Navigate to Downloads.
      await tester.tap(find.text('Downloads'));
      await tester.pumpAndSettle();
      check(find.text('Offline downloads').evaluate().length).equals(1);
      check(find.text('Nothing playing').evaluate().length).equals(1);

      // Navigate to Settings.
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      check(find.text('Server & Account').evaluate().length).equals(1);
      check(find.text('Appearance').evaluate().length).equals(1);
      check(find.text('com.shcworks.shelfplus.dev').evaluate().length)
          .equals(1);
      check(find.text('Nothing playing').evaluate().length).equals(1);
    });

    testWidgets(
      'updates theme mode from Settings including True-Black AMOLED',
      (tester) async {
        final deps = await tester.pumpShelfApp(
          dependencies: createTestDependencies(
            flavorConfig: const FlavorConfig.prod(),
          ),
        );

        await tester.tap(find.text('Settings'));
        await tester.pumpAndSettle();

        check(find.text('com.shcworks.shelfplus').evaluate().length).equals(1);

        await tester.tap(find.text('AMOLED'));
        await tester.pumpAndSettle();
        check(deps.themeController.mode).equals(AppThemeMode.amoled);

        final scaffoldFinder = find.descendant(
          of: find.byType(Navigator),
          matching: find.byType(Scaffold),
        );
        final settingsContext = tester.element(scaffoldFinder.last);
        check(Theme.of(settingsContext).scaffoldBackgroundColor)
            .equals(Colors.black);

        await tester.tap(find.text('Light'));
        await tester.pumpAndSettle();
        check(deps.themeController.mode).equals(AppThemeMode.light);
        check(Theme.of(tester.element(scaffoldFinder.last)).brightness)
            .equals(Brightness.light);
      },
    );

    testWidgets(
      'opens Diagnostics and signs out via confirmation dialog to LoginScreen',
      (tester) async {
        final fakeRepo = FakeAuthRepository(
          activeSession: testAuthenticatedSession,
        );
        final deps = await tester.pumpShelfApp(
          dependencies: createTestDependencies(authRepository: fakeRepo),
        );

        await tester.tap(find.text('Settings'));
        await tester.pumpAndSettle();

        await tester.ensureVisible(
          find.byKey(const Key('settings_diagnostics_tile')),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('settings_diagnostics_tile')));
        await tester.pumpAndSettle();
        check(find.text('Diagnostics').evaluate().length).equals(1);

        await tester.pageBack();
        await tester.pumpAndSettle();

        await tester.ensureVisible(
          find.byKey(const Key('settings_sign_out_tile')),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('settings_sign_out_tile')));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('confirm_sign_out_button')));
        await tester.pumpAndSettle();

        check(fakeRepo.logoutCalls).equals(1);
        check(deps.authController.isAuthenticated).isFalse;
        check(find.text('Connect to Audiobookshelf').evaluate().length)
            .equals(1);
      },
    );

    testWidgets('meets tap target and contrast accessibility guidelines', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      try {
        await tester.pumpShelfApp();
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));

        await tester.tap(find.text('Settings'));
        await tester.pumpAndSettle();
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
      } finally {
        handle.dispose();
      }
    });
  });
}
