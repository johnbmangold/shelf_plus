import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/app/app_dependencies.dart';
import 'package:shelf_plus/app/router.dart';
import 'package:shelf_plus/core/theme/app_theme.dart';
import 'package:shelf_plus/l10n/generated/app_localizations.dart';

/// Root widget for the Shelf Plus application.
class ShelfPlusApp extends StatefulWidget {
  /// Creates a [ShelfPlusApp].
  const new({required this.dependencies, super.key});

  /// Composition root providing application services and controllers.
  final AppDependencies dependencies;

  @override
  State<ShelfPlusApp> createState() => _ShelfPlusAppState();
}

class _ShelfPlusAppState extends State<ShelfPlusApp> {
  late final GoRouter _router = createAppRouter(
    dependencies: widget.dependencies,
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = widget.dependencies.themeController;
    final useGoogleFonts = widget.dependencies.useGoogleFonts;

    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        final darkTheme = themeController.isAmoled
            ? AppTheme.amoled(useGoogleFonts: useGoogleFonts)
            : AppTheme.dark(useGoogleFonts: useGoogleFonts);

        return MaterialApp.router(
          title: widget.dependencies.flavorConfig.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(useGoogleFonts: useGoogleFonts),
          darkTheme: darkTheme,
          themeMode: themeController.flutterThemeMode,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: _router,
        );
      },
    );
  }
}
