import 'package:go_router/go_router.dart';
import 'package:shelf_plus/app/app_dependencies.dart';
import 'package:shelf_plus/core/widgets/app_shell_scaffold.dart';
import 'package:shelf_plus/features/downloads/presentation/downloads_screen.dart';
import 'package:shelf_plus/features/home/presentation/home_screen.dart';
import 'package:shelf_plus/features/library/presentation/library_screen.dart';
import 'package:shelf_plus/features/settings/presentation/settings_screen.dart';

/// Top-level route paths for the 4-tab application shell.
abstract final class AppRoutes {
  /// Home tab route path.
  static const String home = '/home';

  /// Library tab route path.
  static const String library = '/library';

  /// Downloads tab route path.
  static const String downloads = '/downloads';

  /// Settings tab route path.
  static const String settings = '/settings';
}

/// Builds the application's [GoRouter] configured with a 4-branch
/// [StatefulShellRoute].
GoRouter createAppRouter({required AppDependencies dependencies}) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShellScaffold(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.library,
                builder: (context, state) => const LibraryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.downloads,
                builder: (context, state) => const DownloadsScreen(),
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
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
