import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/features/auth/domain/auth_repository.dart';
import 'package:shelf_plus/features/auth/domain/server_session.dart';

/// Lifecycle state of the active server authentication session.
enum AuthStatus {
  /// Checking secure storage and database for an existing session.
  initializing,

  /// No active server session exists; user must sign in.
  unauthenticated,

  /// Active server session is loaded and ready.
  authenticated,
}

/// Manages global authentication state and drives router auth redirects.
class AuthController extends ChangeNotifier {
  /// Creates an [AuthController].
  new({
    required this._authRepository,
    AuthStatus? initialStatus,
    ServerSession? initialSession,
  }) : _session = initialSession,
       _status =
           initialStatus ??
           (initialSession != null
               ? AuthStatus.authenticated
               : AuthStatus.initializing);

  final AuthRepository _authRepository;

  AuthStatus _status;
  ServerSession? _session;
  bool _sessionExpiredNotice = false;

  /// Current authentication lifecycle status.
  AuthStatus get status => _status;

  /// Currently active [ServerSession], or `null` when signed out.
  ServerSession? get session => _session;

  /// Whether the user was redirected to login due to an expired session.
  bool get sessionExpiredNotice => _sessionExpiredNotice;

  /// Convenience getter for whether the user is signed in.
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  /// Loads any persisted active session on startup.
  Future<void> initialize() async {
    final loaded = await _authRepository.loadActiveSession();
    _session = loaded;
    _status = loaded != null
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;
    notifyListeners();
  }

  /// Marks [session] as authenticated and clears any expiry notice.
  void setAuthenticated(ServerSession session) {
    _session = session;
    _status = AuthStatus.authenticated;
    _sessionExpiredNotice = false;
    notifyListeners();
  }

  /// Handles unrecoverable refresh-token expiration by clearing credentials
  /// and transitioning back to [AuthStatus.unauthenticated].
  Future<void> handleSessionExpired() async {
    if (_status == AuthStatus.unauthenticated) return;
    await _authRepository.logout();
    _session = null;
    _status = AuthStatus.unauthenticated;
    _sessionExpiredNotice = true;
    notifyListeners();
  }

  /// Signs out cleanly on user request.
  Future<void> signOut() async {
    await _authRepository.logout();
    _session = null;
    _status = AuthStatus.unauthenticated;
    _sessionExpiredNotice = false;
    notifyListeners();
  }
}
