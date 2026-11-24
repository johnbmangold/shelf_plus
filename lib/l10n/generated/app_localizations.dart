import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Application display title.
  ///
  /// In en, this message translates to:
  /// **'Shelf Plus'**
  String get appTitle;

  /// Bottom navigation label for Home tab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Bottom navigation label for Library tab.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get navLibrary;

  /// Bottom navigation label for Downloads tab.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get navDownloads;

  /// Bottom navigation label for Settings tab.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// Placeholder title on Home screen.
  ///
  /// In en, this message translates to:
  /// **'Your listening shelf'**
  String get homeEmptyTitle;

  /// Empty state subtitle on Home screen.
  ///
  /// In en, this message translates to:
  /// **'Pull down to sync your Audiobookshelf library and start listening.'**
  String get homeEmptySubtitle;

  /// Hero section header on Home screen.
  ///
  /// In en, this message translates to:
  /// **'Continue listening'**
  String get homeContinueListening;

  /// In progress shelf title on Home screen.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get homeInProgress;

  /// Recently added shelf title on Home screen.
  ///
  /// In en, this message translates to:
  /// **'Recently added'**
  String get homeRecentlyAdded;

  /// Non-blocking banner shown when sync fails and cached books exist.
  ///
  /// In en, this message translates to:
  /// **'Offline — showing cached library'**
  String get homeOfflineBanner;

  /// Tooltip for manual refresh button on Home screen.
  ///
  /// In en, this message translates to:
  /// **'Sync library'**
  String get homeSyncTooltip;

  /// Remaining listening time label.
  ///
  /// In en, this message translates to:
  /// **'{time} left'**
  String bookTimeLeft(String time);

  /// Label shown when a book is completed.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get bookFinished;

  /// Placeholder title on Library screen.
  ///
  /// In en, this message translates to:
  /// **'Library browser'**
  String get libraryEmptyTitle;

  /// Empty state subtitle on Library screen.
  ///
  /// In en, this message translates to:
  /// **'Sync your Audiobookshelf server to browse books, series, authors, and collections.'**
  String get libraryEmptySubtitle;

  /// Search input placeholder on Library screen.
  ///
  /// In en, this message translates to:
  /// **'Search titles, authors, narrators, series…'**
  String get librarySearchHint;

  /// Browse mode label for Books.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get libraryTabBooks;

  /// Browse mode label for Series.
  ///
  /// In en, this message translates to:
  /// **'Series'**
  String get libraryTabSeries;

  /// Browse mode label for Authors.
  ///
  /// In en, this message translates to:
  /// **'Authors'**
  String get libraryTabAuthors;

  /// Browse mode label for Collections.
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get libraryTabCollections;

  /// Title for Sort and Filter bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Sort & Filter'**
  String get librarySortAndFilter;

  /// Sort section label.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get librarySortLabel;

  /// Filter section label.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get libraryFilterLabel;

  /// Sort books alphabetically by title.
  ///
  /// In en, this message translates to:
  /// **'Title A–Z'**
  String get librarySortTitleAsc;

  /// Sort books alphabetically by author.
  ///
  /// In en, this message translates to:
  /// **'Author A–Z'**
  String get librarySortAuthorAsc;

  /// Sort books by newest added date.
  ///
  /// In en, this message translates to:
  /// **'Recently added'**
  String get librarySortAddedDesc;

  /// Sort books by longest duration.
  ///
  /// In en, this message translates to:
  /// **'Longest first'**
  String get librarySortDurationDesc;

  /// Show all books.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get libraryFilterAll;

  /// Show only in-progress books.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get libraryFilterInProgress;

  /// Show only finished books.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get libraryFilterFinished;

  /// Show only unstarted books.
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get libraryFilterNotStarted;

  /// Book count subtitle for series, authors, or collections.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 book} other{{count} books}}'**
  String libraryBookCount(int count);

  /// Empty state when search or filter yields no books.
  ///
  /// In en, this message translates to:
  /// **'No matching books'**
  String get libraryNoMatches;

  /// Empty state when a library has no series, authors, or collections.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get libraryNoGroups;

  /// Tooltip for clear search button.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get libraryClearSearchTooltip;

  /// Overview tab label on Book Detail screen.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get bookDetailOverviewTab;

  /// Chapters tab label on Book Detail screen.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get bookDetailChaptersTab;

  /// Bookmarks tab label on Book Detail screen.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookDetailBookmarksTab;

  /// Narrator attribution line.
  ///
  /// In en, this message translates to:
  /// **'Narrated by {narrators}'**
  String bookDetailNarratedBy(String narrators);

  /// Play action button for unstarted book.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get bookDetailPlay;

  /// Resume action button for in-progress book.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get bookDetailResume;

  /// Download action button on Book Detail screen.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get bookDetailDownload;

  /// Placeholder notice when tapping Play before Phase 3.
  ///
  /// In en, this message translates to:
  /// **'Audio playback launches in Phase 3.'**
  String get bookDetailPlaybackPhase3;

  /// Placeholder notice when tapping Download before Phase 4.
  ///
  /// In en, this message translates to:
  /// **'Offline downloads launch in Phase 4.'**
  String get bookDetailDownloadPhase4;

  /// Empty state for Chapters tab.
  ///
  /// In en, this message translates to:
  /// **'No chapters available'**
  String get bookDetailNoChapters;

  /// Empty state for Bookmarks tab.
  ///
  /// In en, this message translates to:
  /// **'No bookmarks yet'**
  String get bookDetailNoBookmarks;

  /// Fallback when book synopsis is empty.
  ///
  /// In en, this message translates to:
  /// **'No synopsis available for this audiobook.'**
  String get bookDetailNoDescription;

  /// Metadata row label for publisher.
  ///
  /// In en, this message translates to:
  /// **'Publisher'**
  String get bookDetailPublisherLabel;

  /// Metadata row label for publication year.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get bookDetailPublishedLabel;

  /// Metadata row label for genres.
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get bookDetailGenresLabel;

  /// Metadata row label for series.
  ///
  /// In en, this message translates to:
  /// **'Series'**
  String get bookDetailSeriesLabel;

  /// Error state when a book detail cannot be loaded.
  ///
  /// In en, this message translates to:
  /// **'Book not found in local cache.'**
  String get bookDetailNotFound;

  /// Placeholder title on Downloads screen.
  ///
  /// In en, this message translates to:
  /// **'Offline downloads'**
  String get downloadsEmptyTitle;

  /// Placeholder subtitle on Downloads screen.
  ///
  /// In en, this message translates to:
  /// **'Background transfers and downloaded audiobooks will appear here.'**
  String get downloadsEmptySubtitle;

  /// Mini-player title when no audiobook is loaded.
  ///
  /// In en, this message translates to:
  /// **'Nothing playing'**
  String get miniPlayerIdleTitle;

  /// Mini-player subtitle when no audiobook is loaded.
  ///
  /// In en, this message translates to:
  /// **'Choose a book to start listening'**
  String get miniPlayerIdleSubtitle;

  /// Appearance section header in Settings.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// Label for theme mode selector.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemeLabel;

  /// Follow system theme mode.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// Editorial light theme mode.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// Editorial dark theme mode.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// True-black AMOLED theme mode.
  ///
  /// In en, this message translates to:
  /// **'AMOLED'**
  String get themeAmoled;

  /// Environment/flavor section header in Settings.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get settingsEnvironment;

  /// Flavor row label in Settings.
  ///
  /// In en, this message translates to:
  /// **'Flavor'**
  String get settingsFlavorLabel;

  /// Bundle/application ID row label in Settings.
  ///
  /// In en, this message translates to:
  /// **'Application ID'**
  String get settingsBundleIdLabel;

  /// Server and account section header in Settings.
  ///
  /// In en, this message translates to:
  /// **'Server & Account'**
  String get settingsServerSection;

  /// Sign out button label in Settings.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get settingsSignOut;

  /// Sign out confirmation dialog title.
  ///
  /// In en, this message translates to:
  /// **'Sign out of server?'**
  String get settingsSignOutTitle;

  /// Sign out confirmation dialog body.
  ///
  /// In en, this message translates to:
  /// **'Stored credentials and custom proxy headers for this server will be removed from this device.'**
  String get settingsSignOutBody;

  /// Cancel action label.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsCancel;

  /// Diagnostics row title in Settings.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics'**
  String get settingsDiagnosticsTitle;

  /// Diagnostics row subtitle in Settings.
  ///
  /// In en, this message translates to:
  /// **'Inspect and export redacted logs'**
  String get settingsDiagnosticsSubtitle;

  /// Displays the connected Audiobookshelf server version.
  ///
  /// In en, this message translates to:
  /// **'Server v{version}'**
  String settingsVersionPrefix(String version);

  /// Heading on the server setup and login screen.
  ///
  /// In en, this message translates to:
  /// **'Connect to Audiobookshelf'**
  String get loginTitle;

  /// Subtitle on the login screen.
  ///
  /// In en, this message translates to:
  /// **'Enter your server URL and account credentials. Subpaths and reverse-proxy headers are supported.'**
  String get loginSubtitle;

  /// Text field label for server URL.
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get loginServerUrlLabel;

  /// Hint text for server URL.
  ///
  /// In en, this message translates to:
  /// **'https://books.example.com'**
  String get loginServerUrlHint;

  /// Validation error for invalid or empty server URL.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid http:// or https:// server URL.'**
  String get loginServerUrlRequired;

  /// Button label to probe the server.
  ///
  /// In en, this message translates to:
  /// **'Test connection'**
  String get loginTestConnection;

  /// Button label while probing the server.
  ///
  /// In en, this message translates to:
  /// **'Testing…'**
  String get loginTestingConnection;

  /// Badge text when server probe succeeds with a version.
  ///
  /// In en, this message translates to:
  /// **'Connected ({version})'**
  String loginConnectedBadge(String version);

  /// Badge text when server probe succeeds without a version string.
  ///
  /// In en, this message translates to:
  /// **'Server reachable'**
  String get loginConnectedNoVersion;

  /// Expandable section title for custom proxy headers.
  ///
  /// In en, this message translates to:
  /// **'Custom HTTP headers'**
  String get loginCustomHeadersTitle;

  /// Subtitle for custom HTTP headers section.
  ///
  /// In en, this message translates to:
  /// **'Optional headers for Cloudflare Access or reverse proxies'**
  String get loginCustomHeadersSubtitle;

  /// Button to add a custom HTTP header row.
  ///
  /// In en, this message translates to:
  /// **'Add header'**
  String get loginAddHeader;

  /// Label for custom HTTP header name field.
  ///
  /// In en, this message translates to:
  /// **'Header name'**
  String get loginHeaderNameLabel;

  /// Label for custom HTTP header value field.
  ///
  /// In en, this message translates to:
  /// **'Header value'**
  String get loginHeaderValueLabel;

  /// Tooltip for removing a custom header row.
  ///
  /// In en, this message translates to:
  /// **'Remove header'**
  String get loginRemoveHeaderTooltip;

  /// Username field label.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get loginUsernameLabel;

  /// Validation error when username is empty.
  ///
  /// In en, this message translates to:
  /// **'Enter your username.'**
  String get loginUsernameRequired;

  /// Password field label.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// Validation error when password is empty.
  ///
  /// In en, this message translates to:
  /// **'Enter your password.'**
  String get loginPasswordRequired;

  /// Tooltip for password visibility icon button.
  ///
  /// In en, this message translates to:
  /// **'Toggle password visibility'**
  String get loginTogglePasswordTooltip;

  /// Sign in primary button label.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginSignIn;

  /// Sign in button label while request is in flight.
  ///
  /// In en, this message translates to:
  /// **'Signing in…'**
  String get loginSigningIn;

  /// Link to open diagnostics screen from login.
  ///
  /// In en, this message translates to:
  /// **'View diagnostic logs'**
  String get loginViewDiagnostics;

  /// Banner shown on login screen after refresh token expiration.
  ///
  /// In en, this message translates to:
  /// **'Your session expired. Sign in again to reconnect.'**
  String get loginSessionExpiredNotice;

  /// Error shown for malformed server URL.
  ///
  /// In en, this message translates to:
  /// **'The server URL is invalid. Include http:// or https://.'**
  String get authErrorInvalidUrl;

  /// Error shown when server cannot be contacted.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the server. Check the URL and your network connection.'**
  String get authErrorUnreachable;

  /// Error shown on request timeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timed out while waiting for the server.'**
  String get authErrorTimeout;

  /// Error shown on TLS certificate error.
  ///
  /// In en, this message translates to:
  /// **'TLS certificate check failed. Verify your server\'s HTTPS certificate.'**
  String get authErrorTls;

  /// Error shown when proxy returns 401/403 on probe.
  ///
  /// In en, this message translates to:
  /// **'Access was blocked by a proxy or gateway. Check your custom HTTP headers.'**
  String get authErrorProxyAuth;

  /// Error shown on invalid login credentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid username or password.'**
  String get authErrorCredentials;

  /// Error shown when server response cannot be parsed as ABS.
  ///
  /// In en, this message translates to:
  /// **'The server did not return a valid Audiobookshelf response.'**
  String get authErrorInvalidResponse;

  /// Fallback error message.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while contacting the server.'**
  String get authErrorUnknown;

  /// Diagnostics screen app bar title.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics'**
  String get diagnosticsTitle;

  /// Filter chip showing all log levels.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get diagnosticsFilterAll;

  /// Filter chip showing INFO and above.
  ///
  /// In en, this message translates to:
  /// **'Info+'**
  String get diagnosticsFilterInfo;

  /// Filter chip showing WARNING and above.
  ///
  /// In en, this message translates to:
  /// **'Warnings+'**
  String get diagnosticsFilterWarning;

  /// Filter chip showing SEVERE errors.
  ///
  /// In en, this message translates to:
  /// **'Errors'**
  String get diagnosticsFilterError;

  /// Tooltip for export logs button.
  ///
  /// In en, this message translates to:
  /// **'Export logs'**
  String get diagnosticsExportTooltip;

  /// Tooltip for clear logs button.
  ///
  /// In en, this message translates to:
  /// **'Clear logs'**
  String get diagnosticsClearTooltip;

  /// Empty state shown in Diagnostics screen.
  ///
  /// In en, this message translates to:
  /// **'No diagnostic logs matching this filter.'**
  String get diagnosticsEmpty;

  /// Snackbar shown when user tries to export an empty log buffer.
  ///
  /// In en, this message translates to:
  /// **'There are no logs to export yet.'**
  String get diagnosticsExportEmpty;

  /// Snackbar shown when exporting logs fails.
  ///
  /// In en, this message translates to:
  /// **'Could not export diagnostic logs.'**
  String get diagnosticsExportFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
