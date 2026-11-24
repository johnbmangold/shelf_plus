import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/theme/app_theme_mode.dart';
import 'package:shelf_plus/core/theme/theme_controller.dart';

void main() {
  group('ThemeController', () {
    test('defaults to AppThemeMode.system', () {
      final controller = ThemeController();
      addTearDown(controller.dispose);

      check(controller.mode).equals(AppThemeMode.system);
      check(controller.flutterThemeMode).equals(ThemeMode.system);
      check(controller.isAmoled).isFalse;
    });

    test('maps all AppThemeMode values and notifies only on change', () {
      final controller = ThemeController();
      addTearDown(controller.dispose);

      var notifications = 0;
      controller
        ..addListener(() => notifications++)
        ..setMode(AppThemeMode.system);
      check(notifications).equals(0);

      controller.setMode(AppThemeMode.light);
      check(notifications).equals(1);
      check(controller.flutterThemeMode).equals(ThemeMode.light);
      check(controller.isAmoled).isFalse;

      controller.setMode(AppThemeMode.dark);
      check(notifications).equals(2);
      check(controller.flutterThemeMode).equals(ThemeMode.dark);
      check(controller.isAmoled).isFalse;

      controller.setMode(AppThemeMode.amoled);
      check(notifications).equals(3);
      check(controller.flutterThemeMode).equals(ThemeMode.dark);
      check(controller.isAmoled).isTrue;

      controller.setMode(AppThemeMode.amoled);
      check(notifications).equals(3);
    });
  });
}
