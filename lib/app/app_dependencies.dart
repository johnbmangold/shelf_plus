import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:shelf_plus/app/flavor_config.dart';
import 'package:shelf_plus/core/database/app_database.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/network/abs_api_client.dart';
import 'package:shelf_plus/core/network/connectivity_service.dart';
import 'package:shelf_plus/core/socket/abs_socket_service.dart';
import 'package:shelf_plus/core/storage/secure_storage_service.dart';
import 'package:shelf_plus/core/theme/dynamic_cover_theme_service.dart';
import 'package:shelf_plus/core/theme/theme_controller.dart';
import 'package:shelf_plus/features/auth/data/auth_repository_impl.dart';
import 'package:shelf_plus/features/auth/domain/auth_repository.dart';
import 'package:shelf_plus/features/auth/presentation/auth_controller.dart';
import 'package:shelf_plus/features/diagnostics/data/share_plus_log_exporter.dart';
import 'package:shelf_plus/features/diagnostics/domain/log_exporter.dart';
import 'package:shelf_plus/features/downloads/data/dio_download_transport.dart';
import 'package:shelf_plus/features/downloads/domain/download_transport.dart';
import 'package:shelf_plus/features/downloads/presentation/download_controller.dart';
import 'package:shelf_plus/features/library/data/library_repository_impl.dart';
import 'package:shelf_plus/features/library/domain/library_repository.dart';
import 'package:shelf_plus/features/player/data/just_audio_player_engine.dart';
import 'package:shelf_plus/features/player/domain/audio_player_engine.dart';
import 'package:shelf_plus/features/player/domain/shake_detector.dart';
import 'package:shelf_plus/features/player/presentation/player_controller.dart';
import 'package:shelf_plus/features/sync/presentation/offline_sync_controller.dart';

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
    required this.credentialsStore,
    required this.apiClient,
    required this.authRepository,
    required this.authController,
    required this.libraryRepository,
    required this.socketService,
    required this.coverThemeExtractor,
    required this.logExporter,
    required this.connectivityService,
    required this.downloadController,
    required this.offlineSyncController,
    required this.playerController,
    this.useGoogleFonts = true,
    this.enableNetworkImages = true,
    this.autoSyncOnStart = true,
  });

  /// Creates the default production/development dependency graph for
  /// [flavorConfig].
  factory create({
    required FlavorConfig flavorConfig,
    AppDatabase? database,
    SecureStorageService? secureStorage,
    LogExporter? logExporter,
    LibraryRepository? libraryRepository,
    AbsSocketService? socketService,
    CoverThemeExtractor? coverThemeExtractor,
    ConnectivityService? connectivityService,
    DownloadTransport? downloadTransport,
    Future<Directory> Function()? getDownloadsRoot,
    AudioPlayerEngine? audioPlayerEngine,
    ShakeDetector? shakeDetector,
    HttpClientAdapter? httpClientAdapter,
    bool useGoogleFonts = true,
    bool enableNetworkImages = true,
    bool autoSyncOnStart = true,
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

    final resolvedLibraryRepo =
        libraryRepository ??
        LibraryRepositoryImpl(
          apiClient: apiClient,
          database: resolvedDb,
          logger: logger,
        );

    final resolvedSocket = socketService ?? SocketIoAbsService(logger: logger);
    final resolvedCoverExtractor =
        coverThemeExtractor ?? FlutterCoverThemeExtractor();
    final resolvedEngine =
        audioPlayerEngine ??
        JustAudioPlayerEngine(
          logger: logger,
          notificationChannelId: '${flavorConfig.applicationId}.channel.audio',
        );
    final resolvedConnectivity =
        connectivityService ?? ConnectivityPlusService();
    final resolvedTransport =
        downloadTransport ?? DioDownloadTransport(apiClient.authenticatedDio);
    final downloadController = DownloadController(
      apiClient: apiClient,
      database: resolvedDb,
      authController: authController,
      connectivityService: resolvedConnectivity,
      transport: resolvedTransport,
      logger: logger,
      getDownloadsRoot: getDownloadsRoot,
    );
    final offlineSyncController = OfflineSyncController(
      apiClient: apiClient,
      database: resolvedDb,
      authController: authController,
      connectivityService: resolvedConnectivity,
      logger: logger,
    );
    final playerController = PlayerController(
      apiClient: apiClient,
      database: resolvedDb,
      authController: authController,
      credentialsStore: credentialsStore,
      engine: resolvedEngine,
      socketService: resolvedSocket,
      coverThemeExtractor: resolvedCoverExtractor,
      logger: logger,
      downloadController: downloadController,
      offlineSyncController: offlineSyncController,
      shakeDetector: shakeDetector,
    );

    return AppDependencies(
      flavorConfig: flavorConfig,
      logger: logger,
      themeController: ThemeController(),
      database: resolvedDb,
      secureStorage: resolvedStorage,
      credentialsStore: credentialsStore,
      apiClient: apiClient,
      authRepository: authRepository,
      authController: authController,
      libraryRepository: resolvedLibraryRepo,
      socketService: resolvedSocket,
      coverThemeExtractor: resolvedCoverExtractor,
      logExporter: logExporter ?? const SharePlusLogExporter(),
      connectivityService: resolvedConnectivity,
      downloadController: downloadController,
      offlineSyncController: offlineSyncController,
      playerController: playerController,
      useGoogleFonts: useGoogleFonts,
      enableNetworkImages: enableNetworkImages,
      autoSyncOnStart: autoSyncOnStart,
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

  /// Credential & custom header store for active servers.
  final AuthCredentialsStore credentialsStore;

  /// Audiobookshelf REST API client.
  final AbsApiClient apiClient;

  /// Authentication and server profile repository.
  final AuthRepository authRepository;

  /// Global authentication controller.
  final AuthController authController;

  /// Offline-first library repository.
  final LibraryRepository libraryRepository;

  /// Real-time foreground Socket.IO client.
  final AbsSocketService socketService;

  /// Cover palette extractor for dynamic theming.
  final CoverThemeExtractor coverThemeExtractor;

  /// Diagnostic log exporter.
  final LogExporter logExporter;

  /// Active connectivity state monitor.
  final ConnectivityService connectivityService;

  /// Offline audiobook download manager.
  final DownloadController downloadController;

  /// Offline progress/bookmark sync queue and conflict resolver.
  final OfflineSyncController offlineSyncController;

  /// Application-wide audio playback controller.
  final PlayerController playerController;

  /// Whether Google Fonts network/bundled loading should be used in themes.
  final bool useGoogleFonts;

  /// Whether network cover images should be fetched (false in offline tests).
  final bool enableNetworkImages;

  /// Whether Home & BookDetail should sync automatically on mount.
  final bool autoSyncOnStart;

  /// Releases resources owned by this composition root.
  void dispose() {
    playerController.dispose();
    downloadController.dispose();
    offlineSyncController.dispose();
    unawaited(connectivityService.dispose());
    socketService.dispose();
    themeController.dispose();
    authController.dispose();
    unawaited(database.close());
  }
}
