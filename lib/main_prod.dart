import 'package:flutter/widgets.dart';
import 'package:shelf_plus/app/app.dart';
import 'package:shelf_plus/app/app_dependencies.dart';
import 'package:shelf_plus/app/flavor_config.dart';

/// Production flavor entrypoint (`com.shcworks.shelfplus`).
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final dependencies = AppDependencies.create(
    flavorConfig: const FlavorConfig.prod(),
  );
  runApp(ShelfPlusApp(dependencies: dependencies));
}
