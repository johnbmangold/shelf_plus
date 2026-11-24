import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/theme/dynamic_cover_theme_service.dart';

/// Deterministic [CoverThemeExtractor] fake returning a fixed [ColorScheme]
/// without performing network image decoding.
class FakeCoverThemeExtractor implements CoverThemeExtractor {
  /// Creates a [FakeCoverThemeExtractor].
  new({this.seedColor});

  /// Optional seed color used to build a dynamic [ColorScheme].
  Color? seedColor;

  /// Count of [extractScheme] calls.
  int calls = 0;

  @override
  Future<ColorScheme?> extractScheme({
    required String coverUrl,
    required Brightness brightness,
    Map<String, String> headers = const <String, String>{},
  }) async {
    calls++;
    if (seedColor == null) return null;
    return ColorScheme.fromSeed(seedColor: seedColor!, brightness: brightness);
  }
}
