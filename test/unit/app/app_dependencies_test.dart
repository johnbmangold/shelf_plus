import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/app/app_dependencies.dart';
import 'package:shelf_plus/app/flavor_config.dart';
import 'package:shelf_plus/core/database/app_database.dart';
import 'package:shelf_plus/core/theme/dynamic_cover_theme_service.dart';

import '../../fakes/fake_connectivity_service.dart';
import '../../fakes/in_memory_secure_storage_service.dart';

void main() {
  group('AppDependencies and FlutterCoverThemeExtractor', () {
    test('AppDependencies.create wires graph and disposes cleanly', () async {
      final deps = AppDependencies.create(
        flavorConfig: const FlavorConfig.dev(),
        database: AppDatabase.inMemory(),
        secureStorage: InMemorySecureStorageService(),
        connectivityService: FakeConnectivityService(),
        useGoogleFonts: false,
      );

      check(deps.flavorConfig.flavor).equals(AppFlavor.dev);
      await deps.authController.initialize();
      check(deps.authController.isAuthenticated).isFalse;

      deps.dispose();
      await Future<void>.delayed(Duration.zero);
    });

    test('FlutterCoverThemeExtractor returns null for empty URL', () async {
      final extractor = FlutterCoverThemeExtractor(maxEntries: 2);
      final result = await extractor.extractScheme(
        coverUrl: '',
        brightness: Brightness.light,
      );
      check(result).isNull;
    });
  });
}
