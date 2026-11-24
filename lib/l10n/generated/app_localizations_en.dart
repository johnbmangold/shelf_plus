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
      'Pull down to sync your Audiobookshelf library and start listening.';

  @override
  String get homeContinueListening => 'Continue listening';

  @override
  String get homeInProgress => 'In progress';

  @override
  String get homeRecentlyAdded => 'Recently added';

  @override
  String get homeOfflineBanner => 'Offline — showing cached library';

  @override
  String get homeSyncTooltip => 'Sync library';

  @override
  String bookTimeLeft(String time) {
    return '$time left';
  }

  @override
  String get bookFinished => 'Finished';

  @override
  String get libraryEmptyTitle => 'Library browser';

  @override
  String get libraryEmptySubtitle =>
      'Sync your Audiobookshelf server to browse books, series, authors, and collections.';

  @override
  String get librarySearchHint => 'Search titles, authors, narrators, series…';

  @override
  String get libraryTabBooks => 'Books';

  @override
  String get libraryTabSeries => 'Series';

  @override
  String get libraryTabAuthors => 'Authors';

  @override
  String get libraryTabCollections => 'Collections';

  @override
  String get librarySortAndFilter => 'Sort & Filter';

  @override
  String get librarySortLabel => 'Sort by';

  @override
  String get libraryFilterLabel => 'Filter';

  @override
  String get librarySortTitleAsc => 'Title A–Z';

  @override
  String get librarySortAuthorAsc => 'Author A–Z';

  @override
  String get librarySortAddedDesc => 'Recently added';

  @override
  String get librarySortDurationDesc => 'Longest first';

  @override
  String get libraryFilterAll => 'All';

  @override
  String get libraryFilterInProgress => 'In progress';

  @override
  String get libraryFilterFinished => 'Finished';

  @override
  String get libraryFilterNotStarted => 'Not started';

  @override
  String libraryBookCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count books',
      one: '1 book',
    );
    return '$_temp0';
  }

  @override
  String get libraryNoMatches => 'No matching books';

  @override
  String get libraryNoGroups => 'Nothing here yet';

  @override
  String get libraryClearSearchTooltip => 'Clear search';

  @override
  String get bookDetailOverviewTab => 'Overview';

  @override
  String get bookDetailChaptersTab => 'Chapters';

  @override
  String get bookDetailBookmarksTab => 'Bookmarks';

  @override
  String bookDetailNarratedBy(String narrators) {
    return 'Narrated by $narrators';
  }

  @override
  String get bookDetailPlay => 'Play';

  @override
  String get bookDetailResume => 'Resume';

  @override
  String get bookDetailDownload => 'Download';

  @override
  String get bookDetailPlaybackPhase3 => 'Audio playback launches in Phase 3.';

  @override
  String get bookDetailDownloadPhase4 => 'Offline downloads launch in Phase 4.';

  @override
  String get bookDetailNoChapters => 'No chapters available';

  @override
  String get bookDetailNoBookmarks => 'No bookmarks yet';

  @override
  String get bookDetailNoDescription =>
      'No synopsis available for this audiobook.';

  @override
  String get bookDetailPublisherLabel => 'Publisher';

  @override
  String get bookDetailPublishedLabel => 'Published';

  @override
  String get bookDetailGenresLabel => 'Genres';

  @override
  String get bookDetailSeriesLabel => 'Series';

  @override
  String get bookDetailNotFound => 'Book not found in local cache.';

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

  @override
  String get playerTitle => 'Now Playing';

  @override
  String get playerNoActiveBook => 'Nothing playing right now';

  @override
  String get playerNoActiveBookBody =>
      'Select any audiobook from your library to begin listening.';

  @override
  String get playerPlay => 'Play';

  @override
  String get playerPause => 'Pause';

  @override
  String playerRewindSeconds(int seconds) {
    return 'Rewind ${seconds}s';
  }

  @override
  String playerForwardSeconds(int seconds) {
    return 'Forward ${seconds}s';
  }

  @override
  String get playerPreviousChapter => 'Previous chapter';

  @override
  String get playerNextChapter => 'Next chapter';

  @override
  String get playerScrubChapter => 'Chapter';

  @override
  String get playerScrubBook => 'Full Book';

  @override
  String playerSpeedLabel(String speed) {
    return '${speed}x';
  }

  @override
  String get playerSpeedSheetTitle => 'Playback speed';

  @override
  String get playerSkipSilenceLabel => 'Skip silence';

  @override
  String get playerSkipSilenceSubtitle =>
      'Trim extended pauses between narration';

  @override
  String get playerSleepTimerLabel => 'Sleep timer';

  @override
  String get playerSleepOff => 'Off';

  @override
  String get playerSleepEndOfChapter => 'End of chapter';

  @override
  String playerSleepMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String playerSleepGraceHint(int minutes) {
    return 'Shake phone to extend +$minutes min';
  }

  @override
  String get playerChaptersLabel => 'Chapters';

  @override
  String get playerBookmarksLabel => 'Bookmarks';

  @override
  String get playerAddBookmark => 'Add bookmark';

  @override
  String get playerBookmarkTitleLabel => 'Bookmark title';

  @override
  String get playerBookmarkNoteLabel => 'Note (optional)';

  @override
  String get playerSaveBookmark => 'Save bookmark';

  @override
  String get playerNoBookmarks => 'No bookmarks saved for this book yet.';

  @override
  String get playerHistoryLabel => 'History';

  @override
  String get playerNoHistory => 'No playback jumps recorded yet.';

  @override
  String playerSmartRewindApplied(int seconds) {
    return 'Rewound ${seconds}s on resume';
  }

  @override
  String get playerStreamDirect => 'Direct Stream';

  @override
  String get playerStreamHls => 'HLS Transcode';

  @override
  String get playerBuffering => 'Buffering…';

  @override
  String get playerPlaybackError => 'Could not start audio playback.';

  @override
  String get playerHistoryReasonPlay => 'Started';

  @override
  String get playerHistoryReasonSeek => 'Scrubbed';

  @override
  String get playerHistoryReasonChapter => 'Chapter';

  @override
  String get playerHistoryReasonPause => 'Paused';

  @override
  String get playerHistoryReasonRewind => 'Smart rewind';

  @override
  String get playerHistoryReasonBookmark => 'Bookmark';

  @override
  String get playerStreamLocal => 'Downloaded';

  @override
  String downloadsStorageUsed(String size) {
    return '$size used on device';
  }

  @override
  String get downloadsWifiOnlyTitle => 'Download on Wi-Fi only';

  @override
  String get downloadsWifiOnlySubtitle =>
      'Pause transfers automatically on cellular networks';

  @override
  String get downloadsAutoDeleteTitle => 'Auto-delete finished books';

  @override
  String get downloadsAutoDeleteSubtitle =>
      'Remove downloaded files once an audiobook is finished';

  @override
  String get downloadsClearAll => 'Clear all';

  @override
  String get downloadsStatusQueued => 'Queued';

  @override
  String get downloadsStatusDownloading => 'Downloading';

  @override
  String get downloadsStatusPaused => 'Paused';

  @override
  String get downloadsStatusCompleted => 'Downloaded';

  @override
  String get downloadsStatusFailed => 'Failed';

  @override
  String get downloadsWaitingForWifi => 'Waiting for Wi-Fi';

  @override
  String get downloadsPause => 'Pause';

  @override
  String get downloadsResume => 'Resume';

  @override
  String get downloadsRetry => 'Retry';

  @override
  String get downloadsDelete => 'Delete';

  @override
  String get downloadsDeleteTitle => 'Remove offline files?';

  @override
  String get downloadsDeleteBody =>
      'This deletes downloaded audio from this device without affecting your Audiobookshelf server.';

  @override
  String get downloadsCancel => 'Cancel';

  @override
  String syncPendingBadge(int count) {
    return '$count pending sync';
  }

  @override
  String get syncNow => 'Sync now';

  @override
  String get syncConflictBannerTitle => 'Progress conflict detected';

  @override
  String syncConflictBannerSubtitle(int count) {
    return '$count audiobook(s) have newer progress on both this device and the server.';
  }

  @override
  String get syncConflictResolve => 'Resolve';

  @override
  String get syncConflictSheetTitle => 'Choose listening position';

  @override
  String get syncConflictDeviceLabel => 'This device';

  @override
  String get syncConflictServerLabel => 'Server';

  @override
  String get syncConflictKeepDevice => 'Keep device position';

  @override
  String get syncConflictUseServer => 'Use server position';
}
