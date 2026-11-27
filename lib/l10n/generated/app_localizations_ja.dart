// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Shelf Plus';

  @override
  String get navHome => 'ホーム';

  @override
  String get navLibrary => 'ライブラリ';

  @override
  String get navDownloads => 'ダウンロード';

  @override
  String get navSettings => '設定';

  @override
  String get homeEmptyTitle => 'リスニングシェルフ';

  @override
  String get homeEmptySubtitle => '下に引いて Audiobookshelf ライブラリを同期し、再生を始めましょう。';

  @override
  String get homeContinueListening => '再生を続ける';

  @override
  String get homeInProgress => '再生中';

  @override
  String get homeRecentlyAdded => '最近の追加';

  @override
  String get homeOfflineBanner => 'オフライン — キャッシュ済みライブラリを表示中';

  @override
  String get homeSyncTooltip => 'ライブラリを同期';

  @override
  String bookTimeLeft(String time) {
    return '残り $time';
  }

  @override
  String get bookFinished => '聴了';

  @override
  String get libraryEmptyTitle => 'ライブラリブラウザ';

  @override
  String get libraryEmptySubtitle =>
      'Audiobookshelf サーバーを同期して、本、シリーズ、著者、コレクションを閲覧します。';

  @override
  String get librarySearchHint => 'タイトル、著者、ナレーター、シリーズを検索…';

  @override
  String get libraryTabBooks => '本';

  @override
  String get libraryTabSeries => 'シリーズ';

  @override
  String get libraryTabAuthors => '著者';

  @override
  String get libraryTabCollections => 'コレクション';

  @override
  String get librarySortAndFilter => '並び替えとフィルター';

  @override
  String get librarySortLabel => '並び替え';

  @override
  String get libraryFilterLabel => 'フィルター';

  @override
  String get librarySortTitleAsc => 'タイトル A–Z';

  @override
  String get librarySortAuthorAsc => '著者 A–Z';

  @override
  String get librarySortAddedDesc => '最近の追加';

  @override
  String get librarySortDurationDesc => '再生時間の長い順';

  @override
  String get libraryFilterAll => 'すべて';

  @override
  String get libraryFilterInProgress => '再生中';

  @override
  String get libraryFilterFinished => '聴了';

  @override
  String get libraryFilterNotStarted => '未再生';

  @override
  String libraryBookCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 冊',
    );
    return '$_temp0';
  }

  @override
  String get libraryNoMatches => '一致する本がありません';

  @override
  String get libraryNoGroups => 'まだ何もありません';

  @override
  String get libraryClearSearchTooltip => '検索をクリア';

  @override
  String get bookDetailOverviewTab => '概要';

  @override
  String get bookDetailChaptersTab => 'チャプター';

  @override
  String get bookDetailBookmarksTab => 'ブックマーク';

  @override
  String bookDetailNarratedBy(String narrators) {
    return '朗読: $narrators';
  }

  @override
  String get bookDetailPlay => '再生';

  @override
  String get bookDetailResume => '再開';

  @override
  String get bookDetailDownload => 'ダウンロード';

  @override
  String get bookDetailPlaybackPhase3 => '音声再生はフェーズ 3 で開始します。';

  @override
  String get bookDetailDownloadPhase4 => 'オフラインダウンロードはフェーズ 4 で開始します。';

  @override
  String get bookDetailNoChapters => '利用可能なチャプターがありません';

  @override
  String get bookDetailNoBookmarks => 'ブックマークはまだありません';

  @override
  String get bookDetailNoDescription => 'このオーディオブックのあらすじはありません。';

  @override
  String get bookDetailPublisherLabel => '出版社';

  @override
  String get bookDetailPublishedLabel => '出版年';

  @override
  String get bookDetailGenresLabel => 'ジャンル';

  @override
  String get bookDetailSeriesLabel => 'シリーズ';

  @override
  String get bookDetailNotFound => 'ローカルキャッシュに本が見つかりません。';

  @override
  String get downloadsEmptyTitle => 'オフラインダウンロード';

  @override
  String get downloadsEmptySubtitle =>
      'バックグラウンド転送やダウンロード済みのオーディオブックがここに表示されます。';

  @override
  String get miniPlayerIdleTitle => '再生していません';

  @override
  String get miniPlayerIdleSubtitle => '本を選んで再生を開始';

  @override
  String get settingsAppearance => '外観';

  @override
  String get settingsThemeLabel => 'テーマ';

  @override
  String get themeSystem => 'システム';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsEnvironment => '環境';

  @override
  String get settingsFlavorLabel => 'フレーバー';

  @override
  String get settingsBundleIdLabel => 'アプリケーション ID';

  @override
  String get settingsServerSection => 'サーバーとアカウント';

  @override
  String get settingsSignOut => 'サインアウト';

  @override
  String get settingsSignOutTitle => 'サーバーからサインアウトしますか？';

  @override
  String get settingsSignOutBody =>
      'このサーバー用に保存された認証情報とカスタムプロキシヘッダーがこのデバイスから削除されます。';

  @override
  String get settingsCancel => 'キャンセル';

  @override
  String get settingsDiagnosticsTitle => '診断';

  @override
  String get settingsDiagnosticsSubtitle => '秘匿化済みログの確認とエクスポート';

  @override
  String settingsVersionPrefix(String version) {
    return 'サーバー v$version';
  }

  @override
  String get loginTitle => 'Audiobookshelf に接続';

  @override
  String get loginSubtitle =>
      'サーバー URL とアカウント情報を入力してください。サブパスやリバースプロキシヘッダーに対応しています。';

  @override
  String get loginServerUrlLabel => 'サーバー URL';

  @override
  String get loginServerUrlHint => 'https://books.example.com';

  @override
  String get loginServerUrlRequired =>
      '有効な http:// または https:// のサーバー URL を入力してください。';

  @override
  String get loginTestConnection => '接続テスト';

  @override
  String get loginTestingConnection => 'テスト中…';

  @override
  String loginConnectedBadge(String version) {
    return '接続済み ($version)';
  }

  @override
  String get loginConnectedNoVersion => 'サーバー到達可能';

  @override
  String get loginCustomHeadersTitle => 'カスタム HTTP ヘッダー';

  @override
  String get loginCustomHeadersSubtitle =>
      'Cloudflare Access やリバースプロキシ用の任意ヘッダー';

  @override
  String get loginAddHeader => 'ヘッダーを追加';

  @override
  String get loginHeaderNameLabel => 'ヘッダー名';

  @override
  String get loginHeaderValueLabel => 'ヘッダー値';

  @override
  String get loginRemoveHeaderTooltip => 'ヘッダーを削除';

  @override
  String get loginUsernameLabel => 'ユーザー名';

  @override
  String get loginUsernameRequired => 'ユーザー名を入力してください。';

  @override
  String get loginPasswordLabel => 'パスワード';

  @override
  String get loginPasswordRequired => 'パスワードを入力してください。';

  @override
  String get loginTogglePasswordTooltip => 'パスワード表示を切り替え';

  @override
  String get loginSignIn => 'サインイン';

  @override
  String get loginSigningIn => 'サインイン中…';

  @override
  String get loginViewDiagnostics => '診断ログを表示';

  @override
  String get loginSessionExpiredNotice =>
      'セッションの有効期限が切れました。再接続するにはサインインしてください。';

  @override
  String get authErrorInvalidUrl =>
      'サーバー URL が無効です。http:// または https:// を含めてください。';

  @override
  String get authErrorUnreachable => 'サーバーに接続できませんでした。URL とネットワーク接続を確認してください。';

  @override
  String get authErrorTimeout => 'サーバーの応答待ちでタイムアウトしました。';

  @override
  String get authErrorTls => 'TLS 証明書の検証に失敗しました。サーバーの HTTPS 証明書を確認してください。';

  @override
  String get authErrorProxyAuth =>
      'プロキシまたはゲートウェイによりアクセスがブロックされました。カスタム HTTP ヘッダーを確認してください。';

  @override
  String get authErrorCredentials => 'ユーザー名またはパスワードが無効です。';

  @override
  String get authErrorInvalidResponse =>
      'サーバーから有効な Audiobookshelf の応答が返されませんでした。';

  @override
  String get authErrorUnknown => 'サーバーへの接続中にエラーが発生しました。';

  @override
  String get diagnosticsTitle => '診断';

  @override
  String get diagnosticsFilterAll => 'すべて';

  @override
  String get diagnosticsFilterInfo => '情報+';

  @override
  String get diagnosticsFilterWarning => '警告+';

  @override
  String get diagnosticsFilterError => 'エラー';

  @override
  String get diagnosticsExportTooltip => 'ログをエクスポート';

  @override
  String get diagnosticsClearTooltip => 'ログを消去';

  @override
  String get diagnosticsEmpty => 'このフィルターに一致する診断ログはありません。';

  @override
  String get diagnosticsExportEmpty => 'エクスポートするログはまだありません。';

  @override
  String get diagnosticsExportFailed => '診断ログをエクスポートできませんでした。';

  @override
  String get playerTitle => '再生中';

  @override
  String get playerNoActiveBook => '現在再生中の本はありません';

  @override
  String get playerNoActiveBookBody => 'ライブラリからオーディオブックを選択して再生を開始してください。';

  @override
  String get playerPlay => '再生';

  @override
  String get playerPause => '一時停止';

  @override
  String playerRewindSeconds(int seconds) {
    return '$seconds秒戻す';
  }

  @override
  String playerForwardSeconds(int seconds) {
    return '$seconds秒送る';
  }

  @override
  String get playerPreviousChapter => '前のチャプター';

  @override
  String get playerNextChapter => '次のチャプター';

  @override
  String get playerScrubChapter => 'チャプター';

  @override
  String get playerScrubBook => '本全体';

  @override
  String playerSpeedLabel(String speed) {
    return '${speed}x';
  }

  @override
  String get playerSpeedSheetTitle => '再生速度';

  @override
  String get playerSkipSilenceLabel => '無音をスキップ';

  @override
  String get playerSkipSilenceSubtitle => '朗読間の長い間合いを短縮する';

  @override
  String get playerSleepTimerLabel => 'スリープタイマー';

  @override
  String get playerSleepOff => 'オフ';

  @override
  String get playerSleepEndOfChapter => 'チャプターの終わり';

  @override
  String playerSleepMinutes(int minutes) {
    return '$minutes分';
  }

  @override
  String playerSleepGraceHint(int minutes) {
    return '端末を振って +$minutes分延長';
  }

  @override
  String get playerChaptersLabel => 'チャプター';

  @override
  String get playerBookmarksLabel => 'ブックマーク';

  @override
  String get playerAddBookmark => 'ブックマークを追加';

  @override
  String get playerBookmarkTitleLabel => 'ブックマークのタイトル';

  @override
  String get playerBookmarkNoteLabel => 'メモ（任意）';

  @override
  String get playerSaveBookmark => 'ブックマークを保存';

  @override
  String get playerNoBookmarks => 'この本にはまだブックマークが保存されていません。';

  @override
  String get playerHistoryLabel => '履歴';

  @override
  String get playerNoHistory => '再生ジャンプの履歴はまだありません。';

  @override
  String playerSmartRewindApplied(int seconds) {
    return '再開時に$seconds秒巻き戻しました';
  }

  @override
  String get playerStreamDirect => 'ダイレクトストリーム';

  @override
  String get playerStreamHls => 'HLS トランスコード';

  @override
  String get playerBuffering => 'バッファリング中…';

  @override
  String get playerPlaybackError => '音声再生を開始できませんでした。';

  @override
  String get playerHistoryReasonPlay => '開始';

  @override
  String get playerHistoryReasonSeek => 'シーク';

  @override
  String get playerHistoryReasonChapter => 'チャプター';

  @override
  String get playerHistoryReasonPause => '一時停止';

  @override
  String get playerHistoryReasonRewind => 'スマート巻き戻し';

  @override
  String get playerHistoryReasonBookmark => 'ブックマーク';

  @override
  String get playerStreamLocal => 'ダウンロード済み';

  @override
  String downloadsStorageUsed(String size) {
    return '端末で $size 使用中';
  }

  @override
  String get downloadsWifiOnlyTitle => 'Wi-Fi 接続時のみダウンロード';

  @override
  String get downloadsWifiOnlySubtitle => 'モバイルネットワークでは転送を自動的に一時停止';

  @override
  String get downloadsAutoDeleteTitle => '聴了した本を自動削除';

  @override
  String get downloadsAutoDeleteSubtitle => 'オーディオブックを聴き終えたらダウンロード済みファイルを削除';

  @override
  String get downloadsClearAll => 'すべて消去';

  @override
  String get downloadsStatusQueued => '待機中';

  @override
  String get downloadsStatusDownloading => 'ダウンロード中';

  @override
  String get downloadsStatusPaused => '一時停止';

  @override
  String get downloadsStatusCompleted => 'ダウンロード済み';

  @override
  String get downloadsStatusFailed => '失敗';

  @override
  String get downloadsWaitingForWifi => 'Wi-Fi 待機中';

  @override
  String get downloadsPause => '一時停止';

  @override
  String get downloadsResume => '再開';

  @override
  String get downloadsRetry => '再試行';

  @override
  String get downloadsDelete => '削除';

  @override
  String get downloadsDeleteTitle => 'オフラインファイルを削除しますか？';

  @override
  String get downloadsDeleteBody =>
      'Audiobookshelf サーバーには影響せず、このデバイスからダウンロード済み音声を削除します。';

  @override
  String get downloadsCancel => 'キャンセル';

  @override
  String syncPendingBadge(int count) {
    return '$count 件同期待ち';
  }

  @override
  String get syncNow => '今すぐ同期';

  @override
  String get syncConflictBannerTitle => '再生位置の競合を検出';

  @override
  String syncConflictBannerSubtitle(int count) {
    return '$count 冊のオーディオブックで、このデバイスとサーバーの両方に新しい進行状況があります。';
  }

  @override
  String get syncConflictResolve => '解決';

  @override
  String get syncConflictSheetTitle => '再生位置を選択';

  @override
  String get syncConflictDeviceLabel => 'このデバイス';

  @override
  String get syncConflictServerLabel => 'サーバー';

  @override
  String get syncConflictKeepDevice => 'デバイスの位置を保持';

  @override
  String get syncConflictUseServer => 'サーバーの位置を使用';
}
