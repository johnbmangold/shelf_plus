/// Placeholder inserted whenever a sensitive value is redacted.
const String redactedPlaceholder = '[REDACTED]';

/// Redacts sensitive credentials, tokens, and secrets from log output.
abstract final class LogRedactor {
  static final RegExp _bearerPattern = RegExp(
    r'(Bearer\s+)([^\s,;"]+)',
    caseSensitive: false,
  );

  static final RegExp _jsonSecretPattern = RegExp(
    '("(?:authorization|x-refresh-token|cf-access-client-secret|password|'
    r'token|access_?token|refresh_?token|api_?key)"\s*:\s*")([^"]*)(")',
    caseSensitive: false,
  );

  static final RegExp _keyValueSecretPattern = RegExp(
    r'(\b(?:authorization|x-refresh-token|cf-access-client-secret|password|'
    r'token|access_?token|refresh_?token|api_?key)\s*[:=]\s*)'
    r'(?!\[REDACTED\]|bearer\s+\[REDACTED\])([^\s,;&\r\n]+)',
    caseSensitive: false,
  );

  static final Set<String> _sensitiveKeys = <String>{
    'authorization',
    'x-refresh-token',
    'cf-access-client-secret',
    'password',
    'token',
    'accesstoken',
    'access_token',
    'refreshtoken',
    'refresh_token',
    'apikey',
    'api_key',
  };

  /// Returns [input] with bearer tokens and known secret fields replaced by
  /// [redactedPlaceholder].
  static String redact(String input) {
    if (input.isEmpty) return input;
    var output = input.replaceAllMapped(
      _bearerPattern,
      (match) => '${match.group(1)}$redactedPlaceholder',
    );
    output = output.replaceAllMapped(
      _jsonSecretPattern,
      (match) => '${match.group(1)}$redactedPlaceholder${match.group(3)}',
    );
    output = output.replaceAllMapped(
      _keyValueSecretPattern,
      (match) => '${match.group(1)}$redactedPlaceholder',
    );
    return output;
  }

  /// Returns a shallow-copied map with sensitive values redacted recursively.
  static Map<String, Object?> redactMap(Map<String, Object?> map) {
    final result = <String, Object?>{};
    for (final entry in map.entries) {
      final normalizedKey = entry.key.toLowerCase();
      final value = entry.value;
      if (_sensitiveKeys.contains(normalizedKey)) {
        result[entry.key] = redactedPlaceholder;
      } else if (value is Map<String, Object?>) {
        result[entry.key] = redactMap(value);
      } else if (value is String) {
        result[entry.key] = redact(value);
      } else {
        result[entry.key] = value;
      }
    }
    return result;
  }
}
