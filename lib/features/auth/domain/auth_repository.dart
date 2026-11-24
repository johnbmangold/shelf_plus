import 'package:shelf_plus/core/network/abs_api_models.dart';
import 'package:shelf_plus/features/auth/domain/server_session.dart';

/// Repository handling Audiobookshelf server probing, authentication, and
/// encrypted session persistence.
abstract interface class AuthRepository {
  /// Probes [serverUrl] with optional [customHeaders] to verify Audiobookshelf
  /// reachability and capabilities.
  Future<ServerProbeResult> probeServer({
    required String serverUrl,
    Map<String, String> customHeaders = const <String, String>{},
  });

  /// Signs in to [serverUrl], persists the server profile and encrypted
  /// credentials, and returns the active [ServerSession].
  Future<ServerSession> login({
    required String serverUrl,
    required String username,
    required String password,
    Map<String, String> customHeaders = const <String, String>{},
  });

  /// Loads the currently active [ServerSession] from local storage, or `null`
  /// if signed out or credentials are missing.
  Future<ServerSession?> loadActiveSession();

  /// Signs out of the active server and clears its stored credentials.
  Future<void> logout();
}
