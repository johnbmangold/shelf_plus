import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_plus/core/network/abs_api_models.dart';
import 'package:shelf_plus/features/auth/presentation/auth_controller.dart';
import 'package:shelf_plus/features/auth/presentation/server_setup_view_model.dart';

import '../../../fakes/fake_auth_repository.dart';

void main() {
  group('ServerSetupViewModel', () {
    late FakeAuthRepository authRepo;
    late AuthController authController;
    late ServerSetupViewModel viewModel;

    setUp(() {
      authRepo = FakeAuthRepository();
      authController = AuthController(
        authRepository: authRepo,
        initialStatus: AuthStatus.unauthenticated,
      );
      viewModel = ServerSetupViewModel(
        authRepository: authRepo,
        authController: authController,
      );
    });

    tearDown(() {
      viewModel.dispose();
      authController.dispose();
    });

    test('manages custom headers and clears stale probe results', () {
      viewModel
        ..updateServerUrl('https://books.example.com')
        ..addCustomHeader()
        ..updateCustomHeader(0, name: 'CF-Access-Client-Id', value: 'id-1');

      check(viewModel.customHeaders.length).equals(1);
      check(viewModel.customHeaders.first.name).equals('CF-Access-Client-Id');

      viewModel.removeCustomHeader(0);
      check(viewModel.customHeaders).isEmpty;
    });

    test(
      'testConnection sets probeResult on success and error on failure',
      () async {
        viewModel.updateServerUrl('https://books.example.com/');
        final ok = await viewModel.testConnection();
        check(ok).isTrue;
        check(viewModel.probeResult?.serverVersion).equals('2.26.0');
        check(viewModel.error).isNull;

        authRepo.probeError = const AbsApiException(
          kind: AbsApiErrorKind.proxyAuthRequired,
        );
        final fail = await viewModel.testConnection();
        check(fail).isFalse;
        check(viewModel.probeResult).isNull;
        check(viewModel.error?.kind).equals(AbsApiErrorKind.proxyAuthRequired);
      },
    );

    test(
      'signIn updates AuthController on success and surfaces errors',
      () async {
        viewModel
          ..updateServerUrl('https://books.example.com')
          ..updateUsername('reader')
          ..updatePassword('secret');

        final ok = await viewModel.signIn();
        check(ok).isTrue;
        check(authController.isAuthenticated).isTrue;
        check(authController.session?.username).equals('reader');

        authRepo.loginError = const AbsApiException(
          kind: AbsApiErrorKind.invalidCredentials,
        );
        final fail = await viewModel.signIn();
        check(fail).isFalse;
        check(viewModel.error?.kind).equals(AbsApiErrorKind.invalidCredentials);
      },
    );
  });
}
