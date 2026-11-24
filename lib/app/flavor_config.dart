import 'package:flutter/foundation.dart';

/// Build flavor identifying the runtime environment.
enum AppFlavor {
  /// Development flavor (`com.shcworks.shelfplus.dev`).
  dev,

  /// Production flavor (`com.shcworks.shelfplus`).
  prod,
}

/// Immutable runtime configuration for the active [AppFlavor].
@immutable
class FlavorConfig {
  /// Creates a [FlavorConfig].
  const new({
    required this.flavor,
    required this.appName,
    required this.applicationId,
    required this.enableVerboseLogging,
  });

  /// Creates the development flavor configuration.
  const new dev()
    : flavor = AppFlavor.dev,
      appName = 'Shelf Plus Dev',
      applicationId = 'com.shcworks.shelfplus.dev',
      enableVerboseLogging = true;

  /// Creates the production flavor configuration.
  const new prod()
    : flavor = AppFlavor.prod,
      appName = 'Shelf Plus',
      applicationId = 'com.shcworks.shelfplus',
      enableVerboseLogging = false;

  /// Active build flavor.
  final AppFlavor flavor;

  /// User-facing application display name.
  final String appName;

  /// Android application ID / iOS bundle identifier.
  final String applicationId;

  /// Whether verbose diagnostic logging is enabled by default.
  final bool enableVerboseLogging;
}
