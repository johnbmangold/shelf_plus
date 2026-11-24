import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/network/abs_api_models.dart';
import 'package:shelf_plus/core/network/abs_url_builder.dart';
import 'package:shelf_plus/features/auth/domain/auth_repository.dart';
import 'package:shelf_plus/features/auth/presentation/auth_controller.dart';

/// Mutable entry representing a custom HTTP header row in the login form.
class CustomHeaderEntry {
  /// Creates a [CustomHeaderEntry].
  new({this.name = '', this.value = ''});

  /// HTTP header name (for example, `CF-Access-Client-Id`).
  String name;

  /// HTTP header value.
  String value;
}

/// ViewModel managing the server setup, probe, custom headers, and sign-in
/// form state.
class ServerSetupViewModel extends ChangeNotifier {
  /// Creates a [ServerSetupViewModel].
  new({required this._authRepository, required this._authController});

  final AuthRepository _authRepository;
  final AuthController _authController;

  String _serverUrl = '';
  String _username = '';
  String _password = '';
  final List<CustomHeaderEntry> _customHeaders = <CustomHeaderEntry>[];

  bool _isProbing = false;
  bool _isSigningIn = false;
  ServerProbeResult? _probeResult;
  AbsApiException? _error;

  /// Current server URL input.
  String get serverUrl => _serverUrl;

  /// Current username input.
  String get username => _username;

  /// Current password input.
  String get password => _password;

  /// Unmodifiable list of configured custom HTTP header rows.
  List<CustomHeaderEntry> get customHeaders =>
      List<CustomHeaderEntry>.unmodifiable(_customHeaders);

  /// Whether a server probe request is currently running.
  bool get isProbing => _isProbing;

  /// Whether a sign-in request is currently running.
  bool get isSigningIn => _isSigningIn;

  /// Result from the most recent successful [testConnection], if still valid.
  ServerProbeResult? get probeResult => _probeResult;

  /// Most recent error thrown by probing or signing in, if any.
  AbsApiException? get error => _error;

  /// Whether any network request is currently in flight.
  bool get isBusy => _isProbing || _isSigningIn;

  /// Updates the server URL input and clears stale probe/error state.
  void updateServerUrl(String value) {
    if (_serverUrl == value) return;
    _serverUrl = value;
    _probeResult = null;
    _error = null;
    notifyListeners();
  }

  /// Updates the username input.
  void updateUsername(String value) {
    if (_username == value) return;
    _username = value;
    _error = null;
    notifyListeners();
  }

  /// Updates the password input.
  void updatePassword(String value) {
    if (_password == value) return;
    _password = value;
    _error = null;
    notifyListeners();
  }

  /// Appends an empty custom HTTP header row.
  void addCustomHeader() {
    _customHeaders.add(CustomHeaderEntry());
    notifyListeners();
  }

  /// Updates the header name or value at [index].
  void updateCustomHeader(int index, {String? name, String? value}) {
    if (index < 0 || index >= _customHeaders.length) return;
    if (name != null) _customHeaders[index].name = name;
    if (value != null) _customHeaders[index].value = value;
    _probeResult = null;
    _error = null;
    notifyListeners();
  }

  /// Removes the custom header row at [index].
  void removeCustomHeader(int index) {
    if (index < 0 || index >= _customHeaders.length) return;
    _customHeaders.removeAt(index);
    _probeResult = null;
    _error = null;
    notifyListeners();
  }

  /// Validates whether [rawUrl] is a well-formed HTTP/HTTPS URL.
  bool isValidUrl(String rawUrl) {
    try {
      AbsUrlBuilder.normalizeBaseUrl(rawUrl);
      return true;
    } on FormatException {
      return false;
    }
  }

  /// Probes the configured server URL using `/ping` and `/status`.
  Future<bool> testConnection() async {
    if (_isProbing || _isSigningIn) return false;
    _isProbing = true;
    _error = null;
    _probeResult = null;
    notifyListeners();

    try {
      final result = await _authRepository.probeServer(
        serverUrl: _serverUrl,
        customHeaders: _buildHeaderMap(),
      );
      _probeResult = result;
      _serverUrl = result.normalizedBaseUrl;
      return true;
    } on AbsApiException catch (err) {
      _error = err;
      return false;
    } finally {
      _isProbing = false;
      notifyListeners();
    }
  }

  /// Signs in to the configured server and updates [AuthController].
  Future<bool> signIn() async {
    if (_isSigningIn || _isProbing) return false;
    _isSigningIn = true;
    _error = null;
    notifyListeners();

    try {
      final session = await _authRepository.login(
        serverUrl: _serverUrl,
        username: _username.trim(),
        password: _password,
        customHeaders: _buildHeaderMap(),
      );
      _authController.setAuthenticated(session);
      return true;
    } on AbsApiException catch (err) {
      _error = err;
      return false;
    } on FormatException catch (err) {
      _error = AbsApiException(
        kind: AbsApiErrorKind.invalidUrl,
        message: err.message,
      );
      return false;
    } finally {
      _isSigningIn = false;
      notifyListeners();
    }
  }

  Map<String, String> _buildHeaderMap() {
    final map = <String, String>{};
    for (final entry in _customHeaders) {
      final name = entry.name.trim();
      final value = entry.value.trim();
      if (name.isEmpty || value.isEmpty) continue;
      map[name] = value;
    }
    return map;
  }
}
