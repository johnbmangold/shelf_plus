import 'package:material_ui/material_ui.dart';

/// Immutable pair of Audiobookshelf authentication tokens.
@immutable
class AuthTokens {
  /// Creates an [AuthTokens] instance.
  const new({required this.accessToken, this.refreshToken});

  /// Short-lived JWT access token (or legacy API token on older servers).
  final String accessToken;

  /// Long-lived refresh token returned by Audiobookshelf v2.26+.
  final String? refreshToken;

  /// Whether a non-empty [refreshToken] is available for silent renewal.
  bool get hasRefreshToken => refreshToken != null && refreshToken!.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthTokens &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken;
  }

  @override
  int get hashCode => Object.hash(accessToken, refreshToken);
}
