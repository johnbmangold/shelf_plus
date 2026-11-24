import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/app/app.dart';
import 'package:shelf_plus/app/app_dependencies.dart';
import 'package:shelf_plus/app/flavor_config.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/theme/app_theme.dart';
import 'package:shelf_plus/core/theme/theme_controller.dart';
import 'package:shelf_plus/l10n/generated/app_localizations.dart';

/// Builds test-safe [AppDependencies] with Google Fonts network loading
/// disabled and developer-log forwarding disabled.
AppDependencies createTestDependencies({
  FlavorConfig flavorConfig = const FlavorConfig.dev(),
  ThemeController? themeController,
}) {
  return AppDependencies(
    flavorConfig: flavorConfig,
    logger: AppLogger(forwardToDeveloperLog: false),
    themeController: themeController ?? ThemeController(),
    useGoogleFonts: false,
  );
}

/// Convenience extension on [WidgetTester] for pumping Shelf Plus widgets and
/// the full app with localization and offline themes wired up.
extension PumpShelfApp on WidgetTester {
  /// Pumps a full [ShelfPlusApp] using [dependencies] (or default test
  /// dependencies).
  Future<AppDependencies> pumpShelfApp({AppDependencies? dependencies}) async {
    final resolved = dependencies ?? createTestDependencies();
    addTearDown(resolved.dispose);
    await pumpWidget(ShelfPlusApp(dependencies: resolved));
    await pumpAndSettle();
    return resolved;
  }

  /// Pumps an isolated [child] wrapped in [MaterialApp] and [AppLocalizations].
  Future<void> pumpLocalizedWidget(Widget child, {ThemeData? theme}) async {
    await pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme ?? AppTheme.light(useGoogleFonts: false),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    );
    await pumpAndSettle();
  }
}
