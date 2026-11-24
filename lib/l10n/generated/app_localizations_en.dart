// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Shelf Plus';

  @override
  String get navHome => 'Home';

  @override
  String get navLibrary => 'Library';

  @override
  String get navDownloads => 'Downloads';

  @override
  String get navSettings => 'Settings';

  @override
  String get homeEmptyTitle => 'Your listening shelf';

  @override
  String get homeEmptySubtitle =>
      'Connect an Audiobookshelf server in Phase 1 to see Continue Listening and recently added books.';

  @override
  String get libraryEmptyTitle => 'Library browser';

  @override
  String get libraryEmptySubtitle =>
      'Browse books, series, authors, and collections with instant offline search.';

  @override
  String get downloadsEmptyTitle => 'Offline downloads';

  @override
  String get downloadsEmptySubtitle =>
      'Background transfers and downloaded audiobooks will appear here.';

  @override
  String get miniPlayerIdleTitle => 'Nothing playing';

  @override
  String get miniPlayerIdleSubtitle => 'Choose a book to start listening';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsThemeLabel => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsEnvironment => 'Environment';

  @override
  String get settingsFlavorLabel => 'Flavor';

  @override
  String get settingsBundleIdLabel => 'Application ID';

  @override
  String get settingsServerSection => 'Server & Account';

  @override
  String get settingsSignOut => 'Sign out';

  @override
  String get settingsSignOutTitle => 'Sign out of server?';

  @override
  String get settingsSignOutBody =>
      'Stored credentials and custom proxy headers for this server will be removed from this device.';

  @override
  String get settingsCancel => 'Cancel';

  @override
  String get settingsDiagnosticsTitle => 'Diagnostics';

  @override
  String get settingsDiagnosticsSubtitle => 'Inspect and export redacted logs';

  @override
  String settingsVersionPrefix(String version) {
    return 'Server v$version';
  }

  @override
  String get loginTitle => 'Connect to Audiobookshelf';

  @override
  String get loginSubtitle =>
      'Enter your server URL and account credentials. Subpaths and reverse-proxy headers are supported.';

  @override
  String get loginServerUrlLabel => 'Server URL';

  @override
  String get loginServerUrlHint => 'https://books.example.com';

  @override
  String get loginServerUrlRequired =>
      'Enter a valid http:// or https:// server URL.';

  @override
  String get loginTestConnection => 'Test connection';

  @override
  String get loginTestingConnection => 'Testing…';

  @override
  String loginConnectedBadge(String version) {
    return 'Connected ($version)';
  }

  @override
  String get loginConnectedNoVersion => 'Server reachable';

  @override
  String get loginCustomHeadersTitle => 'Custom HTTP headers';

  @override
  String get loginCustomHeadersSubtitle =>
      'Optional headers for Cloudflare Access or reverse proxies';

  @override
  String get loginAddHeader => 'Add header';

  @override
  String get loginHeaderNameLabel => 'Header name';

  @override
  String get loginHeaderValueLabel => 'Header value';

  @override
  String get loginRemoveHeaderTooltip => 'Remove header';

  @override
  String get loginUsernameLabel => 'Username';

  @override
  String get loginUsernameRequired => 'Enter your username.';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordRequired => 'Enter your password.';

  @override
  String get loginTogglePasswordTooltip => 'Toggle password visibility';

  @override
  String get loginSignIn => 'Sign in';

  @override
  String get loginSigningIn => 'Signing in…';

  @override
  String get loginViewDiagnostics => 'View diagnostic logs';

  @override
  String get loginSessionExpiredNotice =>
      'Your session expired. Sign in again to reconnect.';

  @override
  String get authErrorInvalidUrl =>
      'The server URL is invalid. Include http:// or https://.';

  @override
  String get authErrorUnreachable =>
      'Could not reach the server. Check the URL and your network connection.';

  @override
  String get authErrorTimeout =>
      'Connection timed out while waiting for the server.';

  @override
  String get authErrorTls =>
      'TLS certificate check failed. Verify your server\'s HTTPS certificate.';

  @override
  String get authErrorProxyAuth =>
      'Access was blocked by a proxy or gateway. Check your custom HTTP headers.';

  @override
  String get authErrorCredentials => 'Invalid username or password.';

  @override
  String get authErrorInvalidResponse =>
      'The server did not return a valid Audiobookshelf response.';

  @override
  String get authErrorUnknown =>
      'Something went wrong while contacting the server.';

  @override
  String get diagnosticsTitle => 'Diagnostics';

  @override
  String get diagnosticsFilterAll => 'All';

  @override
  String get diagnosticsFilterInfo => 'Info+';

  @override
  String get diagnosticsFilterWarning => 'Warnings+';

  @override
  String get diagnosticsFilterError => 'Errors';

  @override
  String get diagnosticsExportTooltip => 'Export logs';

  @override
  String get diagnosticsClearTooltip => 'Clear logs';

  @override
  String get diagnosticsEmpty => 'No diagnostic logs matching this filter.';

  @override
  String get diagnosticsExportEmpty => 'There are no logs to export yet.';

  @override
  String get diagnosticsExportFailed => 'Could not export diagnostic logs.';
}
