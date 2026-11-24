import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/theme/app_theme.dart';
import 'package:shelf_plus/core/theme/shelf_theme_tokens.dart';

void main() {
  group('AppTheme', () {
    test('light, dark, and amoled themes attach ShelfThemeTokens', () {
      final light = AppTheme.light(useGoogleFonts: false);
      final dark = AppTheme.dark(useGoogleFonts: false);
      final amoled = AppTheme.amoled(useGoogleFonts: false);

      check(light.brightness).equals(Brightness.light);
      check(dark.brightness).equals(Brightness.dark);
      check(amoled.brightness).equals(Brightness.dark);
      check(amoled.scaffoldBackgroundColor).equals(Colors.black);
      check(light.extension<ShelfThemeTokens>()).isNotNull();
      check(dark.extension<ShelfThemeTokens>()).isNotNull();
      check(amoled.extension<ShelfThemeTokens>()).isNotNull();
    });

    test('tabularFigureStyle enables tabular figures font feature', () {
      const base = TextStyle(fontSize: 14);
      final styled = AppTheme.tabularFigureStyle(base);
      check(styled.fontFeatures)
          .isNotNull()
          .deepEquals(<FontFeature>[const FontFeature.tabularFigures()]);
    });
  });
}
