import 'package:flutter/widgets.dart';
import 'package:shelf_plus/app/app.dart';
import 'package:shelf_plus/app/app_dependencies.dart';
import 'package:shelf_plus/app/flavor_config.dart';

/// Development flavor entrypoint (`com.shcworks.shelfplus.dev`).
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dependencies = AppDependencies.create(
    flavorConfig: const FlavorConfig.dev(),
  );
  await dependencies.authController.initialize();
  runApp(ShelfPlusApp(dependencies: dependencies));
}
