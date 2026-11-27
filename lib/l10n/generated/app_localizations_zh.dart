// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Shelf Plus';

  @override
  String get navHome => '首页';

  @override
  String get navLibrary => '书库';

  @override
  String get navDownloads => '下载';

  @override
  String get navSettings => '设置';

  @override
  String get homeEmptyTitle => '你的收听书架';

  @override
  String get homeEmptySubtitle => '下拉同步你的 Audiobookshelf 书库并开始收听。';

  @override
  String get homeContinueListening => '继续收听';

  @override
  String get homeInProgress => '收听中';

  @override
  String get homeRecentlyAdded => '最近添加';

  @override
  String get homeOfflineBanner => '离线 — 正在显示缓存书库';

  @override
  String get homeSyncTooltip => '同步书库';

  @override
  String bookTimeLeft(String time) {
    return '剩余 $time';
  }

  @override
  String get bookFinished => '已听完';

  @override
  String get libraryEmptyTitle => '书库浏览';

  @override
  String get libraryEmptySubtitle => '同步你的 Audiobookshelf 服务器以浏览书籍、系列、作者和合集。';

  @override
  String get librarySearchHint => '搜索书名、作者、演播者、系列…';

  @override
  String get libraryTabBooks => '书籍';

  @override
  String get libraryTabSeries => '系列';

  @override
  String get libraryTabAuthors => '作者';

  @override
  String get libraryTabCollections => '合集';

  @override
  String get librarySortAndFilter => '排序与筛选';

  @override
  String get librarySortLabel => '排序方式';

  @override
  String get libraryFilterLabel => '筛选';

  @override
  String get librarySortTitleAsc => '书名 A–Z';

  @override
  String get librarySortAuthorAsc => '作者 A–Z';

  @override
  String get librarySortAddedDesc => '最近添加';

  @override
  String get librarySortDurationDesc => '时长最长优先';

  @override
  String get libraryFilterAll => '全部';

  @override
  String get libraryFilterInProgress => '收听中';

  @override
  String get libraryFilterFinished => '已听完';

  @override
  String get libraryFilterNotStarted => '未开始';

  @override
  String libraryBookCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 本书',
    );
    return '$_temp0';
  }

  @override
  String get libraryNoMatches => '没有匹配的书籍';

  @override
  String get libraryNoGroups => '这里还没有内容';

  @override
  String get libraryClearSearchTooltip => '清除搜索';

  @override
  String get bookDetailOverviewTab => '概览';

  @override
  String get bookDetailChaptersTab => '章节';

  @override
  String get bookDetailBookmarksTab => '书签';

  @override
  String bookDetailNarratedBy(String narrators) {
    return '演播：$narrators';
  }

  @override
  String get bookDetailPlay => '播放';

  @override
  String get bookDetailResume => '继续';

  @override
  String get bookDetailDownload => '下载';

  @override
  String get bookDetailPlaybackPhase3 => '音频播放将在第 3 阶段推出。';

  @override
  String get bookDetailDownloadPhase4 => '离线下载将在第 4 阶段推出。';

  @override
  String get bookDetailNoChapters => '暂无可用章节';

  @override
  String get bookDetailNoBookmarks => '暂无书签';

  @override
  String get bookDetailNoDescription => '此有声书暂无简介。';

  @override
  String get bookDetailPublisherLabel => '出版社';

  @override
  String get bookDetailPublishedLabel => '出版年份';

  @override
  String get bookDetailGenresLabel => '类型';

  @override
  String get bookDetailSeriesLabel => '系列';

  @override
  String get bookDetailNotFound => '本地缓存中未找到该书籍。';

  @override
  String get downloadsEmptyTitle => '离线下载';

  @override
  String get downloadsEmptySubtitle => '后台传输和已下载的有声书将显示在这里。';

  @override
  String get miniPlayerIdleTitle => '当前未播放';

  @override
  String get miniPlayerIdleSubtitle => '选择一本书开始收听';

  @override
  String get settingsAppearance => '外观';

  @override
  String get settingsThemeLabel => '主题';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsEnvironment => '环境';

  @override
  String get settingsFlavorLabel => '构建风味';

  @override
  String get settingsBundleIdLabel => '应用 ID';

  @override
  String get settingsServerSection => '服务器与账户';

  @override
  String get settingsSignOut => '退出登录';

  @override
  String get settingsSignOutTitle => '退出服务器登录？';

  @override
  String get settingsSignOutBody => '此设备上保存的该服务器凭据和自定义代理请求头将被移除。';

  @override
  String get settingsCancel => '取消';

  @override
  String get settingsDiagnosticsTitle => '诊断';

  @override
  String get settingsDiagnosticsSubtitle => '查看并导出脱敏日志';

  @override
  String settingsVersionPrefix(String version) {
    return '服务器 v$version';
  }

  @override
  String get loginTitle => '连接到 Audiobookshelf';

  @override
  String get loginSubtitle => '输入你的服务器 URL 和账户凭据。支持子路径和反向代理请求头。';

  @override
  String get loginServerUrlLabel => '服务器 URL';

  @override
  String get loginServerUrlHint => 'https://books.example.com';

  @override
  String get loginServerUrlRequired => '请输入有效的 http:// 或 https:// 服务器 URL。';

  @override
  String get loginTestConnection => '测试连接';

  @override
  String get loginTestingConnection => '正在测试…';

  @override
  String loginConnectedBadge(String version) {
    return '已连接 ($version)';
  }

  @override
  String get loginConnectedNoVersion => '服务器可达';

  @override
  String get loginCustomHeadersTitle => '自定义 HTTP 请求头';

  @override
  String get loginCustomHeadersSubtitle => '用于 Cloudflare Access 或反向代理的可选请求头';

  @override
  String get loginAddHeader => '添加请求头';

  @override
  String get loginHeaderNameLabel => '请求头名称';

  @override
  String get loginHeaderValueLabel => '请求头值';

  @override
  String get loginRemoveHeaderTooltip => '移除请求头';

  @override
  String get loginUsernameLabel => '用户名';

  @override
  String get loginUsernameRequired => '请输入你的用户名。';

  @override
  String get loginPasswordLabel => '密码';

  @override
  String get loginPasswordRequired => '请输入你的密码。';

  @override
  String get loginTogglePasswordTooltip => '切换密码可见性';

  @override
  String get loginSignIn => '登录';

  @override
  String get loginSigningIn => '正在登录…';

  @override
  String get loginViewDiagnostics => '查看诊断日志';

  @override
  String get loginSessionExpiredNotice => '你的会话已过期，请重新登录以连接。';

  @override
  String get authErrorInvalidUrl => '服务器 URL 无效，请包含 http:// 或 https://。';

  @override
  String get authErrorUnreachable => '无法连接到服务器，请检查 URL 和网络连接。';

  @override
  String get authErrorTimeout => '等待服务器响应超时。';

  @override
  String get authErrorTls => 'TLS 证书验证失败，请检查服务器的 HTTPS 证书。';

  @override
  String get authErrorProxyAuth => '访问被代理或网关拦截，请检查你的自定义 HTTP 请求头。';

  @override
  String get authErrorCredentials => '用户名或密码无效。';

  @override
  String get authErrorInvalidResponse => '服务器未返回有效的 Audiobookshelf 响应。';

  @override
  String get authErrorUnknown => '联系服务器时发生错误。';

  @override
  String get diagnosticsTitle => '诊断';

  @override
  String get diagnosticsFilterAll => '全部';

  @override
  String get diagnosticsFilterInfo => '信息+';

  @override
  String get diagnosticsFilterWarning => '警告+';

  @override
  String get diagnosticsFilterError => '错误';

  @override
  String get diagnosticsExportTooltip => '导出日志';

  @override
  String get diagnosticsClearTooltip => '清除日志';

  @override
  String get diagnosticsEmpty => '没有符合此筛选条件的诊断日志。';

  @override
  String get diagnosticsExportEmpty => '暂无可导出的日志。';

  @override
  String get diagnosticsExportFailed => '无法导出诊断日志。';

  @override
  String get playerTitle => '正在播放';

  @override
  String get playerNoActiveBook => '当前没有正在播放的内容';

  @override
  String get playerNoActiveBookBody => '从你的书库中选择任意有声书即可开始收听。';

  @override
  String get playerPlay => '播放';

  @override
  String get playerPause => '暂停';

  @override
  String playerRewindSeconds(int seconds) {
    return '快退 $seconds 秒';
  }

  @override
  String playerForwardSeconds(int seconds) {
    return '快进 $seconds 秒';
  }

  @override
  String get playerPreviousChapter => '上一章';

  @override
  String get playerNextChapter => '下一章';

  @override
  String get playerScrubChapter => '当前章节';

  @override
  String get playerScrubBook => '整本书';

  @override
  String playerSpeedLabel(String speed) {
    return '${speed}x';
  }

  @override
  String get playerSpeedSheetTitle => '播放速度';

  @override
  String get playerSkipSilenceLabel => '跳过静音';

  @override
  String get playerSkipSilenceSubtitle => '裁剪朗读之间的较长停顿';

  @override
  String get playerSleepTimerLabel => '睡眠定时器';

  @override
  String get playerSleepOff => '关闭';

  @override
  String get playerSleepEndOfChapter => '本章节结束';

  @override
  String playerSleepMinutes(int minutes) {
    return '$minutes 分钟';
  }

  @override
  String playerSleepGraceHint(int minutes) {
    return '摇晃手机可延长 +$minutes 分钟';
  }

  @override
  String get playerChaptersLabel => '章节';

  @override
  String get playerBookmarksLabel => '书签';

  @override
  String get playerAddBookmark => '添加书签';

  @override
  String get playerBookmarkTitleLabel => '书签标题';

  @override
  String get playerBookmarkNoteLabel => '备注（可选）';

  @override
  String get playerSaveBookmark => '保存书签';

  @override
  String get playerNoBookmarks => '此书尚未保存任何书签。';

  @override
  String get playerHistoryLabel => '历史记录';

  @override
  String get playerNoHistory => '尚未记录播放跳转。';

  @override
  String playerSmartRewindApplied(int seconds) {
    return '恢复播放时已智能回退 $seconds 秒';
  }

  @override
  String get playerStreamDirect => '直接串流';

  @override
  String get playerStreamHls => 'HLS 转码';

  @override
  String get playerBuffering => '正在缓冲…';

  @override
  String get playerPlaybackError => '无法开始音频播放。';

  @override
  String get playerHistoryReasonPlay => '开始';

  @override
  String get playerHistoryReasonSeek => '拖动进度';

  @override
  String get playerHistoryReasonChapter => '章节';

  @override
  String get playerHistoryReasonPause => '暂停';

  @override
  String get playerHistoryReasonRewind => '智能回退';

  @override
  String get playerHistoryReasonBookmark => '书签';

  @override
  String get playerStreamLocal => '已下载';

  @override
  String downloadsStorageUsed(String size) {
    return '设备已用 $size';
  }

  @override
  String get downloadsWifiOnlyTitle => '仅在 Wi-Fi 下下载';

  @override
  String get downloadsWifiOnlySubtitle => '在移动网络下自动暂停传输';

  @override
  String get downloadsAutoDeleteTitle => '自动删除已听完的书籍';

  @override
  String get downloadsAutoDeleteSubtitle => '有声书听完后自动移除已下载的文件';

  @override
  String get downloadsClearAll => '全部清除';

  @override
  String get downloadsStatusQueued => '排队中';

  @override
  String get downloadsStatusDownloading => '下载中';

  @override
  String get downloadsStatusPaused => '已暂停';

  @override
  String get downloadsStatusCompleted => '已下载';

  @override
  String get downloadsStatusFailed => '失败';

  @override
  String get downloadsWaitingForWifi => '等待 Wi-Fi';

  @override
  String get downloadsPause => '暂停';

  @override
  String get downloadsResume => '继续';

  @override
  String get downloadsRetry => '重试';

  @override
  String get downloadsDelete => '删除';

  @override
  String get downloadsDeleteTitle => '移除离线文件？';

  @override
  String get downloadsDeleteBody => '这会从此设备删除已下载的音频，不会影响你的 Audiobookshelf 服务器。';

  @override
  String get downloadsCancel => '取消';

  @override
  String syncPendingBadge(int count) {
    return '$count 项待同步';
  }

  @override
  String get syncNow => '立即同步';

  @override
  String get syncConflictBannerTitle => '检测到进度冲突';

  @override
  String syncConflictBannerSubtitle(int count) {
    return '$count 本有声书在此设备和服务器上均有更新的进度。';
  }

  @override
  String get syncConflictResolve => '解决';

  @override
  String get syncConflictSheetTitle => '选择收听位置';

  @override
  String get syncConflictDeviceLabel => '此设备';

  @override
  String get syncConflictServerLabel => '服务器';

  @override
  String get syncConflictKeepDevice => '保留设备位置';

  @override
  String get syncConflictUseServer => '使用服务器位置';
}
