import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';

/// Extracts and caches dynamic [ColorScheme] palettes from book cover art.
abstract interface class CoverThemeExtractor {
  /// Returns a [ColorScheme] derived from the cover at [coverUrl] for
  /// [brightness], or `null` if unavailable.
  Future<ColorScheme?> extractScheme({
    required String coverUrl,
    required Brightness brightness,
    Map<String, String> headers = const <String, String>{},
  });
}

/// Production [CoverThemeExtractor] backed by [ColorScheme.fromImageProvider]
/// and a bounded in-memory LRU cache.
class FlutterCoverThemeExtractor implements CoverThemeExtractor {
  /// Creates a [FlutterCoverThemeExtractor] retaining at most [maxEntries].
  new({this.maxEntries = 32});

  /// Maximum cached `(url, brightness)` schemes.
  final int maxEntries;

  final LinkedHashMap<String, ColorScheme> _cache =
      LinkedHashMap<String, ColorScheme>();

  @override
  Future<ColorScheme?> extractScheme({
    required String coverUrl,
    required Brightness brightness,
    Map<String, String> headers = const <String, String>{},
  }) async {
    if (coverUrl.isEmpty) return null;
    final key = '${brightness.name}::$coverUrl';
    final existing = _cache.remove(key);
    if (existing != null) {
      _cache[key] = existing;
      return existing;
    }

    try {
      final provider = CachedNetworkImageProvider(
        coverUrl,
        headers: headers.isEmpty ? null : headers,
      );
      final scheme = await ColorScheme.fromImageProvider(
        provider: provider,
        brightness: brightness,
      );
      if (_cache.length >= maxEntries) {
        _cache.remove(_cache.keys.first);
      }
      _cache[key] = scheme;
      return scheme;
    } on Exception {
      return null;
    }
  }
}
