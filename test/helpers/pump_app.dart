import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/app/app.dart';
import 'package:shelf_plus/app/app_dependencies.dart';
import 'package:shelf_plus/app/flavor_config.dart';
import 'package:shelf_plus/core/database/app_database.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/network/abs_api_client.dart';
import 'package:shelf_plus/core/socket/abs_socket_service.dart';
import 'package:shelf_plus/core/theme/app_theme.dart';
import 'package:shelf_plus/core/theme/dynamic_cover_theme_service.dart';
import 'package:shelf_plus/core/theme/theme_controller.dart';
import 'package:shelf_plus/features/auth/data/auth_repository_impl.dart';
import 'package:shelf_plus/features/auth/domain/auth_repository.dart';
import 'package:shelf_plus/features/auth/domain/server_session.dart';
import 'package:shelf_plus/features/auth/presentation/auth_controller.dart';
import 'package:shelf_plus/features/diagnostics/domain/log_exporter.dart';
import 'package:shelf_plus/features/library/domain/library_repository.dart';
import 'package:shelf_plus/features/player/domain/audio_player_engine.dart';
import 'package:shelf_plus/features/player/domain/shake_detector.dart';
import 'package:shelf_plus/features/player/presentation/player_controller.dart';
import 'package:shelf_plus/l10n/generated/app_localizations.dart';

import '../fakes/fake_abs_socket_service.dart';
import '../fakes/fake_audio_player_engine.dart';
import '../fakes/fake_cover_theme_extractor.dart';
import '../fakes/fake_library_repository.dart';
import '../fakes/fake_log_exporter.dart';
import '../fakes/fake_shake_detector.dart';
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
/// and in-memory fakes, with Google Fonts and network images disabled.
AppDependencies createTestDependencies({
  FlavorConfig flavorConfig = const FlavorConfig.dev(),
  ThemeController? themeController,
  AppLogger? logger,
  AppDatabase? database,
  InMemorySecureStorageService? secureStorage,
  AuthRepository? authRepository,
  LibraryRepository? libraryRepository,
  AbsSocketService? socketService,
  CoverThemeExtractor? coverThemeExtractor,
  LogExporter? logExporter,
  AudioPlayerEngine? audioPlayerEngine,
  ShakeDetector? shakeDetector,
  PlayerController? playerController,
  HttpClientAdapter? httpClientAdapter,
  bool authenticated = true,
  ServerSession? initialSession,
  bool autoSyncOnStart = false,
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
    adapter: httpClientAdapter ?? _StubOfflineHttpAdapter(),
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

  final resolvedSocket = socketService ?? FakeAbsSocketService();
  final resolvedCoverExtractor =
      coverThemeExtractor ?? FakeCoverThemeExtractor();
  final resolvedEngine = audioPlayerEngine ?? FakeAudioPlayerEngine();
  final resolvedPlayerController =
      playerController ??
      PlayerController(
        apiClient: apiClient,
        database: resolvedDb,
        authController: authController,
        credentialsStore: credentialsStore,
        engine: resolvedEngine,
        socketService: resolvedSocket,
        coverThemeExtractor: resolvedCoverExtractor,
        logger: resolvedLogger,
        shakeDetector: shakeDetector ?? FakeShakeDetector(),
      );

  return AppDependencies(
    flavorConfig: flavorConfig,
    logger: resolvedLogger,
    themeController: themeController ?? ThemeController(),
    database: resolvedDb,
    secureStorage: resolvedStorage,
    credentialsStore: credentialsStore,
    apiClient: apiClient,
    authRepository: resolvedAuthRepo,
    authController: authController,
    libraryRepository: libraryRepository ?? FakeLibraryRepository(),
    socketService: resolvedSocket,
    coverThemeExtractor: resolvedCoverExtractor,
    logExporter: logExporter ?? FakeLogExporter(),
    playerController: resolvedPlayerController,
    useGoogleFonts: false,
    enableNetworkImages: false,
    autoSyncOnStart: autoSyncOnStart,
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

class _StubOfflineHttpAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final path = options.uri.path;
    if (options.method == 'POST' && path.endsWith('/play')) {
      return _json(200, <String, Object?>{
        'id': 'test-session-1',
        'libraryItemId': 'item-1',
        'playMethod': 0,
        'startTime': 0,
        'currentTime': 0,
        'duration': 58200,
        'audioTracks': <Object>[
          <String, Object?>{
            'index': 0,
            'startOffset': 0,
            'duration': 58200,
            'title': 'Full Book',
            'contentUrl': '/api/items/item-1/file/part1.m4b',
          },
        ],
      });
    }
    if (options.method == 'POST' &&
        (path.endsWith('/sync') || path.endsWith('/close'))) {
      return _json(200, <String, Object?>{'success': true});
    }
    if (path.contains('/bookmark')) {
      return _json(200, <String, Object?>{
        'libraryItemId': 'item-1',
        'title': 'Bookmark',
        'time': 0,
        'createdAt': 1718000000000,
      });
    }
    return _json(404, <String, Object?>{'error': 'Not mocked'});
  }

  ResponseBody _json(int status, Map<String, Object?> body) {
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
