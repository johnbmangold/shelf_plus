import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/network/abs_api_models.dart';

import '../../../fakes/fake_auth_repository.dart';
import '../../../helpers/pump_app.dart';

void main() {
  group('LoginScreen', () {
    testWidgets(
      'validates inputs, tests connection, adds custom header, and signs in',
      (tester) async {
        final fakeRepo = FakeAuthRepository();
        final deps = createTestDependencies(
          authRepository: fakeRepo,
          authenticated: false,
        );
        await tester.pumpShelfApp(dependencies: deps);

        // Redirected to LoginScreen when unauthenticated.
        check(find.text('Connect to Audiobookshelf').evaluate().length)
            .equals(1);

        // Empty submission shows validation errors.
        final signInButton = find.byKey(const Key('login_sign_in_button'));
        await tester.ensureVisible(signInButton);
        await tester.pumpAndSettle();
        await tester.tap(signInButton);
        await tester.pumpAndSettle();
        check(
          find
              .text('Enter a valid http:// or https:// server URL.')
              .evaluate()
              .length,
        ).equals(1);

        // Enter URL and test connection.
        final urlField = find.byKey(const Key('login_server_url_field'));
        await tester.ensureVisible(urlField);
        await tester.pumpAndSettle();
        await tester.enterText(urlField, 'https://books.example.com/abs');
        final probeButton = find.byKey(
          const Key('login_test_connection_button'),
        );
        await tester.ensureVisible(probeButton);
        await tester.pumpAndSettle();
        await tester.tap(probeButton);
        await tester.pumpAndSettle();
        check(find.text('Connected (2.26.0)').evaluate().length).equals(1);

        // Expand custom headers and add one header.
        final headersTile = find.byKey(const Key('login_custom_headers_tile'));
        await tester.ensureVisible(headersTile);
        await tester.pumpAndSettle();
        await tester.tap(headersTile);
        await tester.pumpAndSettle();
        final addHeaderButton = find.byKey(
          const Key('login_add_header_button'),
        );
        await tester.ensureVisible(addHeaderButton);
        await tester.pumpAndSettle();
        await tester.tap(addHeaderButton);
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const Key('custom_header_name_0')),
          'CF-Access-Client-Id',
        );
        await tester.enterText(
          find.byKey(const Key('custom_header_value_0')),
          'cf-id',
        );

        // Enter credentials and sign in.
        await tester.enterText(
          find.byKey(const Key('login_username_field')),
          'reader',
        );
        await tester.enterText(
          find.byKey(const Key('login_password_field')),
          'secret-password',
        );
        await tester.ensureVisible(signInButton);
        await tester.pumpAndSettle();
        await tester.tap(signInButton);
        await tester.pumpAndSettle();

        // Redirected into main Home tab upon login.
        check(find.text('Your listening shelf').evaluate().length).equals(1);
        check(deps.authController.session?.customHeaders)
            .isNotNull()
            .deepEquals(const <String, String>{'CF-Access-Client-Id': 'cf-id'});
      },
    );

    testWidgets(
      'displays auth error and navigates to Diagnostics from LoginScreen',
      (tester) async {
        final fakeRepo = FakeAuthRepository()
          ..loginError = const AbsApiException(
            kind: AbsApiErrorKind.invalidCredentials,
          );
        final deps = createTestDependencies(
          authRepository: fakeRepo,
          authenticated: false,
        );
        await tester.pumpShelfApp(dependencies: deps);

        await tester.enterText(
          find.byKey(const Key('login_server_url_field')),
          'https://books.example.com',
        );
        await tester.enterText(
          find.byKey(const Key('login_username_field')),
          'reader',
        );
        await tester.enterText(
          find.byKey(const Key('login_password_field')),
          'wrong',
        );
        final signInButton = find.byKey(const Key('login_sign_in_button'));
        await tester.ensureVisible(signInButton);
        await tester.pumpAndSettle();
        await tester.tap(signInButton);
        await tester.pumpAndSettle();

        check(find.text('Invalid username or password.').evaluate().length)
            .equals(1);

        final diagButton = find.byKey(
          const Key('login_view_diagnostics_button'),
        );
        await tester.ensureVisible(diagButton);
        await tester.pumpAndSettle();
        await tester.tap(diagButton);
        await tester.pumpAndSettle();
        check(find.text('Diagnostics').evaluate().length).equals(1);
      },
    );

    testWidgets('meets accessibility guidelines on LoginScreen', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      try {
        final deps = createTestDependencies(
          authRepository: FakeAuthRepository(),
          authenticated: false,
        );
        await tester.pumpShelfApp(dependencies: deps);
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
      } finally {
        handle.dispose();
      }
    });
  });
}
