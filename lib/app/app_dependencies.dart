import 'dart:async';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:shelf_plus/app/flavor_config.dart';
import 'package:shelf_plus/core/database/app_database.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/network/abs_api_client.dart';
import 'package:shelf_plus/core/storage/secure_storage_service.dart';
import 'package:shelf_plus/core/theme/theme_controller.dart';
import 'package:shelf_plus/features/auth/data/auth_repository_impl.dart';
import 'package:shelf_plus/features/auth/domain/auth_repository.dart';
import 'package:shelf_plus/features/auth/presentation/auth_controller.dart';
import 'package:shelf_plus/features/diagnostics/data/share_plus_log_exporter.dart';
import 'package:shelf_plus/features/diagnostics/domain/log_exporter.dart';

/// Composition root holding application-wide dependencies injected via
/// constructors.
class AppDependencies {
  /// Creates an [AppDependencies] instance.
  new({
    required this.flavorConfig,
    required this.logger,
    required this.themeController,
    required this.database,
    required this.secureStorage,
    required this.apiClient,
    required this.authRepository,
    required this.authController,
    required this.logExporter,
    this.useGoogleFonts = true,
  });

  /// Creates the default production/development dependency graph for
  /// [flavorConfig].
  factory create({
    required FlavorConfig flavorConfig,
    AppDatabase? database,
    SecureStorageService? secureStorage,
    LogExporter? logExporter,
    HttpClientAdapter? httpClientAdapter,
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

    final resolvedDb = database ?? AppDatabase();
    final resolvedStorage =
        secureStorage ?? const FlutterSecureStorageService();
    final credentialsStore = AuthCredentialsStore(
      database: resolvedDb,
      secureStorage: resolvedStorage,
    );

    late final AuthController authController;

    final apiClient = AbsApiClient.create(
      loadBaseUrl: credentialsStore.loadActiveBaseUrl,
      loadTokens: credentialsStore.loadActiveTokens,
      saveTokens: credentialsStore.saveActiveTokens,
      loadCustomHeaders: credentialsStore.loadActiveCustomHeaders,
      onSessionExpired: () => authController.handleSessionExpired(),
      logger: logger,
      adapter: httpClientAdapter,
    );

    final authRepository = AuthRepositoryImpl(
      apiClient: apiClient,
      database: resolvedDb,
      credentialsStore: credentialsStore,
      logger: logger,
    );

    authController = AuthController(authRepository: authRepository);

    return AppDependencies(
      flavorConfig: flavorConfig,
      logger: logger,
      themeController: ThemeController(),
      database: resolvedDb,
      secureStorage: resolvedStorage,
      apiClient: apiClient,
      authRepository: authRepository,
      authController: authController,
      logExporter: logExporter ?? const SharePlusLogExporter(),
      useGoogleFonts: useGoogleFonts,
    );
  }

  /// Active build flavor configuration.
  final FlavorConfig flavorConfig;

  /// Structured application logger.
  final AppLogger logger;

  /// Active theme mode controller.
  final ThemeController themeController;

  /// Local Drift SQLite database.
  final AppDatabase database;

  /// Encrypted platform credential storage.
  final SecureStorageService secureStorage;

  /// Audiobookshelf REST API client.
  final AbsApiClient apiClient;

  /// Authentication and server profile repository.
  final AuthRepository authRepository;

  /// Global authentication controller.
  final AuthController authController;

  /// Diagnostic log exporter.
  final LogExporter logExporter;

  /// Whether Google Fonts network/bundled loading should be used in themes.
  ///
  /// Set to `false` in offline widget/golden tests.
  final bool useGoogleFonts;

  /// Releases resources owned by this composition root.
  void dispose() {
    themeController.dispose();
    authController.dispose();
    unawaited(database.close());
  }
}
