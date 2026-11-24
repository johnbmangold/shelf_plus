import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/theme/app_theme_mode.dart';

/// Manages the active [AppThemeMode] across the application.
class ThemeController extends ChangeNotifier {
  /// Creates a [ThemeController] defaulting to [initialMode].
  new({AppThemeMode initialMode = AppThemeMode.system}) : _mode = initialMode;

  AppThemeMode _mode;

  /// Currently selected [AppThemeMode].
  AppThemeMode get mode => _mode;

  /// Whether the true-black AMOLED dark theme is active.
  bool get isAmoled => _mode == AppThemeMode.amoled;

  /// Maps [_mode] to Flutter's [ThemeMode] for [MaterialApp.router].
  ThemeMode get flutterThemeMode => switch (_mode) {
    AppThemeMode.system => ThemeMode.system,
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark || AppThemeMode.amoled => ThemeMode.dark,
  };

  /// Updates the active theme [mode] and notifies listeners when changed.
  void setMode(AppThemeMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
  }
}
