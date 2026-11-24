/// Utilities for normalizing Audiobookshelf server URLs while preserving
/// optional reverse-proxy subpath prefixes.
abstract final class AbsUrlBuilder {
  /// Validates and normalizes [rawUrl] into a canonical base URL without
  /// trailing slashes, query parameters, or fragments.
  ///
  /// Throws a [FormatException] if [rawUrl] is empty, does not use `http` or
  /// `https`, or lacks a host.
  static String normalizeBaseUrl(String rawUrl) {
    final trimmed = rawUrl.trim();
    if (trimmed.isEmpty) {
      throw const FormatException('Server URL cannot be empty.');
    }

    final uri = Uri.tryParse(trimmed);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      throw const FormatException('Invalid server URL.');
    }

    final scheme = uri.scheme.toLowerCase();
    if (scheme != 'http' && scheme != 'https') {
      throw const FormatException('Server URL must use http or https.');
    }

    var path = uri.path;
    while (path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }

    return Uri(
      scheme: scheme,
      host: uri.host,
      port: uri.hasPort ? uri.port : null,
      path: path,
    ).toString();
  }

  /// Resolves an [endpointPath] (for example `/login` or `api/authorize`)
  /// against a normalized [baseUrl], preserving any base subpath prefix.
  static String resolve(String baseUrl, String endpointPath) {
    final normalizedBase = normalizeBaseUrl(baseUrl);
    final baseUri = Uri.parse(normalizedBase);
    final cleanEndpoint = endpointPath.startsWith('/')
        ? endpointPath.substring(1)
        : endpointPath;

    final baseSegments = baseUri.pathSegments.where((s) => s.isNotEmpty);
    final endpointSegments = cleanEndpoint
        .split('/')
        .where((s) => s.isNotEmpty);

    return baseUri
        .replace(pathSegments: <String>[...baseSegments, ...endpointSegments])
        .toString();
  }

  /// Extracts a user-friendly display name (host and optional port) from
  /// [baseUrl].
  static String displayHost(String baseUrl) {
    final uri = Uri.parse(normalizeBaseUrl(baseUrl));
    if (uri.hasPort) {
      return '${uri.host}:${uri.port}';
    }
    return uri.host;
  }
}
