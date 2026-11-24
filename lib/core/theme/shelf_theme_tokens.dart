import 'package:material_ui/material_ui.dart';

/// Custom editorial design tokens exposed via [ThemeExtension].
@immutable
class ShelfThemeTokens extends ThemeExtension<ShelfThemeTokens> {
  /// Creates a [ShelfThemeTokens] bundle.
  const new({
    required this.hairlineBorder,
    required this.elevatedCardSurface,
    required this.subtleMetaText,
    required this.miniPlayerSurface,
    required this.progressTrack,
    required this.progressFill,
  });

  /// Subtle 0.5–1px border color used on cards and dividers.
  final Color hairlineBorder;

  /// Background surface for elevated editorial cards.
  final Color elevatedCardSurface;

  /// Muted color for author, narrator, and duration metadata.
  final Color subtleMetaText;

  /// Surface color for the persistent floating mini-player bar.
  final Color miniPlayerSurface;

  /// Track color for linear playback progress indicators.
  final Color progressTrack;

  /// Active fill color for linear playback progress indicators.
  final Color progressFill;

  @override
  ShelfThemeTokens copyWith({
    Color? hairlineBorder,
    Color? elevatedCardSurface,
    Color? subtleMetaText,
    Color? miniPlayerSurface,
    Color? progressTrack,
    Color? progressFill,
  }) {
    return ShelfThemeTokens(
      hairlineBorder: hairlineBorder ?? this.hairlineBorder,
      elevatedCardSurface: elevatedCardSurface ?? this.elevatedCardSurface,
      subtleMetaText: subtleMetaText ?? this.subtleMetaText,
      miniPlayerSurface: miniPlayerSurface ?? this.miniPlayerSurface,
      progressTrack: progressTrack ?? this.progressTrack,
      progressFill: progressFill ?? this.progressFill,
    );
  }

  @override
  ShelfThemeTokens lerp(ThemeExtension<ShelfThemeTokens>? other, double t) {
    if (other is! ShelfThemeTokens) return this;
    return ShelfThemeTokens(
      hairlineBorder: Color.lerp(hairlineBorder, other.hairlineBorder, t)!,
      elevatedCardSurface: Color.lerp(
        elevatedCardSurface,
        other.elevatedCardSurface,
        t,
      )!,
      subtleMetaText: Color.lerp(subtleMetaText, other.subtleMetaText, t)!,
      miniPlayerSurface: Color.lerp(
        miniPlayerSurface,
        other.miniPlayerSurface,
        t,
      )!,
      progressTrack: Color.lerp(progressTrack, other.progressTrack, t)!,
      progressFill: Color.lerp(progressFill, other.progressFill, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShelfThemeTokens &&
        other.hairlineBorder == hairlineBorder &&
        other.elevatedCardSurface == elevatedCardSurface &&
        other.subtleMetaText == subtleMetaText &&
        other.miniPlayerSurface == miniPlayerSurface &&
        other.progressTrack == progressTrack &&
        other.progressFill == progressFill;
  }

  @override
  int get hashCode => Object.hash(
    hairlineBorder,
    elevatedCardSurface,
    subtleMetaText,
    miniPlayerSurface,
    progressTrack,
    progressFill,
  );
}

/// Convenience helper for accessing [ShelfThemeTokens] from [BuildContext].
extension ShelfThemeTokensExtension on BuildContext {
  /// Returns the active [ShelfThemeTokens] from the nearest [Theme].
  ShelfThemeTokens get shelfTokens =>
      Theme.of(this).extension<ShelfThemeTokens>()!;
}
