// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Shelf Plus';

  @override
  String get navHome => '홈';

  @override
  String get navLibrary => '라이브러리';

  @override
  String get navDownloads => '다운로드';

  @override
  String get navSettings => '설정';

  @override
  String get homeEmptyTitle => '나만의 오디오북 서재';

  @override
  String get homeEmptySubtitle =>
      '아래로 당겨 Audiobookshelf 라이브러리를 동기화하고 감상을 시작하세요.';

  @override
  String get homeContinueListening => '계속 듣기';

  @override
  String get homeInProgress => '감상 중';

  @override
  String get homeRecentlyAdded => '최근 추가됨';

  @override
  String get homeOfflineBanner => '오프라인 — 캐시된 라이브러리 표시 중';

  @override
  String get homeSyncTooltip => '라이브러리 동기화';

  @override
  String bookTimeLeft(String time) {
    return '$time 남음';
  }

  @override
  String get bookFinished => '완청';

  @override
  String get libraryEmptyTitle => '라이브러리 브라우저';

  @override
  String get libraryEmptySubtitle =>
      'Audiobookshelf 서버를 동기화하여 도서, 시리즈, 저자 및 컬렉션을 탐색하세요.';

  @override
  String get librarySearchHint => '제목, 저자, 낭독자, 시리즈 검색…';

  @override
  String get libraryTabBooks => '도서';

  @override
  String get libraryTabSeries => '시리즈';

  @override
  String get libraryTabAuthors => '저자';

  @override
  String get libraryTabCollections => '컬렉션';

  @override
  String get librarySortAndFilter => '정렬 및 필터';

  @override
  String get librarySortLabel => '정렬 기준';

  @override
  String get libraryFilterLabel => '필터';

  @override
  String get librarySortTitleAsc => '제목 A–Z';

  @override
  String get librarySortAuthorAsc => '저자 A–Z';

  @override
  String get librarySortAddedDesc => '최근 추가됨';

  @override
  String get librarySortDurationDesc => '긴 재생 시간순';

  @override
  String get libraryFilterAll => '전체';

  @override
  String get libraryFilterInProgress => '감상 중';

  @override
  String get libraryFilterFinished => '완청';

  @override
  String get libraryFilterNotStarted => '시작 안 함';

  @override
  String libraryBookCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count권',
    );
    return '$_temp0';
  }

  @override
  String get libraryNoMatches => '일치하는 도서가 없습니다';

  @override
  String get libraryNoGroups => '아직 항목이 없습니다';

  @override
  String get libraryClearSearchTooltip => '검색 지우기';

  @override
  String get bookDetailOverviewTab => '개요';

  @override
  String get bookDetailChaptersTab => '챕터';

  @override
  String get bookDetailBookmarksTab => '북마크';

  @override
  String bookDetailNarratedBy(String narrators) {
    return '낭독: $narrators';
  }

  @override
  String get bookDetailPlay => '재생';

  @override
  String get bookDetailResume => '이어서 듣기';

  @override
  String get bookDetailDownload => '다운로드';

  @override
  String get bookDetailPlaybackPhase3 => '오디오 재생은 3단계에서 출시됩니다.';

  @override
  String get bookDetailDownloadPhase4 => '오프라인 다운로드는 4단계에서 출시됩니다.';

  @override
  String get bookDetailNoChapters => '사용 가능한 챕터가 없습니다';

  @override
  String get bookDetailNoBookmarks => '아직 북마크가 없습니다';

  @override
  String get bookDetailNoDescription => '이 오디오북에 대한 줄거리가 없습니다.';

  @override
  String get bookDetailPublisherLabel => '출판사';

  @override
  String get bookDetailPublishedLabel => '출판 연도';

  @override
  String get bookDetailGenresLabel => '장르';

  @override
  String get bookDetailSeriesLabel => '시리즈';

  @override
  String get bookDetailNotFound => '로컬 캐시에서 도서를 찾을 수 없습니다.';

  @override
  String get downloadsEmptyTitle => '오프라인 다운로드';

  @override
  String get downloadsEmptySubtitle => '백그라운드 전송 및 다운로드한 오디오북이 여기에 표시됩니다.';

  @override
  String get miniPlayerIdleTitle => '재생 중인 항목 없음';

  @override
  String get miniPlayerIdleSubtitle => '감을 도서를 선택하세요';

  @override
  String get settingsAppearance => '화면';

  @override
  String get settingsThemeLabel => '테마';

  @override
  String get themeSystem => '시스템';

  @override
  String get themeLight => '라이트';

  @override
  String get themeDark => '다크';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsEnvironment => '환경';

  @override
  String get settingsFlavorLabel => '빌드 플레이버';

  @override
  String get settingsBundleIdLabel => '애플리케이션 ID';

  @override
  String get settingsServerSection => '서버 및 계정';

  @override
  String get settingsSignOut => '로그아웃';

  @override
  String get settingsSignOutTitle => '서버에서 로그아웃할까요?';

  @override
  String get settingsSignOutBody =>
      '이 서버의 저장된 자격 증명과 사용자 지정 프록시 헤더가 이 기기에서 삭제됩니다.';

  @override
  String get settingsCancel => '취소';

  @override
  String get settingsDiagnosticsTitle => '진단';

  @override
  String get settingsDiagnosticsSubtitle => '민감 정보가 가려진 로그 확인 및 내보내기';

  @override
  String settingsVersionPrefix(String version) {
    return '서버 v$version';
  }

  @override
  String get loginTitle => 'Audiobookshelf에 연결';

  @override
  String get loginSubtitle =>
      '서버 URL과 계정 자격 증명을 입력하세요. 하위 경로와 리버스 프록시 헤더가 지원됩니다.';

  @override
  String get loginServerUrlLabel => '서버 URL';

  @override
  String get loginServerUrlHint => 'https://books.example.com';

  @override
  String get loginServerUrlRequired => '유효한 http:// 또는 https:// 서버 URL을 입력하세요.';

  @override
  String get loginTestConnection => '연결 테스트';

  @override
  String get loginTestingConnection => '테스트 중…';

  @override
  String loginConnectedBadge(String version) {
    return '연결됨 ($version)';
  }

  @override
  String get loginConnectedNoVersion => '서버 연결 가능';

  @override
  String get loginCustomHeadersTitle => '사용자 지정 HTTP 헤더';

  @override
  String get loginCustomHeadersSubtitle =>
      'Cloudflare Access 또는 리버스 프록시용 선택적 헤더';

  @override
  String get loginAddHeader => '헤더 추가';

  @override
  String get loginHeaderNameLabel => '헤더 이름';

  @override
  String get loginHeaderValueLabel => '헤더 값';

  @override
  String get loginRemoveHeaderTooltip => '헤더 제거';

  @override
  String get loginUsernameLabel => '사용자 이름';

  @override
  String get loginUsernameRequired => '사용자 이름을 입력하세요.';

  @override
  String get loginPasswordLabel => '비밀번호';

  @override
  String get loginPasswordRequired => '비밀번호를 입력하세요.';

  @override
  String get loginTogglePasswordTooltip => '비밀번호 표시 전환';

  @override
  String get loginSignIn => '로그인';

  @override
  String get loginSigningIn => '로그인 중…';

  @override
  String get loginViewDiagnostics => '진단 로그 보기';

  @override
  String get loginSessionExpiredNotice => '세션이 만료되었습니다. 다시 연결하려면 로그인하세요.';

  @override
  String get authErrorInvalidUrl =>
      '서버 URL이 올바르지 않습니다. http:// 또는 https://를 포함하세요.';

  @override
  String get authErrorUnreachable => '서버에 연결할 수 없습니다. URL과 네트워크 연결을 확인하세요.';

  @override
  String get authErrorTimeout => '서버 응답을 기다리는 중 시간이 초과되었습니다.';

  @override
  String get authErrorTls => 'TLS 인증서 확인에 실패했습니다. 서버의 HTTPS 인증서를 확인하세요.';

  @override
  String get authErrorProxyAuth =>
      '프록시 또는 게이트웨이에 의해 액세스가 차단되었습니다. 사용자 지정 HTTP 헤더를 확인하세요.';

  @override
  String get authErrorCredentials => '사용자 이름 또는 비밀번호가 올바르지 않습니다.';

  @override
  String get authErrorInvalidResponse =>
      '서버가 유효한 Audiobookshelf 응답을 반환하지 않았습니다.';

  @override
  String get authErrorUnknown => '서버에 연결하는 동안 문제가 발생했습니다.';

  @override
  String get diagnosticsTitle => '진단';

  @override
  String get diagnosticsFilterAll => '전체';

  @override
  String get diagnosticsFilterInfo => '정보+';

  @override
  String get diagnosticsFilterWarning => '경고+';

  @override
  String get diagnosticsFilterError => '오류';

  @override
  String get diagnosticsExportTooltip => '로그 내보내기';

  @override
  String get diagnosticsClearTooltip => '로그 지우기';

  @override
  String get diagnosticsEmpty => '이 필터와 일치하는 진단 로그가 없습니다.';

  @override
  String get diagnosticsExportEmpty => '아직 내보낼 로그가 없습니다.';

  @override
  String get diagnosticsExportFailed => '진단 로그를 내보낼 수 없습니다.';

  @override
  String get playerTitle => '지금 재생 중';

  @override
  String get playerNoActiveBook => '지금 재생 중인 항목이 없습니다';

  @override
  String get playerNoActiveBookBody => '라이브러리에서 오디오북을 선택하여 감상을 시작하세요.';

  @override
  String get playerPlay => '재생';

  @override
  String get playerPause => '일시정지';

  @override
  String playerRewindSeconds(int seconds) {
    return '$seconds초 뒤로';
  }

  @override
  String playerForwardSeconds(int seconds) {
    return '$seconds초 앞으로';
  }

  @override
  String get playerPreviousChapter => '이전 챕터';

  @override
  String get playerNextChapter => '다음 챕터';

  @override
  String get playerScrubChapter => '챕터';

  @override
  String get playerScrubBook => '전체 도서';

  @override
  String playerSpeedLabel(String speed) {
    return '${speed}x';
  }

  @override
  String get playerSpeedSheetTitle => '재생 속도';

  @override
  String get playerSkipSilenceLabel => '무음 건너뛰기';

  @override
  String get playerSkipSilenceSubtitle => '낭독 사이의 긴 공백 줄이기';

  @override
  String get playerSleepTimerLabel => '취침 타이머';

  @override
  String get playerSleepOff => '꺼짐';

  @override
  String get playerSleepEndOfChapter => '챕터 끝';

  @override
  String playerSleepMinutes(int minutes) {
    return '$minutes분';
  }

  @override
  String playerSleepGraceHint(int minutes) {
    return '기기를 흔들어 +$minutes분 연장';
  }

  @override
  String get playerChaptersLabel => '챕터';

  @override
  String get playerBookmarksLabel => '북마크';

  @override
  String get playerAddBookmark => '북마크 추가';

  @override
  String get playerBookmarkTitleLabel => '북마크 제목';

  @override
  String get playerBookmarkNoteLabel => '메모(선택 사항)';

  @override
  String get playerSaveBookmark => '북마크 저장';

  @override
  String get playerNoBookmarks => '이 도서에 저장된 북마크가 아직 없습니다.';

  @override
  String get playerHistoryLabel => '기록';

  @override
  String get playerNoHistory => '아직 기록된 재생 이동이 없습니다.';

  @override
  String playerSmartRewindApplied(int seconds) {
    return '재개 시 $seconds초 되감기됨';
  }

  @override
  String get playerStreamDirect => '직접 스트림';

  @override
  String get playerStreamHls => 'HLS 트랜스코드';

  @override
  String get playerBuffering => '버퍼링 중…';

  @override
  String get playerPlaybackError => '오디오 재생을 시작할 수 없습니다.';

  @override
  String get playerHistoryReasonPlay => '시작됨';

  @override
  String get playerHistoryReasonSeek => '탐색됨';

  @override
  String get playerHistoryReasonChapter => '챕터';

  @override
  String get playerHistoryReasonPause => '일시정지됨';

  @override
  String get playerHistoryReasonRewind => '스마트 되감기';

  @override
  String get playerHistoryReasonBookmark => '북마크';

  @override
  String get playerStreamLocal => '다운로드됨';

  @override
  String downloadsStorageUsed(String size) {
    return '기기에서 $size 사용 중';
  }

  @override
  String get downloadsWifiOnlyTitle => 'Wi-Fi에서만 다운로드';

  @override
  String get downloadsWifiOnlySubtitle => '모바일 네트워크에서 자동으로 전송 일시정지';

  @override
  String get downloadsAutoDeleteTitle => '완청한 도서 자동 삭제';

  @override
  String get downloadsAutoDeleteSubtitle => '오디오북을 다 들으면 다운로드한 파일 제거';

  @override
  String get downloadsClearAll => '모두 지우기';

  @override
  String get downloadsStatusQueued => '대기 중';

  @override
  String get downloadsStatusDownloading => '다운로드 중';

  @override
  String get downloadsStatusPaused => '일시정지됨';

  @override
  String get downloadsStatusCompleted => '다운로드됨';

  @override
  String get downloadsStatusFailed => '실패';

  @override
  String get downloadsWaitingForWifi => 'Wi-Fi 대기 중';

  @override
  String get downloadsPause => '일시정지';

  @override
  String get downloadsResume => '재개';

  @override
  String get downloadsRetry => '다시 시도';

  @override
  String get downloadsDelete => '삭제';

  @override
  String get downloadsDeleteTitle => '오프라인 파일을 제거할까요?';

  @override
  String get downloadsDeleteBody =>
      'Audiobookshelf 서버에는 영향을 주지 않고 이 기기에서 다운로드한 오디오를 삭제합니다.';

  @override
  String get downloadsCancel => '취소';

  @override
  String syncPendingBadge(int count) {
    return '$count개 동기화 대기 중';
  }

  @override
  String get syncNow => '지금 동기화';

  @override
  String get syncConflictBannerTitle => '진행률 충돌 감지됨';

  @override
  String syncConflictBannerSubtitle(int count) {
    return '$count권의 오디오북이 이 기기와 서버 양쪽 모두에 더 최신 진행률이 있습니다.';
  }

  @override
  String get syncConflictResolve => '해결';

  @override
  String get syncConflictSheetTitle => '재생 위치 선택';

  @override
  String get syncConflictDeviceLabel => '이 기기';

  @override
  String get syncConflictServerLabel => '서버';

  @override
  String get syncConflictKeepDevice => '기기 위치 유지';

  @override
  String get syncConflictUseServer => '서버 위치 사용';
}
