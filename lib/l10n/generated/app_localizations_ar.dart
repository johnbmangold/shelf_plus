// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Shelf Plus';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navLibrary => 'المكتبة';

  @override
  String get navDownloads => 'التنزيلات';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get homeEmptyTitle => 'رف الاستماع الخاص بك';

  @override
  String get homeEmptySubtitle =>
      'اسحب للأسفل لمزامنة مكتبة Audiobookshelf الخاصة بك وبدء الاستماع.';

  @override
  String get homeContinueListening => 'متابعة الاستماع';

  @override
  String get homeInProgress => 'قيد التقدم';

  @override
  String get homeRecentlyAdded => 'أُضيف مؤخراً';

  @override
  String get homeOfflineBanner => 'غير متصل — يتم عرض المكتبة المخزنة مؤقتاً';

  @override
  String get homeSyncTooltip => 'مزامنة المكتبة';

  @override
  String bookTimeLeft(String time) {
    return 'متبقي $time';
  }

  @override
  String get bookFinished => 'مكتمل';

  @override
  String get libraryEmptyTitle => 'متصفح المكتبة';

  @override
  String get libraryEmptySubtitle =>
      'زامن خادم Audiobookshelf الخاص بك لتصفح الكتب والسلاسل والمؤلفين والمجموعات.';

  @override
  String get librarySearchHint =>
      'ابحث عن العناوين، المؤلفين، الراوين، السلاسل…';

  @override
  String get libraryTabBooks => 'الكتب';

  @override
  String get libraryTabSeries => 'السلاسل';

  @override
  String get libraryTabAuthors => 'المؤلفون';

  @override
  String get libraryTabCollections => 'المجموعات';

  @override
  String get librarySortAndFilter => 'الفرز والتصفية';

  @override
  String get librarySortLabel => 'فرز حسب';

  @override
  String get libraryFilterLabel => 'تصفية';

  @override
  String get librarySortTitleAsc => 'العنوان أ–ي';

  @override
  String get librarySortAuthorAsc => 'المؤلف أ–ي';

  @override
  String get librarySortAddedDesc => 'أُضيف مؤخراً';

  @override
  String get librarySortDurationDesc => 'الأطول أولاً';

  @override
  String get libraryFilterAll => 'الكل';

  @override
  String get libraryFilterInProgress => 'قيد التقدم';

  @override
  String get libraryFilterFinished => 'مكتمل';

  @override
  String get libraryFilterNotStarted => 'لم يبدأ';

  @override
  String libraryBookCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count كتاب',
      many: '$count كتاباً',
      few: '$count كتب',
      two: 'كتابان',
      one: 'كتاب واحد',
      zero: '0 كتب',
    );
    return '$_temp0';
  }

  @override
  String get libraryNoMatches => 'لا توجد كتب مطابقة';

  @override
  String get libraryNoGroups => 'لا يوجد شيء هنا بعد';

  @override
  String get libraryClearSearchTooltip => 'مسح البحث';

  @override
  String get bookDetailOverviewTab => 'نظرة عامة';

  @override
  String get bookDetailChaptersTab => 'الفصول';

  @override
  String get bookDetailBookmarksTab => 'الإشارات المرجعية';

  @override
  String bookDetailNarratedBy(String narrators) {
    return 'بصوت $narrators';
  }

  @override
  String get bookDetailPlay => 'تشغيل';

  @override
  String get bookDetailResume => 'استئناف';

  @override
  String get bookDetailDownload => 'تنزيل';

  @override
  String get bookDetailPlaybackPhase3 => 'ينطلق تشغيل الصوت في المرحلة 3.';

  @override
  String get bookDetailDownloadPhase4 =>
      'تنطلق التنزيلات دون اتصال في المرحلة 4.';

  @override
  String get bookDetailNoChapters => 'لا توجد فصول متاحة';

  @override
  String get bookDetailNoBookmarks => 'لا توجد إشارات مرجعية بعد';

  @override
  String get bookDetailNoDescription => 'لا يتوفر ملخص لهذا الكتاب الصوتي.';

  @override
  String get bookDetailPublisherLabel => 'الناشر';

  @override
  String get bookDetailPublishedLabel => 'تاريخ النشر';

  @override
  String get bookDetailGenresLabel => 'التصنيفات';

  @override
  String get bookDetailSeriesLabel => 'السلسلة';

  @override
  String get bookDetailNotFound =>
      'لم يتم العثور على الكتاب في ذاكرة التخزين المحلية.';

  @override
  String get downloadsEmptyTitle => 'التنزيلات دون اتصال';

  @override
  String get downloadsEmptySubtitle =>
      'ستظهر هنا عمليات النقل في الخلفية والكتب الصوتية المنزلة.';

  @override
  String get miniPlayerIdleTitle => 'لا يوجد شيء قيد التشغيل';

  @override
  String get miniPlayerIdleSubtitle => 'اختر كتاباً لبدء الاستماع';

  @override
  String get settingsAppearance => 'المظهر';

  @override
  String get settingsThemeLabel => 'السمة';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsEnvironment => 'البيئة';

  @override
  String get settingsFlavorLabel => 'الإصدار';

  @override
  String get settingsBundleIdLabel => 'معرّف التطبيق';

  @override
  String get settingsServerSection => 'الخادم والحساب';

  @override
  String get settingsSignOut => 'تسجيل الخروج';

  @override
  String get settingsSignOutTitle => 'تسجيل الخروج من الخادم؟';

  @override
  String get settingsSignOutBody =>
      'سيتم إزالة بيانات الاعتماد المحفوظة ورؤوس الوكيل المخصصة لهذا الخادم من هذا الجهاز.';

  @override
  String get settingsCancel => 'إلغاء';

  @override
  String get settingsDiagnosticsTitle => 'التشخيصات';

  @override
  String get settingsDiagnosticsSubtitle => 'فحص السجلات المنقحة وتصديرها';

  @override
  String settingsVersionPrefix(String version) {
    return 'الخادم v$version';
  }

  @override
  String get loginTitle => 'الاتصال بـ Audiobookshelf';

  @override
  String get loginSubtitle =>
      'أدخل عنوان URL للخادم وبيانات اعتماد حسابك. يتم دعم المسارات الفرعية ورؤوس الوكيل العكسي.';

  @override
  String get loginServerUrlLabel => 'عنوان URL للخادم';

  @override
  String get loginServerUrlHint => 'https://books.example.com';

  @override
  String get loginServerUrlRequired =>
      'أدخل عنوان URL صالحاً للخادم يبدأ بـ http:// أو https://.';

  @override
  String get loginTestConnection => 'اختبار الاتصال';

  @override
  String get loginTestingConnection => 'جارٍ الاختبار…';

  @override
  String loginConnectedBadge(String version) {
    return 'متصل ($version)';
  }

  @override
  String get loginConnectedNoVersion => 'الخادم متاح';

  @override
  String get loginCustomHeadersTitle => 'رؤوس HTTP المخصصة';

  @override
  String get loginCustomHeadersSubtitle =>
      'رؤوس اختيارية لـ Cloudflare Access أو الوكلاء العكسيين';

  @override
  String get loginAddHeader => 'إضافة رأس';

  @override
  String get loginHeaderNameLabel => 'اسم الرأس';

  @override
  String get loginHeaderValueLabel => 'قيمة الرأس';

  @override
  String get loginRemoveHeaderTooltip => 'إزالة الرأس';

  @override
  String get loginUsernameLabel => 'اسم المستخدم';

  @override
  String get loginUsernameRequired => 'أدخل اسم المستخدم الخاص بك.';

  @override
  String get loginPasswordLabel => 'كلمة المرور';

  @override
  String get loginPasswordRequired => 'أدخل كلمة المرور الخاصة بك.';

  @override
  String get loginTogglePasswordTooltip => 'تبديل إظهار كلمة المرور';

  @override
  String get loginSignIn => 'تسجيل الدخول';

  @override
  String get loginSigningIn => 'جارٍ تسجيل الدخول…';

  @override
  String get loginViewDiagnostics => 'عرض سجلات التشخيص';

  @override
  String get loginSessionExpiredNotice =>
      'انتهت صلاحية جلستك. سجل الدخول مجدداً لإعادة الاتصال.';

  @override
  String get authErrorInvalidUrl =>
      'عنوان URL للخادم غير صالح. قم بتضمين http:// أو https://.';

  @override
  String get authErrorUnreachable =>
      'تعذر الوصول إلى الخادم. تحقق من عنوان URL واتصالك بالشبكة.';

  @override
  String get authErrorTimeout => 'انتهت مهلة الاتصال أثناء انتظار الخادم.';

  @override
  String get authErrorTls =>
      'فشل التحقق من شهادة TLS. تحقق من شهادة HTTPS الخاصة بخادمك.';

  @override
  String get authErrorProxyAuth =>
      'تم حظر الوصول بواسطة وكيل أو بوابة. تحقق من رؤوس HTTP المخصصة.';

  @override
  String get authErrorCredentials => 'اسم المستخدم أو كلمة المرور غير صحيحة.';

  @override
  String get authErrorInvalidResponse =>
      'لم يُرجع الخادم استجابة Audiobookshelf صالحة.';

  @override
  String get authErrorUnknown => 'حدث خطأ ما أثناء الاتصال بالخادم.';

  @override
  String get diagnosticsTitle => 'التشخيصات';

  @override
  String get diagnosticsFilterAll => 'الكل';

  @override
  String get diagnosticsFilterInfo => 'معلومات+';

  @override
  String get diagnosticsFilterWarning => 'تحذيرات+';

  @override
  String get diagnosticsFilterError => 'أخطاء';

  @override
  String get diagnosticsExportTooltip => 'تصدير السجلات';

  @override
  String get diagnosticsClearTooltip => 'مسح السجلات';

  @override
  String get diagnosticsEmpty => 'لا توجد سجلات تشخيص مطابقة لهذا المرشح.';

  @override
  String get diagnosticsExportEmpty => 'لا توجد سجلات لتصديرها بعد.';

  @override
  String get diagnosticsExportFailed => 'تعذر تصدير سجلات التشخيص.';

  @override
  String get playerTitle => 'قيد التشغيل الآن';

  @override
  String get playerNoActiveBook => 'لا يوجد شيء قيد التشغيل حالياً';

  @override
  String get playerNoActiveBookBody =>
      'اختر أي كتاب صوتي من مكتبتك لبدء الاستماع.';

  @override
  String get playerPlay => 'تشغيل';

  @override
  String get playerPause => 'إيقاف مؤقت';

  @override
  String playerRewindSeconds(int seconds) {
    return 'ترجيع $seconds ث';
  }

  @override
  String playerForwardSeconds(int seconds) {
    return 'تقديم $seconds ث';
  }

  @override
  String get playerPreviousChapter => 'الفصل السابق';

  @override
  String get playerNextChapter => 'الفصل التالي';

  @override
  String get playerScrubChapter => 'الفصل';

  @override
  String get playerScrubBook => 'الكتاب كاملًا';

  @override
  String playerSpeedLabel(String speed) {
    return '${speed}x';
  }

  @override
  String get playerSpeedSheetTitle => 'سرعة التشغيل';

  @override
  String get playerSkipSilenceLabel => 'تخطي الصمت';

  @override
  String get playerSkipSilenceSubtitle =>
      'تقليص فترات التوقف الطويلة بين السرد';

  @override
  String get playerSleepTimerLabel => 'مؤقت النوم';

  @override
  String get playerSleepOff => 'إيقاف';

  @override
  String get playerSleepEndOfChapter => 'نهاية الفصل';

  @override
  String playerSleepMinutes(int minutes) {
    return '$minutes د';
  }

  @override
  String playerSleepGraceHint(int minutes) {
    return 'هز الهاتف للتمديد +$minutes د';
  }

  @override
  String get playerChaptersLabel => 'الفصول';

  @override
  String get playerBookmarksLabel => 'الإشارات المرجعية';

  @override
  String get playerAddBookmark => 'إضافة إشارة مرجعية';

  @override
  String get playerBookmarkTitleLabel => 'عنوان الإشارة المرجعية';

  @override
  String get playerBookmarkNoteLabel => 'ملاحظة (اختياري)';

  @override
  String get playerSaveBookmark => 'حفظ الإشارة المرجعية';

  @override
  String get playerNoBookmarks => 'لم يتم حفظ إشارات مرجعية لهذا الكتاب بعد.';

  @override
  String get playerHistoryLabel => 'السجل';

  @override
  String get playerNoHistory => 'لم يتم تسجيل أي قفزات تشغيل بعد.';

  @override
  String playerSmartRewindApplied(int seconds) {
    return 'تم الترجيع $seconds ث عند الاستئناف';
  }

  @override
  String get playerStreamDirect => 'بث مباشر';

  @override
  String get playerStreamHls => 'تحويل HLS';

  @override
  String get playerBuffering => 'جارٍ التخزين المؤقت…';

  @override
  String get playerPlaybackError => 'تعذر بدء تشغيل الصوت.';

  @override
  String get playerHistoryReasonPlay => 'بدأ';

  @override
  String get playerHistoryReasonSeek => 'تمرير';

  @override
  String get playerHistoryReasonChapter => 'فصل';

  @override
  String get playerHistoryReasonPause => 'متوقف مؤقتاً';

  @override
  String get playerHistoryReasonRewind => 'ترجيع ذكي';

  @override
  String get playerHistoryReasonBookmark => 'إشارة مرجعية';

  @override
  String get playerStreamLocal => 'منزّل';

  @override
  String downloadsStorageUsed(String size) {
    return 'تم استخدام $size على الجهاز';
  }

  @override
  String get downloadsWifiOnlyTitle => 'التنزيل عبر Wi-Fi فقط';

  @override
  String get downloadsWifiOnlySubtitle =>
      'إيقاف عمليات النقل تلقائياً على شبكات الهاتف المحمول';

  @override
  String get downloadsAutoDeleteTitle => 'حذف الكتب المكتملة تلقائياً';

  @override
  String get downloadsAutoDeleteSubtitle =>
      'إزالة الملفات المنزلة بمجرد الانتهاء من الكتاب الصوتي';

  @override
  String get downloadsClearAll => 'مسح الكل';

  @override
  String get downloadsStatusQueued => 'في الانتظار';

  @override
  String get downloadsStatusDownloading => 'جارٍ التنزيل';

  @override
  String get downloadsStatusPaused => 'متوقف مؤقتاً';

  @override
  String get downloadsStatusCompleted => 'تم التنزيل';

  @override
  String get downloadsStatusFailed => 'فشل';

  @override
  String get downloadsWaitingForWifi => 'بانتظار Wi-Fi';

  @override
  String get downloadsPause => 'إيقاف مؤقت';

  @override
  String get downloadsResume => 'استئناف';

  @override
  String get downloadsRetry => 'إعادة المحاولة';

  @override
  String get downloadsDelete => 'حذف';

  @override
  String get downloadsDeleteTitle => 'إزالة الملفات دون اتصال؟';

  @override
  String get downloadsDeleteBody =>
      'يحذف هذا الصوت المنزل من هذا الجهاز دون التأثير على خادم Audiobookshelf الخاص بك.';

  @override
  String get downloadsCancel => 'إلغاء';

  @override
  String syncPendingBadge(int count) {
    return '$count بانتظار المزامنة';
  }

  @override
  String get syncNow => 'المزامنة الآن';

  @override
  String get syncConflictBannerTitle => 'تم اكتشاف تعارض في التقدم';

  @override
  String syncConflictBannerSubtitle(int count) {
    return '$count من الكتب الصوتية لديها تقدم أحدث على كل من هذا الجهاز والخادم.';
  }

  @override
  String get syncConflictResolve => 'حل';

  @override
  String get syncConflictSheetTitle => 'اختر موضع الاستماع';

  @override
  String get syncConflictDeviceLabel => 'هذا الجهاز';

  @override
  String get syncConflictServerLabel => 'الخادم';

  @override
  String get syncConflictKeepDevice => 'الاحتفاظ بموضع الجهاز';

  @override
  String get syncConflictUseServer => 'استخدام موضع الخادم';
}
