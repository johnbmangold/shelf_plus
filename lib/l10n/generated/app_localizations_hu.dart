// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appTitle => 'Shelf Plus';

  @override
  String get navHome => 'Kezdőlap';

  @override
  String get navLibrary => 'Könyvtár';

  @override
  String get navDownloads => 'Letöltések';

  @override
  String get navSettings => 'Beállítások';

  @override
  String get homeEmptyTitle => 'A hangoskönyves polcod';

  @override
  String get homeEmptySubtitle =>
      'Húzd lefelé az Audiobookshelf könyvtárad szinkronizálásához és a hallgatás megkezdéséhez.';

  @override
  String get homeContinueListening => 'Hallgatás folytatása';

  @override
  String get homeInProgress => 'Folyamatban';

  @override
  String get homeRecentlyAdded => 'Nemrég hozzáadva';

  @override
  String get homeOfflineBanner =>
      'Offline — gyorsítótárazott könyvtár megjelenítése';

  @override
  String get homeSyncTooltip => 'Könyvtár szinkronizálása';

  @override
  String bookTimeLeft(String time) {
    return '$time van hátra';
  }

  @override
  String get bookFinished => 'Befejezve';

  @override
  String get libraryEmptyTitle => 'Könyvtárböngésző';

  @override
  String get libraryEmptySubtitle =>
      'Szinkronizáld az Audiobookshelf szervered a könyvek, sorozatok, szerzők és gyűjtemények böngészéséhez.';

  @override
  String get librarySearchHint =>
      'Címek, szerzők, narrátorok, sorozatok keresése…';

  @override
  String get libraryTabBooks => 'Könyvek';

  @override
  String get libraryTabSeries => 'Sorozatok';

  @override
  String get libraryTabAuthors => 'Szerzők';

  @override
  String get libraryTabCollections => 'Gyűjtemények';

  @override
  String get librarySortAndFilter => 'Rendezés és szűrés';

  @override
  String get librarySortLabel => 'Rendezés';

  @override
  String get libraryFilterLabel => 'Szűrés';

  @override
  String get librarySortTitleAsc => 'Cím A–Z';

  @override
  String get librarySortAuthorAsc => 'Szerző A–Z';

  @override
  String get librarySortAddedDesc => 'Nemrég hozzáadva';

  @override
  String get librarySortDurationDesc => 'Leghosszabb elöl';

  @override
  String get libraryFilterAll => 'Összes';

  @override
  String get libraryFilterInProgress => 'Folyamatban';

  @override
  String get libraryFilterFinished => 'Befejezett';

  @override
  String get libraryFilterNotStarted => 'El nem kezdett';

  @override
  String libraryBookCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count könyv',
      one: '1 könyv',
    );
    return '$_temp0';
  }

  @override
  String get libraryNoMatches => 'Nincs egyező könyv';

  @override
  String get libraryNoGroups => 'Még nincs itt semmi';

  @override
  String get libraryClearSearchTooltip => 'Keresés törlése';

  @override
  String get bookDetailOverviewTab => 'Áttekintés';

  @override
  String get bookDetailChaptersTab => 'Fejezetek';

  @override
  String get bookDetailBookmarksTab => 'Könyvjelzők';

  @override
  String bookDetailNarratedBy(String narrators) {
    return 'Narrátor: $narrators';
  }

  @override
  String get bookDetailPlay => 'Lejátszás';

  @override
  String get bookDetailResume => 'Folytatás';

  @override
  String get bookDetailDownload => 'Letöltés';

  @override
  String get bookDetailPlaybackPhase3 => 'A hanglejátszás a 3. fázisban indul.';

  @override
  String get bookDetailDownloadPhase4 =>
      'Az offline letöltések a 4. fázisban indulnak.';

  @override
  String get bookDetailNoChapters => 'Nincsenek elérhető fejezetek';

  @override
  String get bookDetailNoBookmarks => 'Még nincsenek könyvjelzők';

  @override
  String get bookDetailNoDescription =>
      'Ehhez a hangoskönyvhöz nem érhető el leírás.';

  @override
  String get bookDetailPublisherLabel => 'Kiadó';

  @override
  String get bookDetailPublishedLabel => 'Megjelent';

  @override
  String get bookDetailGenresLabel => 'Műfajok';

  @override
  String get bookDetailSeriesLabel => 'Sorozat';

  @override
  String get bookDetailNotFound =>
      'A könyv nem található a helyi gyorsítótárban.';

  @override
  String get downloadsEmptyTitle => 'Offline letöltések';

  @override
  String get downloadsEmptySubtitle =>
      'A háttérben futó átvitelek és a letöltött hangoskönyvek itt jelennek meg.';

  @override
  String get miniPlayerIdleTitle => 'Semmi sem szól';

  @override
  String get miniPlayerIdleSubtitle => 'Válassz egy könyvet a hallgatáshoz';

  @override
  String get settingsAppearance => 'Megjelenés';

  @override
  String get settingsThemeLabel => 'Téma';

  @override
  String get themeSystem => 'Rendszer';

  @override
  String get themeLight => 'Világos';

  @override
  String get themeDark => 'Sötét';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsEnvironment => 'Környezet';

  @override
  String get settingsFlavorLabel => 'Változat';

  @override
  String get settingsBundleIdLabel => 'Alkalmazásazonosító';

  @override
  String get settingsServerSection => 'Szerver és fiók';

  @override
  String get settingsSignOut => 'Kijelentkezés';

  @override
  String get settingsSignOutTitle => 'Kijelentkezel a szerverről?';

  @override
  String get settingsSignOutBody =>
      'A szerverhez mentett hitelesítő adatok és egyéni proxyfejlécek törlődnek erről az eszközről.';

  @override
  String get settingsCancel => 'Mégse';

  @override
  String get settingsDiagnosticsTitle => 'Diagnosztika';

  @override
  String get settingsDiagnosticsSubtitle =>
      'Kitakart naplók megtekintése és exportálása';

  @override
  String settingsVersionPrefix(String version) {
    return 'Szerver v$version';
  }

  @override
  String get loginTitle => 'Csatlakozás az Audiobookshelfhez';

  @override
  String get loginSubtitle =>
      'Add meg a szerver URL-jét és a fiókod adatait. Az alútvonalak és a fordított proxy fejlécek támogatottak.';

  @override
  String get loginServerUrlLabel => 'Szerver URL';

  @override
  String get loginServerUrlHint => 'https://books.example.com';

  @override
  String get loginServerUrlRequired =>
      'Adj meg egy érvényes http:// vagy https:// szerver URL-t.';

  @override
  String get loginTestConnection => 'Kapcsolat tesztelése';

  @override
  String get loginTestingConnection => 'Tesztelés…';

  @override
  String loginConnectedBadge(String version) {
    return 'Csatlakozva ($version)';
  }

  @override
  String get loginConnectedNoVersion => 'A szerver elérhető';

  @override
  String get loginCustomHeadersTitle => 'Egyéni HTTP-fejlécek';

  @override
  String get loginCustomHeadersSubtitle =>
      'Opcionális fejlécek Cloudflare Accesshez vagy fordított proxykhoz';

  @override
  String get loginAddHeader => 'Fejléc hozzáadása';

  @override
  String get loginHeaderNameLabel => 'Fejléc neve';

  @override
  String get loginHeaderValueLabel => 'Fejléc értéke';

  @override
  String get loginRemoveHeaderTooltip => 'Fejléc eltávolítása';

  @override
  String get loginUsernameLabel => 'Felhasználónév';

  @override
  String get loginUsernameRequired => 'Add meg a felhasználóneved.';

  @override
  String get loginPasswordLabel => 'Jelszó';

  @override
  String get loginPasswordRequired => 'Add meg a jelszavad.';

  @override
  String get loginTogglePasswordTooltip => 'Jelszó láthatóságának váltása';

  @override
  String get loginSignIn => 'Bejelentkezés';

  @override
  String get loginSigningIn => 'Bejelentkezés…';

  @override
  String get loginViewDiagnostics => 'Diagnosztikai naplók megtekintése';

  @override
  String get loginSessionExpiredNotice =>
      'A munkameneted lejárt. Jelentkezz be újra az újracsatlakozáshoz.';

  @override
  String get authErrorInvalidUrl =>
      'A szerver URL érvénytelen. Add meg a http:// vagy https:// előtagot.';

  @override
  String get authErrorUnreachable =>
      'Nem sikerült elérni a szervert. Ellenőrizd az URL-t és a hálózati kapcsolatot.';

  @override
  String get authErrorTimeout => 'Időtúllépés a szerverre várakozás közben.';

  @override
  String get authErrorTls =>
      'A TLS-tanúsítvány ellenőrzése sikertelen. Ellenőrizd a szerver HTTPS-tanúsítványát.';

  @override
  String get authErrorProxyAuth =>
      'Egy proxy vagy átjáró blokkolta a hozzáférést. Ellenőrizd az egyéni HTTP-fejléceket.';

  @override
  String get authErrorCredentials => 'Érvénytelen felhasználónév vagy jelszó.';

  @override
  String get authErrorInvalidResponse =>
      'A szerver nem érvényes Audiobookshelf választ adott vissza.';

  @override
  String get authErrorUnknown => 'Hiba történt a szerver elérésekor.';

  @override
  String get diagnosticsTitle => 'Diagnosztika';

  @override
  String get diagnosticsFilterAll => 'Összes';

  @override
  String get diagnosticsFilterInfo => 'Infó+';

  @override
  String get diagnosticsFilterWarning => 'Figyelmeztetés+';

  @override
  String get diagnosticsFilterError => 'Hibák';

  @override
  String get diagnosticsExportTooltip => 'Naplók exportálása';

  @override
  String get diagnosticsClearTooltip => 'Naplók törlése';

  @override
  String get diagnosticsEmpty =>
      'Nincs a szűrőnek megfelelő diagnosztikai napló.';

  @override
  String get diagnosticsExportEmpty => 'Még nincs exportálható napló.';

  @override
  String get diagnosticsExportFailed =>
      'Nem sikerült exportálni a diagnosztikai naplókat.';

  @override
  String get playerTitle => 'Most szól';

  @override
  String get playerNoActiveBook => 'Jelenleg semmi sem szól';

  @override
  String get playerNoActiveBookBody =>
      'Válassz egy hangoskönyvet a könyvtáradból a hallgatás megkezdéséhez.';

  @override
  String get playerPlay => 'Lejátszás';

  @override
  String get playerPause => 'Szünet';

  @override
  String playerRewindSeconds(int seconds) {
    return 'Vissza $seconds mp';
  }

  @override
  String playerForwardSeconds(int seconds) {
    return 'Előre $seconds mp';
  }

  @override
  String get playerPreviousChapter => 'Előző fejezet';

  @override
  String get playerNextChapter => 'Következő fejezet';

  @override
  String get playerScrubChapter => 'Fejezet';

  @override
  String get playerScrubBook => 'Teljes könyv';

  @override
  String playerSpeedLabel(String speed) {
    return '${speed}x';
  }

  @override
  String get playerSpeedSheetTitle => 'Lejátszási sebesség';

  @override
  String get playerSkipSilenceLabel => 'Csend átugrása';

  @override
  String get playerSkipSilenceSubtitle =>
      'Hosszú szünetek lerövidítése a narráció közben';

  @override
  String get playerSleepTimerLabel => 'Elalváskapcsoló';

  @override
  String get playerSleepOff => 'Ki';

  @override
  String get playerSleepEndOfChapter => 'Fejezet vége';

  @override
  String playerSleepMinutes(int minutes) {
    return '$minutes perc';
  }

  @override
  String playerSleepGraceHint(int minutes) {
    return 'Rázd meg a telefont +$minutes perc hosszabbításhoz';
  }

  @override
  String get playerChaptersLabel => 'Fejezetek';

  @override
  String get playerBookmarksLabel => 'Könyvjelzők';

  @override
  String get playerAddBookmark => 'Könyvjelző hozzáadása';

  @override
  String get playerBookmarkTitleLabel => 'Könyvjelző címe';

  @override
  String get playerBookmarkNoteLabel => 'Megjegyzés (opcionális)';

  @override
  String get playerSaveBookmark => 'Könyvjelző mentése';

  @override
  String get playerNoBookmarks =>
      'Ehhez a könyvhöz még nincs mentett könyvjelző.';

  @override
  String get playerHistoryLabel => 'Előzmények';

  @override
  String get playerNoHistory => 'Még nincs rögzített lejátszási ugrás.';

  @override
  String playerSmartRewindApplied(int seconds) {
    return 'Folytatáskor $seconds mp visszatekerve';
  }

  @override
  String get playerStreamDirect => 'Közvetlen adatfolyam';

  @override
  String get playerStreamHls => 'HLS átkódolás';

  @override
  String get playerBuffering => 'Pufferelés…';

  @override
  String get playerPlaybackError => 'Nem sikerült elindítani a hanglejátszást.';

  @override
  String get playerHistoryReasonPlay => 'Elindítva';

  @override
  String get playerHistoryReasonSeek => 'Tekerés';

  @override
  String get playerHistoryReasonChapter => 'Fejezet';

  @override
  String get playerHistoryReasonPause => 'Szüneteltetve';

  @override
  String get playerHistoryReasonRewind => 'Okos visszatekerés';

  @override
  String get playerHistoryReasonBookmark => 'Könyvjelző';

  @override
  String get playerStreamLocal => 'Letöltve';

  @override
  String downloadsStorageUsed(String size) {
    return '$size használva az eszközön';
  }

  @override
  String get downloadsWifiOnlyTitle => 'Letöltés csak Wi-Fi-n';

  @override
  String get downloadsWifiOnlySubtitle =>
      'Átvitelek automatikus szüneteltetése mobilhálózaton';

  @override
  String get downloadsAutoDeleteTitle =>
      'Befejezett könyvek automatikus törlése';

  @override
  String get downloadsAutoDeleteSubtitle =>
      'Letöltött fájlok eltávolítása a hangoskönyv befejezése után';

  @override
  String get downloadsClearAll => 'Összes törlése';

  @override
  String get downloadsStatusQueued => 'Várakozik';

  @override
  String get downloadsStatusDownloading => 'Letöltés';

  @override
  String get downloadsStatusPaused => 'Szüneteltetve';

  @override
  String get downloadsStatusCompleted => 'Letöltve';

  @override
  String get downloadsStatusFailed => 'Sikertelen';

  @override
  String get downloadsWaitingForWifi => 'Várakozás Wi-Fi-re';

  @override
  String get downloadsPause => 'Szünet';

  @override
  String get downloadsResume => 'Folytatás';

  @override
  String get downloadsRetry => 'Újra';

  @override
  String get downloadsDelete => 'Törlés';

  @override
  String get downloadsDeleteTitle => 'Eltávolítod az offline fájlokat?';

  @override
  String get downloadsDeleteBody =>
      'Ez törli a letöltött hanganyagot erről az eszközről anélkül, hogy érintené az Audiobookshelf szervered.';

  @override
  String get downloadsCancel => 'Mégse';

  @override
  String syncPendingBadge(int count) {
    return '$count szinkronizálásra vár';
  }

  @override
  String get syncNow => 'Szinkronizálás most';

  @override
  String get syncConflictBannerTitle => 'Haladási ütközés észlelve';

  @override
  String syncConflictBannerSubtitle(int count) {
    return '$count hangoskönyvnek újabb haladása van ezen az eszközön és a szerveren is.';
  }

  @override
  String get syncConflictResolve => 'Feloldás';

  @override
  String get syncConflictSheetTitle => 'Hallgatási pozíció kiválasztása';

  @override
  String get syncConflictDeviceLabel => 'Ez az eszköz';

  @override
  String get syncConflictServerLabel => 'Szerver';

  @override
  String get syncConflictKeepDevice => 'Eszköz pozíciójának megtartása';

  @override
  String get syncConflictUseServer => 'Szerver pozíciójának használata';
}
