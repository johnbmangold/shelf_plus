import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/theme/shelf_theme_tokens.dart';

/// Editorial Material 3 theme definitions for Light, Dark, and AMOLED modes.
abstract final class AppTheme {
  static const Color _editorialSeed = Color(0xFF8C4A27);

  /// Light editorial theme using warm paper neutrals.
  static ThemeData light({bool useGoogleFonts = true}) {
    final scheme = ColorScheme.fromSeed(seedColor: _editorialSeed).copyWith(
      surface: const Color(0xFFFAF8F5),
      surfaceContainerLowest: const Color(0xFFFFFFFF),
      surfaceContainerLow: const Color(0xFFF5F1EB),
      surfaceContainer: const Color(0xFFEEE8DF),
      surfaceContainerHigh: const Color(0xFFE6DFD4),
    );

    const tokens = ShelfThemeTokens(
      hairlineBorder: Color(0xFFDCD4C8),
      elevatedCardSurface: Color(0xFFFFFFFF),
      subtleMetaText: Color(0xFF665E55),
      miniPlayerSurface: Color(0xFFF3ECE2),
      progressTrack: Color(0xFFE0D7CA),
      progressFill: Color(0xFF8C4A27),
    );

    return _buildTheme(
      scheme: scheme,
      tokens: tokens,
      scaffoldBackground: const Color(0xFFFAF8F5),
      useGoogleFonts: useGoogleFonts,
    );
  }

  /// Dark editorial theme using rich charcoal surfaces.
  static ThemeData dark({bool useGoogleFonts = true}) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: _editorialSeed,
          brightness: Brightness.dark,
        ).copyWith(
          surface: const Color(0xFF141416),
          surfaceContainerLowest: const Color(0xFF101012),
          surfaceContainerLow: const Color(0xFF1A1A1D),
          surfaceContainer: const Color(0xFF1E1E22),
          surfaceContainerHigh: const Color(0xFF27272C),
        );

    const tokens = ShelfThemeTokens(
      hairlineBorder: Color(0xFF2F2F36),
      elevatedCardSurface: Color(0xFF1E1E22),
      subtleMetaText: Color(0xFFA9A39B),
      miniPlayerSurface: Color(0xFF222126),
      progressTrack: Color(0xFF333238),
      progressFill: Color(0xFFE3A07C),
    );

    return _buildTheme(
      scheme: scheme,
      tokens: tokens,
      scaffoldBackground: const Color(0xFF141416),
      useGoogleFonts: useGoogleFonts,
    );
  }

  /// True-black AMOLED editorial theme with crisp hairline card borders.
  static ThemeData amoled({bool useGoogleFonts = true}) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: _editorialSeed,
          brightness: Brightness.dark,
        ).copyWith(
          surface: Colors.black,
          surfaceContainerLowest: Colors.black,
          surfaceContainerLow: const Color(0xFF0A0A0B),
          surfaceContainer: const Color(0xFF111113),
          surfaceContainerHigh: const Color(0xFF18181B),
        );

    const tokens = ShelfThemeTokens(
      hairlineBorder: Color(0xFF27272B),
      elevatedCardSurface: Color(0xFF111113),
      subtleMetaText: Color(0xFFA39E96),
      miniPlayerSurface: Color(0xFF121214),
      progressTrack: Color(0xFF27272C),
      progressFill: Color(0xFFE3A07C),
    );

    return _buildTheme(
      scheme: scheme,
      tokens: tokens,
      scaffoldBackground: Colors.black,
      useGoogleFonts: useGoogleFonts,
    );
  }

  /// Returns [base] updated with tabular figure font features for timers and
  /// chapter durations.
  static TextStyle tabularFigureStyle(TextStyle base) {
    return base.copyWith(
      fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
    );
  }

  static ThemeData _buildTheme({
    required ColorScheme scheme,
    required ShelfThemeTokens tokens,
    required Color scaffoldBackground,
    required bool useGoogleFonts,
  }) {
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBackground,
    );

    final textTheme = _buildEditorialTextTheme(
      base: baseTheme.textTheme,
      scheme: scheme,
      useGoogleFonts: useGoogleFonts,
    );

    return baseTheme.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: tokens.elevatedCardSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: tokens.hairlineBorder),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: tokens.hairlineBorder,
        thickness: 1,
        space: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        indicatorColor: scheme.secondaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      extensions: <ThemeExtension<dynamic>>[tokens],
    );
  }

  static TextTheme _buildEditorialTextTheme({
    required TextTheme base,
    required ColorScheme scheme,
    required bool useGoogleFonts,
  }) {
    final sansTheme = useGoogleFonts
        ? GoogleFonts.plusJakartaSansTextTheme(base)
        : base;
    final serifTheme = useGoogleFonts
        ? GoogleFonts.newsreaderTextTheme(base)
        : base;

    return sansTheme
        .copyWith(
          displayLarge: serifTheme.displayLarge,
          displayMedium: serifTheme.displayMedium,
          displaySmall: serifTheme.displaySmall,
          headlineLarge: serifTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: serifTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: serifTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          titleLarge: serifTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        )
        .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface);
  }

  /// Applies a cover-extracted [scheme] on top of [baseTheme], preserving pure
  /// black surfaces when [amoled] is true.
  static ThemeData applyDynamicScheme({
    required ThemeData baseTheme,
    required ColorScheme? scheme,
    required bool amoled,
  }) {
    if (scheme == null) return baseTheme;

    final adjustedScheme = amoled
        ? scheme.copyWith(
            surface: Colors.black,
            surfaceContainerLowest: Colors.black,
            surfaceContainerLow: const Color(0xFF0A0A0B),
            surfaceContainer: const Color(0xFF111113),
          )
        : scheme;

    final baseTokens = baseTheme.extension<ShelfThemeTokens>();
    final updatedTokens = baseTokens?.copyWith(
      progressFill: adjustedScheme.primary,
    );

    return baseTheme.copyWith(
      colorScheme: adjustedScheme,
      scaffoldBackgroundColor: amoled ? Colors.black : adjustedScheme.surface,
      appBarTheme: baseTheme.appBarTheme.copyWith(
        backgroundColor: amoled ? Colors.black : adjustedScheme.surface,
        foregroundColor: adjustedScheme.onSurface,
      ),
      extensions: updatedTokens != null
          ? <ThemeExtension<dynamic>>[updatedTokens]
          : baseTheme.extensions.values,
    );
  }
}
