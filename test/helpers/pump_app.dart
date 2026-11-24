import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/app/app.dart';
import 'package:shelf_plus/app/app_dependencies.dart';
import 'package:shelf_plus/app/flavor_config.dart';
import 'package:shelf_plus/core/database/app_database.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/network/abs_api_client.dart';
import 'package:shelf_plus/core/theme/app_theme.dart';
import 'package:shelf_plus/core/theme/theme_controller.dart';
import 'package:shelf_plus/features/auth/data/auth_repository_impl.dart';
import 'package:shelf_plus/features/auth/domain/auth_repository.dart';
import 'package:shelf_plus/features/auth/domain/server_session.dart';
import 'package:shelf_plus/features/auth/presentation/auth_controller.dart';
import 'package:shelf_plus/features/diagnostics/domain/log_exporter.dart';
import 'package:shelf_plus/l10n/generated/app_localizations.dart';

import '../fakes/fake_log_exporter.dart';
import '../fakes/in_memory_secure_storage_service.dart';

/// Default authenticated session used in widget tests that start inside the
/// main 4-tab shell.
const ServerSession testAuthenticatedSession = ServerSession(
  serverId: 'test-server-1',
  baseUrl: 'https://books.example.com',
  displayName: 'books.example.com',
  userId: 'user-1',
  username: 'reader',
  supportsRefreshTokens: true,
  serverVersion: '2.26.0',
);

/// Builds test-safe [AppDependencies] backed by an in-memory Drift database
/// and in-memory secure storage, with Google Fonts network loading disabled.
///
/// Pass [authenticated] as `false` to start in [AuthStatus.unauthenticated]
/// (redirecting to `/login`).
AppDependencies createTestDependencies({
  FlavorConfig flavorConfig = const FlavorConfig.dev(),
  ThemeController? themeController,
  AppLogger? logger,
  AppDatabase? database,
  InMemorySecureStorageService? secureStorage,
  AuthRepository? authRepository,
  LogExporter? logExporter,
  bool authenticated = true,
  ServerSession? initialSession,
}) {
  final resolvedLogger =
      logger ?? AppLogger(level: Level.FINE, forwardToDeveloperLog: false);
  final resolvedDb = database ?? AppDatabase.inMemory();
  final resolvedStorage = secureStorage ?? InMemorySecureStorageService();
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
    logger: resolvedLogger,
  );

  final resolvedAuthRepo =
      authRepository ??
      AuthRepositoryImpl(
        apiClient: apiClient,
        database: resolvedDb,
        credentialsStore: credentialsStore,
        logger: resolvedLogger,
      );

  final effectiveSession = authenticated
      ? (initialSession ?? testAuthenticatedSession)
      : null;

  authController = AuthController(
    authRepository: resolvedAuthRepo,
    initialStatus: effectiveSession != null
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated,
    initialSession: effectiveSession,
  );

  return AppDependencies(
    flavorConfig: flavorConfig,
    logger: resolvedLogger,
    themeController: themeController ?? ThemeController(),
    database: resolvedDb,
    secureStorage: resolvedStorage,
    apiClient: apiClient,
    authRepository: resolvedAuthRepo,
    authController: authController,
    logExporter: logExporter ?? FakeLogExporter(),
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
    addTearDown(() async {
      resolved.dispose();
      await Future<void>.delayed(Duration.zero);
    });
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
