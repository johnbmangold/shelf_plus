import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/features/player/presentation/mini_player_bar.dart';
import 'package:shelf_plus/features/player/presentation/player_controller.dart';
import 'package:shelf_plus/l10n/generated/app_localizations.dart';

/// Root 4-tab application shell containing the persistent mini-player bar and
/// Material 3 [NavigationBar].
class AppShellScaffold extends StatelessWidget {
  /// Creates an [AppShellScaffold].
  const new({
    required this.navigationShell,
    required this.playerController,
    required this.onOpenPlayer,
    this.enableNetworkImages = true,
    super.key,
  });

  /// Stateful navigation shell managed by `go_router`.
  final StatefulNavigationShell navigationShell;

  /// Shared application player controller driving the persistent mini-player.
  final PlayerController playerController;

  /// Callback opening the full-screen player route.
  final VoidCallback onOpenPlayer;

  /// Whether network cover fetching is enabled.
  final bool enableNetworkImages;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(child: navigationShell),
          MiniPlayerBar(
            playerController: playerController,
            onOpenPlayer: onOpenPlayer,
            enableNetworkImages: enableNetworkImages,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: <NavigationDestination>[
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.library_books_outlined),
            selectedIcon: const Icon(Icons.library_books),
            label: l10n.navLibrary,
          ),
          NavigationDestination(
            icon: const Icon(Icons.download_outlined),
            selectedIcon: const Icon(Icons.download),
            label: l10n.navDownloads,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}
