// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Shelf Plus';

  @override
  String get navHome => 'Start';

  @override
  String get navLibrary => 'Bibliothek';

  @override
  String get navDownloads => 'Downloads';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get homeEmptyTitle => 'Dein Hörbuchregal';

  @override
  String get homeEmptySubtitle =>
      'Zum Synchronisieren deiner Audiobookshelf-Bibliothek nach unten ziehen.';

  @override
  String get homeContinueListening => 'Weiterhören';

  @override
  String get homeInProgress => 'Begonnen';

  @override
  String get homeRecentlyAdded => 'Kürzlich hinzugefügt';

  @override
  String get homeOfflineBanner =>
      'Offline — zwischengespeicherte Bibliothek wird angezeigt';

  @override
  String get homeSyncTooltip => 'Bibliothek synchronisieren';

  @override
  String bookTimeLeft(String time) {
    return 'Noch $time';
  }

  @override
  String get bookFinished => 'Beendet';

  @override
  String get libraryEmptyTitle => 'Bibliotheksbrowser';

  @override
  String get libraryEmptySubtitle =>
      'Synchronisiere deinen Audiobookshelf-Server, um Bücher, Reihen, Autoren und Sammlungen zu durchsuchen.';

  @override
  String get librarySearchHint => 'Titel, Autoren, Sprecher, Reihen suchen…';

  @override
  String get libraryTabBooks => 'Bücher';

  @override
  String get libraryTabSeries => 'Reihen';

  @override
  String get libraryTabAuthors => 'Autoren';

  @override
  String get libraryTabCollections => 'Sammlungen';

  @override
  String get librarySortAndFilter => 'Sortieren & Filtern';

  @override
  String get librarySortLabel => 'Sortieren nach';

  @override
  String get libraryFilterLabel => 'Filter';

  @override
  String get librarySortTitleAsc => 'Titel A–Z';

  @override
  String get librarySortAuthorAsc => 'Autor A–Z';

  @override
  String get librarySortAddedDesc => 'Kürzlich hinzugefügt';

  @override
  String get librarySortDurationDesc => 'Längste zuerst';

  @override
  String get libraryFilterAll => 'Alle';

  @override
  String get libraryFilterInProgress => 'Begonnen';

  @override
  String get libraryFilterFinished => 'Beendet';

  @override
  String get libraryFilterNotStarted => 'Nicht begonnen';

  @override
  String libraryBookCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bücher',
      one: '1 Buch',
    );
    return '$_temp0';
  }

  @override
  String get libraryNoMatches => 'Keine passenden Bücher';

  @override
  String get libraryNoGroups => 'Hier ist noch nichts';

  @override
  String get libraryClearSearchTooltip => 'Suche löschen';

  @override
  String get bookDetailOverviewTab => 'Übersicht';

  @override
  String get bookDetailChaptersTab => 'Kapitel';

  @override
  String get bookDetailBookmarksTab => 'Lesezeichen';

  @override
  String bookDetailNarratedBy(String narrators) {
    return 'Gelesen von $narrators';
  }

  @override
  String get bookDetailPlay => 'Abspielen';

  @override
  String get bookDetailResume => 'Fortsetzen';

  @override
  String get bookDetailDownload => 'Herunterladen';

  @override
  String get bookDetailPlaybackPhase3 => 'Audiowiedergabe startet in Phase 3.';

  @override
  String get bookDetailDownloadPhase4 =>
      'Offline-Downloads starten in Phase 4.';

  @override
  String get bookDetailNoChapters => 'Keine Kapitel verfügbar';

  @override
  String get bookDetailNoBookmarks => 'Noch keine Lesezeichen';

  @override
  String get bookDetailNoDescription =>
      'Für dieses Hörbuch ist keine Beschreibung verfügbar.';

  @override
  String get bookDetailPublisherLabel => 'Verlag';

  @override
  String get bookDetailPublishedLabel => 'Veröffentlicht';

  @override
  String get bookDetailGenresLabel => 'Genres';

  @override
  String get bookDetailSeriesLabel => 'Reihe';

  @override
  String get bookDetailNotFound => 'Buch nicht im lokalen Cache gefunden.';

  @override
  String get downloadsEmptyTitle => 'Offline-Downloads';

  @override
  String get downloadsEmptySubtitle =>
      'Hintergrundübertragungen und heruntergeladene Hörbücher erscheinen hier.';

  @override
  String get miniPlayerIdleTitle => 'Nichts wird abgespielt';

  @override
  String get miniPlayerIdleSubtitle => 'Wähle ein Buch zum Anhören aus';

  @override
  String get settingsAppearance => 'Darstellung';

  @override
  String get settingsThemeLabel => 'Design';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsEnvironment => 'Umgebung';

  @override
  String get settingsFlavorLabel => 'Variante';

  @override
  String get settingsBundleIdLabel => 'Anwendungs-ID';

  @override
  String get settingsServerSection => 'Server & Konto';

  @override
  String get settingsSignOut => 'Abmelden';

  @override
  String get settingsSignOutTitle => 'Vom Server abmelden?';

  @override
  String get settingsSignOutBody =>
      'Gespeicherte Zugangsdaten und benutzerdefinierte Proxy-Header für diesen Server werden von diesem Gerät entfernt.';

  @override
  String get settingsCancel => 'Abbrechen';

  @override
  String get settingsDiagnosticsTitle => 'Diagnose';

  @override
  String get settingsDiagnosticsSubtitle =>
      'Bereinigte Protokolle prüfen und exportieren';

  @override
  String settingsVersionPrefix(String version) {
    return 'Server v$version';
  }

  @override
  String get loginTitle => 'Mit Audiobookshelf verbinden';

  @override
  String get loginSubtitle =>
      'Gib deine Server-URL und Kontodaten ein. Unterpfade und Reverse-Proxy-Header werden unterstützt.';

  @override
  String get loginServerUrlLabel => 'Server-URL';

  @override
  String get loginServerUrlHint => 'https://books.example.com';

  @override
  String get loginServerUrlRequired =>
      'Gib eine gültige http://- oder https://-Server-URL ein.';

  @override
  String get loginTestConnection => 'Verbindung testen';

  @override
  String get loginTestingConnection => 'Teste…';

  @override
  String loginConnectedBadge(String version) {
    return 'Verbunden ($version)';
  }

  @override
  String get loginConnectedNoVersion => 'Server erreichbar';

  @override
  String get loginCustomHeadersTitle => 'Benutzerdefinierte HTTP-Header';

  @override
  String get loginCustomHeadersSubtitle =>
      'Optionale Header für Cloudflare Access oder Reverse-Proxys';

  @override
  String get loginAddHeader => 'Header hinzufügen';

  @override
  String get loginHeaderNameLabel => 'Header-Name';

  @override
  String get loginHeaderValueLabel => 'Header-Wert';

  @override
  String get loginRemoveHeaderTooltip => 'Header entfernen';

  @override
  String get loginUsernameLabel => 'Benutzername';

  @override
  String get loginUsernameRequired => 'Gib deinen Benutzernamen ein.';

  @override
  String get loginPasswordLabel => 'Passwort';

  @override
  String get loginPasswordRequired => 'Gib dein Passwort ein.';

  @override
  String get loginTogglePasswordTooltip => 'Passwort ein-/ausblenden';

  @override
  String get loginSignIn => 'Anmelden';

  @override
  String get loginSigningIn => 'Anmelden…';

  @override
  String get loginViewDiagnostics => 'Diagnoseprotokolle anzeigen';

  @override
  String get loginSessionExpiredNotice =>
      'Deine Sitzung ist abgelaufen. Melde dich erneut an.';

  @override
  String get authErrorInvalidUrl =>
      'Die Server-URL ist ungültig. Gib http:// oder https:// an.';

  @override
  String get authErrorUnreachable =>
      'Server nicht erreichbar. Prüfe URL und Netzwerkverbindung.';

  @override
  String get authErrorTimeout =>
      'Zeitüberschreitung beim Warten auf den Server.';

  @override
  String get authErrorTls =>
      'TLS-Zertifikatsprüfung fehlgeschlagen. Prüfe das HTTPS-Zertifikat deines Servers.';

  @override
  String get authErrorProxyAuth =>
      'Zugriff durch Proxy oder Gateway blockiert. Prüfe deine benutzerdefinierten HTTP-Header.';

  @override
  String get authErrorCredentials =>
      'Ungültiger Benutzername oder falsches Passwort.';

  @override
  String get authErrorInvalidResponse =>
      'Der Server hat keine gültige Audiobookshelf-Antwort geliefert.';

  @override
  String get authErrorUnknown =>
      'Bei der Verbindung zum Server ist ein Fehler aufgetreten.';

  @override
  String get diagnosticsTitle => 'Diagnose';

  @override
  String get diagnosticsFilterAll => 'Alle';

  @override
  String get diagnosticsFilterInfo => 'Info+';

  @override
  String get diagnosticsFilterWarning => 'Warnung+';

  @override
  String get diagnosticsFilterError => 'Fehler';

  @override
  String get diagnosticsExportTooltip => 'Protokolle exportieren';

  @override
  String get diagnosticsClearTooltip => 'Protokolle löschen';

  @override
  String get diagnosticsEmpty =>
      'Keine Diagnoseprotokolle entsprechen diesem Filter.';

  @override
  String get diagnosticsExportEmpty =>
      'Es gibt noch keine Protokolle zum Exportieren.';

  @override
  String get diagnosticsExportFailed =>
      'Diagnoseprotokolle konnten nicht exportiert werden.';

  @override
  String get playerTitle => 'Läuft gerade';

  @override
  String get playerNoActiveBook => 'Gerade läuft nichts';

  @override
  String get playerNoActiveBookBody =>
      'Wähle ein Hörbuch aus deiner Bibliothek, um zuzuhören.';

  @override
  String get playerPlay => 'Abspielen';

  @override
  String get playerPause => 'Pause';

  @override
  String playerRewindSeconds(int seconds) {
    return '$seconds s zurück';
  }

  @override
  String playerForwardSeconds(int seconds) {
    return '$seconds s vor';
  }

  @override
  String get playerPreviousChapter => 'Vorheriges Kapitel';

  @override
  String get playerNextChapter => 'Nächstes Kapitel';

  @override
  String get playerScrubChapter => 'Kapitel';

  @override
  String get playerScrubBook => 'Ganzes Buch';

  @override
  String playerSpeedLabel(String speed) {
    return '${speed}x';
  }

  @override
  String get playerSpeedSheetTitle => 'Wiedergabegeschwindigkeit';

  @override
  String get playerSkipSilenceLabel => 'Stille überspringen';

  @override
  String get playerSkipSilenceSubtitle =>
      'Lange Pausen beim Vorlesen verkürzen';

  @override
  String get playerSleepTimerLabel => 'Sleep-Timer';

  @override
  String get playerSleepOff => 'Aus';

  @override
  String get playerSleepEndOfChapter => 'Kapitelende';

  @override
  String playerSleepMinutes(int minutes) {
    return '$minutes Min.';
  }

  @override
  String playerSleepGraceHint(int minutes) {
    return 'Schütteln für +$minutes Min.';
  }

  @override
  String get playerChaptersLabel => 'Kapitel';

  @override
  String get playerBookmarksLabel => 'Lesezeichen';

  @override
  String get playerAddBookmark => 'Lesezeichen hinzufügen';

  @override
  String get playerBookmarkTitleLabel => 'Lesezeichentitel';

  @override
  String get playerBookmarkNoteLabel => 'Notiz (optional)';

  @override
  String get playerSaveBookmark => 'Lesezeichen speichern';

  @override
  String get playerNoBookmarks =>
      'Noch keine Lesezeichen für dieses Buch gespeichert.';

  @override
  String get playerHistoryLabel => 'Verlauf';

  @override
  String get playerNoHistory => 'Noch keine Wiedergabesprünge aufgezeichnet.';

  @override
  String playerSmartRewindApplied(int seconds) {
    return 'Beim Fortsetzen um $seconds s zurückgespult';
  }

  @override
  String get playerStreamDirect => 'Direktstream';

  @override
  String get playerStreamHls => 'HLS-Transkodierung';

  @override
  String get playerBuffering => 'Puffern…';

  @override
  String get playerPlaybackError =>
      'Audiowiedergabe konnte nicht gestartet werden.';

  @override
  String get playerHistoryReasonPlay => 'Gestartet';

  @override
  String get playerHistoryReasonSeek => 'Gespult';

  @override
  String get playerHistoryReasonChapter => 'Kapitel';

  @override
  String get playerHistoryReasonPause => 'Pausiert';

  @override
  String get playerHistoryReasonRewind => 'Intelligenter Rücklauf';

  @override
  String get playerHistoryReasonBookmark => 'Lesezeichen';

  @override
  String get playerStreamLocal => 'Heruntergeladen';

  @override
  String downloadsStorageUsed(String size) {
    return '$size auf Gerät belegt';
  }

  @override
  String get downloadsWifiOnlyTitle => 'Nur über Wi-Fi laden';

  @override
  String get downloadsWifiOnlySubtitle =>
      'Übertragungen im Mobilfunknetz automatisch pausieren';

  @override
  String get downloadsAutoDeleteTitle => 'Beendete Bücher automatisch löschen';

  @override
  String get downloadsAutoDeleteSubtitle =>
      'Heruntergeladene Dateien nach Abschluss eines Hörbuchs entfernen';

  @override
  String get downloadsClearAll => 'Alle löschen';

  @override
  String get downloadsStatusQueued => 'Warteschlange';

  @override
  String get downloadsStatusDownloading => 'Lädt herunter';

  @override
  String get downloadsStatusPaused => 'Pausiert';

  @override
  String get downloadsStatusCompleted => 'Heruntergeladen';

  @override
  String get downloadsStatusFailed => 'Fehlgeschlagen';

  @override
  String get downloadsWaitingForWifi => 'Warte auf Wi-Fi';

  @override
  String get downloadsPause => 'Pause';

  @override
  String get downloadsResume => 'Fortsetzen';

  @override
  String get downloadsRetry => 'Erneut versuchen';

  @override
  String get downloadsDelete => 'Löschen';

  @override
  String get downloadsDeleteTitle => 'Offline-Dateien entfernen?';

  @override
  String get downloadsDeleteBody =>
      'Dadurch wird das heruntergeladene Audio von diesem Gerät gelöscht, ohne deinen Audiobookshelf-Server zu beeinflussen.';

  @override
  String get downloadsCancel => 'Abbrechen';

  @override
  String syncPendingBadge(int count) {
    return '$count Synchronisierung(en) ausstehend';
  }

  @override
  String get syncNow => 'Jetzt synchronisieren';

  @override
  String get syncConflictBannerTitle => 'Fortschrittskonflikt erkannt';

  @override
  String syncConflictBannerSubtitle(int count) {
    return '$count Hörbuch/Hörbücher haben auf diesem Gerät und auf dem Server neueren Fortschritt.';
  }

  @override
  String get syncConflictResolve => 'Lösen';

  @override
  String get syncConflictSheetTitle => 'Hörposition wählen';

  @override
  String get syncConflictDeviceLabel => 'Dieses Gerät';

  @override
  String get syncConflictServerLabel => 'Server';

  @override
  String get syncConflictKeepDevice => 'Geräteposition behalten';

  @override
  String get syncConflictUseServer => 'Serverposition verwenden';
}
