import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/app/app_dependencies.dart';
import 'package:shelf_plus/app/router.dart';
import 'package:shelf_plus/core/socket/abs_socket_events.dart';
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

class _ShelfPlusAppState extends State<ShelfPlusApp>
    with WidgetsBindingObserver {
  late final GoRouter _router = createAppRouter(
    dependencies: widget.dependencies,
  );
  StreamSubscription<AbsSocketEvent>? _socketSub;
  bool _isForeground = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.dependencies.authController.addListener(_syncSocketLifecycle);
    _socketSub = widget.dependencies.socketService.events.listen((event) {
      final serverId = widget.dependencies.authController.session?.serverId;
      if (serverId == null) return;
      unawaited(
        widget.dependencies.libraryRepository.handleSocketEvent(
          serverId,
          event,
        ),
      );
    });
    _syncSocketLifecycle();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isForeground = state == AppLifecycleState.resumed;
    _syncSocketLifecycle();
  }

  void _syncSocketLifecycle() {
    final session = widget.dependencies.authController.session;
    final socket = widget.dependencies.socketService;
    if (!_isForeground || session == null) {
      unawaited(socket.disconnect());
      return;
    }
    unawaited(_connectSocket(session.baseUrl, session.customHeaders));
  }

  Future<void> _connectSocket(
    String baseUrl,
    Map<String, String> customHeaders,
  ) async {
    final tokens = await widget.dependencies.credentialsStore
        .loadActiveTokens();
    if (!_isForeground ||
        widget.dependencies.authController.session == null ||
        tokens == null) {
      return;
    }
    await widget.dependencies.socketService.connect(
      baseUrl: baseUrl,
      accessToken: tokens.accessToken,
      customHeaders: customHeaders,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.dependencies.authController.removeListener(_syncSocketLifecycle);
    unawaited(_socketSub?.cancel());
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
