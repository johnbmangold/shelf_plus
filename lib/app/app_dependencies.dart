import 'package:logging/logging.dart';
import 'package:shelf_plus/app/flavor_config.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/theme/theme_controller.dart';

/// Composition root holding application-wide dependencies injected via
/// constructors.
class AppDependencies {
  /// Creates an [AppDependencies] instance.
  new({
    required this.flavorConfig,
    required this.logger,
    required this.themeController,
    this.useGoogleFonts = true,
  });

  /// Creates the default production/development dependency graph for
  /// [flavorConfig].
  factory create({
    required FlavorConfig flavorConfig,
    bool useGoogleFonts = true,
  }) {
    final logger =
        AppLogger(
          level: flavorConfig.enableVerboseLogging ? Level.FINE : Level.INFO,
        )..info(
          'Initialized ${flavorConfig.appName} '
          '(${flavorConfig.applicationId})',
          scope: 'bootstrap',
        );
    return AppDependencies(
      flavorConfig: flavorConfig,
      logger: logger,
      themeController: ThemeController(),
      useGoogleFonts: useGoogleFonts,
    );
  }

  /// Active build flavor configuration.
  final FlavorConfig flavorConfig;

  /// Structured application logger.
  final AppLogger logger;

  /// Active theme mode controller.
  final ThemeController themeController;

  /// Whether Google Fonts network/bundled loading should be used in themes.
  ///
  /// Set to `false` in offline widget/golden tests.
  final bool useGoogleFonts;

  /// Releases resources owned by this composition root.
  void dispose() {
    themeController.dispose();
  }
}
