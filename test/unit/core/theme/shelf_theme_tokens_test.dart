import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/theme/shelf_theme_tokens.dart';

void main() {
  const lightTokens = ShelfThemeTokens(
    hairlineBorder: Color(0xFF000000),
    elevatedCardSurface: Color(0xFFFFFFFF),
    subtleMetaText: Color(0xFF404040),
    miniPlayerSurface: Color(0xFFE0E0E0),
    progressTrack: Color(0xFFCCCCCC),
    progressFill: Color(0xFF8C4A27),
  );

  const darkTokens = ShelfThemeTokens(
    hairlineBorder: Color(0xFFFFFFFF),
    elevatedCardSurface: Color(0xFF000000),
    subtleMetaText: Color(0xFFA0A0A0),
    miniPlayerSurface: Color(0xFF202020),
    progressTrack: Color(0xFF303030),
    progressFill: Color(0xFFE3A07C),
  );

  group('ShelfThemeTokens', () {
    test('copyWith overrides specified fields and keeps others', () {
      final updated = lightTokens.copyWith(
        hairlineBorder: const Color(0xFF123456),
        progressFill: const Color(0xFF654321),
      );

      check(updated.hairlineBorder).equals(const Color(0xFF123456));
      check(updated.progressFill).equals(const Color(0xFF654321));
      check(updated.elevatedCardSurface)
          .equals(lightTokens.elevatedCardSurface);
      check(updated.subtleMetaText).equals(lightTokens.subtleMetaText);
      check(updated.miniPlayerSurface).equals(lightTokens.miniPlayerSurface);
      check(updated.progressTrack).equals(lightTokens.progressTrack);
    });

    test('lerp returns this when other is null', () {
      check(lightTokens.lerp(null, 0.5)).equals(lightTokens);
    });

    test('lerp interpolates between light and dark tokens', () {
      final start = lightTokens.lerp(darkTokens, 0);
      final mid = lightTokens.lerp(darkTokens, 0.5);
      final end = lightTokens.lerp(darkTokens, 1);

      check(start).equals(lightTokens);
      check(end).equals(darkTokens);
      check(mid.hairlineBorder).equals(
        Color.lerp(lightTokens.hairlineBorder, darkTokens.hairlineBorder, 0.5)!,
      );
      check(mid.elevatedCardSurface).equals(
        Color.lerp(
          lightTokens.elevatedCardSurface,
          darkTokens.elevatedCardSurface,
          0.5,
        )!,
      );
    });
  });
}
