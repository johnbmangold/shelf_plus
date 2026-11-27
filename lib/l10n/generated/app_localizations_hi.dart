// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Shelf Plus';

  @override
  String get navHome => 'होम';

  @override
  String get navLibrary => 'लाइब्रेरी';

  @override
  String get navDownloads => 'डाउनलोड';

  @override
  String get navSettings => 'सेटिंग्स';

  @override
  String get homeEmptyTitle => 'आपकी सुनने की शेल्फ';

  @override
  String get homeEmptySubtitle =>
      'अपनी Audiobookshelf लाइब्रेरी सिंक करने और सुनना शुरू करने के लिए नीचे खींचें।';

  @override
  String get homeContinueListening => 'सुनना जारी रखें';

  @override
  String get homeInProgress => 'जारी है';

  @override
  String get homeRecentlyAdded => 'हाल ही में जोड़े गए';

  @override
  String get homeOfflineBanner => 'ऑफ़लाइन — कैश की गई लाइब्रेरी दिख रही है';

  @override
  String get homeSyncTooltip => 'लाइब्रेरी सिंक करें';

  @override
  String bookTimeLeft(String time) {
    return '$time शेष';
  }

  @override
  String get bookFinished => 'समाप्त';

  @override
  String get libraryEmptyTitle => 'लाइब्रेरी ब्राउज़र';

  @override
  String get libraryEmptySubtitle =>
      'किताबें, सीरीज़, लेखक और कलेक्शन देखने के लिए अपना Audiobookshelf सर्वर सिंक करें।';

  @override
  String get librarySearchHint => 'शीर्षक, लेखक, वाचक, सीरीज़ खोजें…';

  @override
  String get libraryTabBooks => 'किताबें';

  @override
  String get libraryTabSeries => 'सीरीज़';

  @override
  String get libraryTabAuthors => 'लेखक';

  @override
  String get libraryTabCollections => 'कलेक्शन';

  @override
  String get librarySortAndFilter => 'क्रम और फ़िल्टर';

  @override
  String get librarySortLabel => 'क्रमबद्ध करें';

  @override
  String get libraryFilterLabel => 'फ़िल्टर';

  @override
  String get librarySortTitleAsc => 'शीर्षक A–Z';

  @override
  String get librarySortAuthorAsc => 'लेखक A–Z';

  @override
  String get librarySortAddedDesc => 'हाल ही में जोड़े गए';

  @override
  String get librarySortDurationDesc => 'सबसे लंबी पहले';

  @override
  String get libraryFilterAll => 'सभी';

  @override
  String get libraryFilterInProgress => 'जारी है';

  @override
  String get libraryFilterFinished => 'समाप्त';

  @override
  String get libraryFilterNotStarted => 'शुरू नहीं हुई';

  @override
  String libraryBookCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count किताबें',
      one: '1 किताब',
    );
    return '$_temp0';
  }

  @override
  String get libraryNoMatches => 'कोई मेल खाती किताब नहीं';

  @override
  String get libraryNoGroups => 'यहाँ अभी कुछ नहीं है';

  @override
  String get libraryClearSearchTooltip => 'खोज साफ़ करें';

  @override
  String get bookDetailOverviewTab => 'सारांश';

  @override
  String get bookDetailChaptersTab => 'अध्याय';

  @override
  String get bookDetailBookmarksTab => 'बुकमार्क';

  @override
  String bookDetailNarratedBy(String narrators) {
    return 'वाचक: $narrators';
  }

  @override
  String get bookDetailPlay => 'चलाएँ';

  @override
  String get bookDetailResume => 'जारी रखें';

  @override
  String get bookDetailDownload => 'डाउनलोड करें';

  @override
  String get bookDetailPlaybackPhase3 => 'ऑडियो प्लेबैक चरण 3 में शुरू होगा।';

  @override
  String get bookDetailDownloadPhase4 => 'ऑफ़लाइन डाउनलोड चरण 4 में शुरू होगा।';

  @override
  String get bookDetailNoChapters => 'कोई अध्याय उपलब्ध नहीं है';

  @override
  String get bookDetailNoBookmarks => 'अभी कोई बुकमार्क नहीं';

  @override
  String get bookDetailNoDescription =>
      'इस ऑडियोबुक के लिए कोई विवरण उपलब्ध नहीं है।';

  @override
  String get bookDetailPublisherLabel => 'प्रकाशक';

  @override
  String get bookDetailPublishedLabel => 'प्रकाशित';

  @override
  String get bookDetailGenresLabel => 'शैलियाँ';

  @override
  String get bookDetailSeriesLabel => 'सीरीज़';

  @override
  String get bookDetailNotFound => 'स्थानीय कैश में किताब नहीं मिली।';

  @override
  String get downloadsEmptyTitle => 'ऑफ़लाइन डाउनलोड';

  @override
  String get downloadsEmptySubtitle =>
      'बैकग्राउंड ट्रांसफ़र और डाउनलोड की गई ऑडियोबुक यहाँ दिखाई देंगी।';

  @override
  String get miniPlayerIdleTitle => 'कुछ नहीं चल रहा';

  @override
  String get miniPlayerIdleSubtitle => 'सुनना शुरू करने के लिए कोई किताब चुनें';

  @override
  String get settingsAppearance => 'दिखावट';

  @override
  String get settingsThemeLabel => 'थीम';

  @override
  String get themeSystem => 'सिस्टम';

  @override
  String get themeLight => 'लाइट';

  @override
  String get themeDark => 'डार्क';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsEnvironment => 'वातावरण';

  @override
  String get settingsFlavorLabel => 'फ़्लेवर';

  @override
  String get settingsBundleIdLabel => 'ऐप ID';

  @override
  String get settingsServerSection => 'सर्वर और खाता';

  @override
  String get settingsSignOut => 'साइन आउट';

  @override
  String get settingsSignOutTitle => 'सर्वर से साइन आउट करें?';

  @override
  String get settingsSignOutBody =>
      'इस सर्वर के लिए सहेजे गए क्रेडेंशियल और कस्टम प्रॉक्सी हेडर इस डिवाइस से हटा दिए जाएँगे।';

  @override
  String get settingsCancel => 'रद्द करें';

  @override
  String get settingsDiagnosticsTitle => 'डायग्नोस्टिक्स';

  @override
  String get settingsDiagnosticsSubtitle =>
      'संपादित लॉग देखें और एक्सपोर्ट करें';

  @override
  String settingsVersionPrefix(String version) {
    return 'सर्वर v$version';
  }

  @override
  String get loginTitle => 'Audiobookshelf से कनेक्ट करें';

  @override
  String get loginSubtitle =>
      'अपना सर्वर URL और खाता क्रेडेंशियल दर्ज करें। सबपाथ और रिवर्स-प्रॉक्सी हेडर समर्थित हैं।';

  @override
  String get loginServerUrlLabel => 'सर्वर URL';

  @override
  String get loginServerUrlHint => 'https://books.example.com';

  @override
  String get loginServerUrlRequired =>
      'एक मान्य http:// या https:// सर्वर URL दर्ज करें।';

  @override
  String get loginTestConnection => 'कनेक्शन जांचें';

  @override
  String get loginTestingConnection => 'जांच हो रही है…';

  @override
  String loginConnectedBadge(String version) {
    return 'कनेक्टेड ($version)';
  }

  @override
  String get loginConnectedNoVersion => 'सर्वर उपलब्ध है';

  @override
  String get loginCustomHeadersTitle => 'कस्टम HTTP हेडर';

  @override
  String get loginCustomHeadersSubtitle =>
      'Cloudflare Access या रिवर्स प्रॉक्सी के लिए वैकल्पिक हेडर';

  @override
  String get loginAddHeader => 'हेडर जोड़ें';

  @override
  String get loginHeaderNameLabel => 'हेडर नाम';

  @override
  String get loginHeaderValueLabel => 'हेडर मान';

  @override
  String get loginRemoveHeaderTooltip => 'हेडर हटाएँ';

  @override
  String get loginUsernameLabel => 'उपयोगकर्ता नाम';

  @override
  String get loginUsernameRequired => 'अपना उपयोगकर्ता नाम दर्ज करें।';

  @override
  String get loginPasswordLabel => 'पासवर्ड';

  @override
  String get loginPasswordRequired => 'अपना पासवर्ड दर्ज करें।';

  @override
  String get loginTogglePasswordTooltip => 'पासवर्ड दिखाएँ या छिपाएँ';

  @override
  String get loginSignIn => 'साइन इन करें';

  @override
  String get loginSigningIn => 'साइन इन हो रहा है…';

  @override
  String get loginViewDiagnostics => 'डायग्नोस्टिक लॉग देखें';

  @override
  String get loginSessionExpiredNotice =>
      'आपका सत्र समाप्त हो गया। फिर से कनेक्ट करने के लिए साइन इन करें।';

  @override
  String get authErrorInvalidUrl =>
      'सर्वर URL अमान्य है। http:// या https:// शामिल करें।';

  @override
  String get authErrorUnreachable =>
      'सर्वर तक नहीं पहुँच सके। URL और नेटवर्क कनेक्शन जांचें।';

  @override
  String get authErrorTimeout =>
      'सर्वर की प्रतीक्षा करते समय कनेक्शन टाइम आउट हो गया।';

  @override
  String get authErrorTls =>
      'TLS प्रमाणपत्र जांच विफल। अपने सर्वर का HTTPS प्रमाणपत्र सत्यापित करें।';

  @override
  String get authErrorProxyAuth =>
      'प्रॉक्सी या गेटवे द्वारा पहुँच अवरुद्ध की गई। अपने कस्टम HTTP हेडर जांचें।';

  @override
  String get authErrorCredentials => 'अमान्य उपयोगकर्ता नाम या पासवर्ड।';

  @override
  String get authErrorInvalidResponse =>
      'सर्वर ने मान्य Audiobookshelf प्रतिक्रिया नहीं लौटाई।';

  @override
  String get authErrorUnknown => 'सर्वर से संपर्क करते समय कुछ गलत हो गया।';

  @override
  String get diagnosticsTitle => 'डायग्नोस्टिक्स';

  @override
  String get diagnosticsFilterAll => 'सभी';

  @override
  String get diagnosticsFilterInfo => 'जानकारी+';

  @override
  String get diagnosticsFilterWarning => 'चेतावनी+';

  @override
  String get diagnosticsFilterError => 'त्रुटियाँ';

  @override
  String get diagnosticsExportTooltip => 'लॉग एक्सपोर्ट करें';

  @override
  String get diagnosticsClearTooltip => 'लॉग साफ़ करें';

  @override
  String get diagnosticsEmpty =>
      'इस फ़िल्टर से मेल खाने वाला कोई डायग्नोस्टिक लॉग नहीं है।';

  @override
  String get diagnosticsExportEmpty =>
      'एक्सपोर्ट करने के लिए अभी कोई लॉग नहीं है।';

  @override
  String get diagnosticsExportFailed =>
      'डायग्नोस्टिक लॉग एक्सपोर्ट नहीं हो सके।';

  @override
  String get playerTitle => 'अभी चल रहा है';

  @override
  String get playerNoActiveBook => 'अभी कुछ नहीं चल रहा है';

  @override
  String get playerNoActiveBookBody =>
      'सुनना शुरू करने के लिए अपनी लाइब्रेरी से कोई भी ऑडियोबुक चुनें।';

  @override
  String get playerPlay => 'चलाएँ';

  @override
  String get playerPause => 'रोकें';

  @override
  String playerRewindSeconds(int seconds) {
    return '$seconds सेकंड पीछे';
  }

  @override
  String playerForwardSeconds(int seconds) {
    return '$seconds सेकंड आगे';
  }

  @override
  String get playerPreviousChapter => 'पिछला अध्याय';

  @override
  String get playerNextChapter => 'अगला अध्याय';

  @override
  String get playerScrubChapter => 'अध्याय';

  @override
  String get playerScrubBook => 'पूरी किताब';

  @override
  String playerSpeedLabel(String speed) {
    return '${speed}x';
  }

  @override
  String get playerSpeedSheetTitle => 'प्लेबैक गति';

  @override
  String get playerSkipSilenceLabel => 'सन्नाटा छोड़ें';

  @override
  String get playerSkipSilenceSubtitle => 'वाचन के बीच लंबे विराम को कम करें';

  @override
  String get playerSleepTimerLabel => 'स्लीप टाइमर';

  @override
  String get playerSleepOff => 'बंद';

  @override
  String get playerSleepEndOfChapter => 'अध्याय के अंत में';

  @override
  String playerSleepMinutes(int minutes) {
    return '$minutes मिनट';
  }

  @override
  String playerSleepGraceHint(int minutes) {
    return '+$minutes मिनट बढ़ाने के लिए फ़ोन हिलाएँ';
  }

  @override
  String get playerChaptersLabel => 'अध्याय';

  @override
  String get playerBookmarksLabel => 'बुकमार्क';

  @override
  String get playerAddBookmark => 'बुकमार्क जोड़ें';

  @override
  String get playerBookmarkTitleLabel => 'बुकमार्क शीर्षक';

  @override
  String get playerBookmarkNoteLabel => 'नोट (वैकल्पिक)';

  @override
  String get playerSaveBookmark => 'बुकमार्क सहेजें';

  @override
  String get playerNoBookmarks =>
      'इस किताब के लिए अभी कोई बुकमार्क सहेजा नहीं गया है।';

  @override
  String get playerHistoryLabel => 'इतिहास';

  @override
  String get playerNoHistory => 'अभी तक कोई प्लेबैक जंप दर्ज नहीं हुआ है।';

  @override
  String playerSmartRewindApplied(int seconds) {
    return 'फिर से शुरू करने पर $seconds सेकंड पीछे किया गया';
  }

  @override
  String get playerStreamDirect => 'डायरेक्ट स्ट्रीम';

  @override
  String get playerStreamHls => 'HLS ट्रांसकोड';

  @override
  String get playerBuffering => 'बफ़र हो रहा है…';

  @override
  String get playerPlaybackError => 'ऑडियो प्लेबैक शुरू नहीं हो सका।';

  @override
  String get playerHistoryReasonPlay => 'शुरू किया';

  @override
  String get playerHistoryReasonSeek => 'स्क्रब किया';

  @override
  String get playerHistoryReasonChapter => 'अध्याय';

  @override
  String get playerHistoryReasonPause => 'रोका गया';

  @override
  String get playerHistoryReasonRewind => 'स्मार्ट रिवाइंड';

  @override
  String get playerHistoryReasonBookmark => 'बुकमार्क';

  @override
  String get playerStreamLocal => 'डाउनलोड किया गया';

  @override
  String downloadsStorageUsed(String size) {
    return 'डिवाइस पर $size उपयोग किया गया';
  }

  @override
  String get downloadsWifiOnlyTitle => 'केवल Wi-Fi पर डाउनलोड करें';

  @override
  String get downloadsWifiOnlySubtitle =>
      'मोबाइल नेटवर्क पर ट्रांसफ़र अपने आप रोकें';

  @override
  String get downloadsAutoDeleteTitle => 'समाप्त किताबें स्वतः हटाएँ';

  @override
  String get downloadsAutoDeleteSubtitle =>
      'ऑडियोबुक समाप्त होने पर डाउनलोड की गई फ़ाइलें हटाएँ';

  @override
  String get downloadsClearAll => 'सभी साफ़ करें';

  @override
  String get downloadsStatusQueued => 'कतार में';

  @override
  String get downloadsStatusDownloading => 'डाउनलोड हो रहा है';

  @override
  String get downloadsStatusPaused => 'रुका हुआ';

  @override
  String get downloadsStatusCompleted => 'डाउनलोड हो गया';

  @override
  String get downloadsStatusFailed => 'विफल';

  @override
  String get downloadsWaitingForWifi => 'Wi-Fi की प्रतीक्षा';

  @override
  String get downloadsPause => 'रोकें';

  @override
  String get downloadsResume => 'जारी रखें';

  @override
  String get downloadsRetry => 'पुनः प्रयास करें';

  @override
  String get downloadsDelete => 'हटाएँ';

  @override
  String get downloadsDeleteTitle => 'ऑफ़लाइन फ़ाइलें हटाएँ?';

  @override
  String get downloadsDeleteBody =>
      'यह आपके Audiobookshelf सर्वर को प्रभावित किए बिना इस डिवाइस से डाउनलोड किया गया ऑडियो हटा देता है।';

  @override
  String get downloadsCancel => 'रद्द करें';

  @override
  String syncPendingBadge(int count) {
    return '$count सिंक लंबित';
  }

  @override
  String get syncNow => 'अभी सिंक करें';

  @override
  String get syncConflictBannerTitle => 'प्रगति विरोधाभास मिला';

  @override
  String syncConflictBannerSubtitle(int count) {
    return '$count ऑडियोबुक में इस डिवाइस और सर्वर दोनों पर नई प्रगति है।';
  }

  @override
  String get syncConflictResolve => 'हल करें';

  @override
  String get syncConflictSheetTitle => 'सुनने की स्थिति चुनें';

  @override
  String get syncConflictDeviceLabel => 'यह डिवाइस';

  @override
  String get syncConflictServerLabel => 'सर्वर';

  @override
  String get syncConflictKeepDevice => 'डिवाइस की स्थिति रखें';

  @override
  String get syncConflictUseServer => 'सर्वर की स्थिति उपयोग करें';
}
