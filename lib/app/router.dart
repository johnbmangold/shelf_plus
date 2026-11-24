import 'package:go_router/go_router.dart';
import 'package:shelf_plus/app/app_dependencies.dart';
import 'package:shelf_plus/core/widgets/app_shell_scaffold.dart';
import 'package:shelf_plus/features/auth/presentation/auth_controller.dart';
import 'package:shelf_plus/features/auth/presentation/login_screen.dart';
import 'package:shelf_plus/features/book_detail/presentation/book_detail_screen.dart';
import 'package:shelf_plus/features/diagnostics/presentation/diagnostics_screen.dart';
import 'package:shelf_plus/features/downloads/presentation/downloads_screen.dart';
import 'package:shelf_plus/features/home/presentation/home_screen.dart';
import 'package:shelf_plus/features/library/presentation/library_screen.dart';
import 'package:shelf_plus/features/player/presentation/full_player_screen.dart';
import 'package:shelf_plus/features/settings/presentation/settings_screen.dart';

/// Top-level route paths for the Shelf Plus application.
abstract final class AppRoutes {
  /// Server setup and login route path.
  static const String login = '/login';

  /// Diagnostics route accessible from the login screen while signed out.
  static const String diagnostics = '/diagnostics';

  /// Home tab route path.
  static const String home = '/home';

  /// Library tab route path.
  static const String library = '/library';

  /// Downloads tab route path.
  static const String downloads = '/downloads';

  /// Settings tab route path.
  static const String settings = '/settings';

  /// Diagnostics route nested inside Settings when signed in.
  static const String settingsDiagnostics = '/settings/diagnostics';

  /// Book detail route pattern.
  static const String bookDetail = '/book/:itemId';

  /// Full-screen audio player route path.
  static const String player = '/player';

  /// Builds a concrete route path for opening [itemId] in [BookDetailScreen].
  static String bookDetailPath(String itemId) =>
      '/book/${Uri.encodeComponent(itemId)}';
}

/// Builds the application's [GoRouter] with auth redirects and a 4-branch
/// [StatefulShellRoute].
GoRouter createAppRouter({required AppDependencies dependencies}) {
  final authController = dependencies.authController;

  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: authController,
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isPublicRoute =
          location == AppRoutes.login || location == AppRoutes.diagnostics;

      switch (authController.status) {
        case AuthStatus.initializing:
          return null;
        case AuthStatus.unauthenticated:
          return isPublicRoute ? null : AppRoutes.login;
        case AuthStatus.authenticated:
          if (location == AppRoutes.login) {
            return AppRoutes.home;
          }
          return null;
      }
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => LoginScreen(
          authRepository: dependencies.authRepository,
          authController: authController,
          diagnosticsRoute: AppRoutes.diagnostics,
        ),
      ),
      GoRoute(
        path: AppRoutes.diagnostics,
        builder: (context, state) => DiagnosticsScreen(
          logger: dependencies.logger,
          logExporter: dependencies.logExporter,
        ),
      ),
      GoRoute(
        path: AppRoutes.bookDetail,
        builder: (context, state) {
          final rawId = state.pathParameters['itemId'] ?? '';
          final itemId = Uri.decodeComponent(rawId);
          return BookDetailScreen(
            itemId: itemId,
            libraryRepository: dependencies.libraryRepository,
            authController: authController,
            coverThemeExtractor: dependencies.coverThemeExtractor,
            themeController: dependencies.themeController,
            loadImageHeaders:
                dependencies.credentialsStore.loadActiveRequestHeaders,
            logger: dependencies.logger,
            playerController: dependencies.playerController,
            downloadController: dependencies.downloadController,
            onOpenPlayer: () => context.push(AppRoutes.player),
            enableNetworkImages: dependencies.enableNetworkImages,
            autoFetchDetail: dependencies.autoSyncOnStart,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.player,
        builder: (context, state) => FullPlayerScreen(
          playerController: dependencies.playerController,
          themeController: dependencies.themeController,
          enableNetworkImages: dependencies.enableNetworkImages,
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShellScaffold(
            navigationShell: navigationShell,
            playerController: dependencies.playerController,
            onOpenPlayer: () => context.push(AppRoutes.player),
            enableNetworkImages: dependencies.enableNetworkImages,
          );
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => HomeScreen(
                  libraryRepository: dependencies.libraryRepository,
                  authController: authController,
                  loadImageHeaders:
                      dependencies.credentialsStore.loadActiveRequestHeaders,
                  logger: dependencies.logger,
                  bookDetailRouteBuilder: AppRoutes.bookDetailPath,
                  enableNetworkImages: dependencies.enableNetworkImages,
                  autoSync: dependencies.autoSyncOnStart,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.library,
                builder: (context, state) => LibraryScreen(
                  libraryRepository: dependencies.libraryRepository,
                  authController: authController,
                  loadImageHeaders:
                      dependencies.credentialsStore.loadActiveRequestHeaders,
                  bookDetailRouteBuilder: AppRoutes.bookDetailPath,
                  enableNetworkImages: dependencies.enableNetworkImages,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.downloads,
                builder: (context, state) => DownloadsScreen(
                  downloadController: dependencies.downloadController,
                  syncController: dependencies.offlineSyncController,
                  playerController: dependencies.playerController,
                  libraryRepository: dependencies.libraryRepository,
                  authController: authController,
                  loadImageHeaders:
                      dependencies.credentialsStore.loadActiveRequestHeaders,
                  onOpenPlayer: () => context.push(AppRoutes.player),
                  enableNetworkImages: dependencies.enableNetworkImages,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => SettingsScreen(
                  themeController: dependencies.themeController,
                  flavorConfig: dependencies.flavorConfig,
                  authController: authController,
                  diagnosticsRoute: AppRoutes.settingsDiagnostics,
                ),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'diagnostics',
                    builder: (context, state) => DiagnosticsScreen(
                      logger: dependencies.logger,
                      logExporter: dependencies.logExporter,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
