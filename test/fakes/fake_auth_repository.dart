import 'package:shelf_plus/core/network/abs_api_models.dart';
import 'package:shelf_plus/features/auth/domain/auth_repository.dart';
import 'package:shelf_plus/features/auth/domain/server_session.dart';

/// Configurable in-memory [AuthRepository] fake for ViewModel and widget tests.
class FakeAuthRepository implements AuthRepository {
  /// Creates a [FakeAuthRepository].
  new({this.activeSession});

  /// Currently stored session returned by [loadActiveSession].
  ServerSession? activeSession;

  /// Optional probe result returned by [probeServer].
  ServerProbeResult? probeResult;

  /// Optional exception thrown by [probeServer].
  AbsApiException? probeError;

  /// Optional exception thrown by [login].
  AbsApiException? loginError;

  /// Count of [logout] invocations.
  int logoutCalls = 0;

  @override
  Future<ServerProbeResult> probeServer({
    required String serverUrl,
    Map<String, String> customHeaders = const <String, String>{},
  }) async {
    if (probeError != null) throw probeError!;
    return probeResult ??
        ServerProbeResult(
          normalizedBaseUrl: serverUrl.trim(),
          isInitialized: true,
          serverVersion: '2.26.0',
          authMethods: const <String>['local'],
        );
  }

  @override
  Future<ServerSession> login({
    required String serverUrl,
    required String username,
    required String password,
    Map<String, String> customHeaders = const <String, String>{},
  }) async {
    if (loginError != null) throw loginError!;
    final session = ServerSession(
      serverId: 'fake-server-1',
      baseUrl: serverUrl.trim(),
      displayName: 'Fake ABS Server',
      userId: 'user-1',
      username: username,
      supportsRefreshTokens: true,
      serverVersion: '2.26.0',
      customHeaders: customHeaders,
    );
    activeSession = session;
    return session;
  }

  @override
  Future<ServerSession?> loadActiveSession() async => activeSession;

  @override
  Future<void> logout() async {
    logoutCalls++;
    activeSession = null;
  }
}
