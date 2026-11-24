import 'package:flutter/widgets.dart';
import 'package:shelf_plus/app/app.dart';
import 'package:shelf_plus/app/app_dependencies.dart';
import 'package:shelf_plus/app/flavor_config.dart';

/// Development flavor entrypoint (`com.shcworks.shelfplus.dev`).
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final dependencies = AppDependencies.create(
    flavorConfig: const FlavorConfig.dev(),
  );
  runApp(ShelfPlusApp(dependencies: dependencies));
}
