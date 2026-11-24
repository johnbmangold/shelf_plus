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
}
