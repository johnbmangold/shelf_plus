// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Shelf Plus';

  @override
  String get navHome => 'Inicio';

  @override
  String get navLibrary => 'Biblioteca';

  @override
  String get navDownloads => 'Descargas';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get homeEmptyTitle => 'Tu estantería de escucha';

  @override
  String get homeEmptySubtitle =>
      'Desliza hacia abajo para sincronizar tu biblioteca de Audiobookshelf y empezar a escuchar.';

  @override
  String get homeContinueListening => 'Seguir escuchando';

  @override
  String get homeInProgress => 'En curso';

  @override
  String get homeRecentlyAdded => 'Añadidos recientemente';

  @override
  String get homeOfflineBanner =>
      'Sin conexión — mostrando biblioteca en caché';

  @override
  String get homeSyncTooltip => 'Sincronizar biblioteca';

  @override
  String bookTimeLeft(String time) {
    return 'Quedan $time';
  }

  @override
  String get bookFinished => 'Terminado';

  @override
  String get libraryEmptyTitle => 'Explorador de biblioteca';

  @override
  String get libraryEmptySubtitle =>
      'Sincroniza tu servidor Audiobookshelf para explorar libros, series, autores y colecciones.';

  @override
  String get librarySearchHint =>
      'Buscar títulos, autores, narradores, series…';

  @override
  String get libraryTabBooks => 'Libros';

  @override
  String get libraryTabSeries => 'Series';

  @override
  String get libraryTabAuthors => 'Autores';

  @override
  String get libraryTabCollections => 'Colecciones';

  @override
  String get librarySortAndFilter => 'Ordenar y filtrar';

  @override
  String get librarySortLabel => 'Ordenar por';

  @override
  String get libraryFilterLabel => 'Filtrar';

  @override
  String get librarySortTitleAsc => 'Título A–Z';

  @override
  String get librarySortAuthorAsc => 'Autor A–Z';

  @override
  String get librarySortAddedDesc => 'Añadidos recientemente';

  @override
  String get librarySortDurationDesc => 'Más largos primero';

  @override
  String get libraryFilterAll => 'Todos';

  @override
  String get libraryFilterInProgress => 'En curso';

  @override
  String get libraryFilterFinished => 'Terminados';

  @override
  String get libraryFilterNotStarted => 'Sin empezar';

  @override
  String libraryBookCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count libros',
      one: '1 libro',
    );
    return '$_temp0';
  }

  @override
  String get libraryNoMatches => 'No hay libros que coincidan';

  @override
  String get libraryNoGroups => 'Aún no hay nada aquí';

  @override
  String get libraryClearSearchTooltip => 'Borrar búsqueda';

  @override
  String get bookDetailOverviewTab => 'Resumen';

  @override
  String get bookDetailChaptersTab => 'Capítulos';

  @override
  String get bookDetailBookmarksTab => 'Marcadores';

  @override
  String bookDetailNarratedBy(String narrators) {
    return 'Narrado por $narrators';
  }

  @override
  String get bookDetailPlay => 'Reproducir';

  @override
  String get bookDetailResume => 'Reanudar';

  @override
  String get bookDetailDownload => 'Descargar';

  @override
  String get bookDetailPlaybackPhase3 =>
      'La reproducción de audio llega en la Fase 3.';

  @override
  String get bookDetailDownloadPhase4 =>
      'Las descargas sin conexión llegan en la Fase 4.';

  @override
  String get bookDetailNoChapters => 'No hay capítulos disponibles';

  @override
  String get bookDetailNoBookmarks => 'Aún no hay marcadores';

  @override
  String get bookDetailNoDescription =>
      'No hay sinopsis disponible para este audiolibro.';

  @override
  String get bookDetailPublisherLabel => 'Editorial';

  @override
  String get bookDetailPublishedLabel => 'Publicado';

  @override
  String get bookDetailGenresLabel => 'Géneros';

  @override
  String get bookDetailSeriesLabel => 'Serie';

  @override
  String get bookDetailNotFound => 'No se encontró el libro en la caché local.';

  @override
  String get downloadsEmptyTitle => 'Descargas sin conexión';

  @override
  String get downloadsEmptySubtitle =>
      'Las transferencias en segundo plano y los audiolibros descargados aparecerán aquí.';

  @override
  String get miniPlayerIdleTitle => 'Nada reproduciéndose';

  @override
  String get miniPlayerIdleSubtitle => 'Elige un libro para empezar a escuchar';

  @override
  String get settingsAppearance => 'Apariencia';

  @override
  String get settingsThemeLabel => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsEnvironment => 'Entorno';

  @override
  String get settingsFlavorLabel => 'Variante';

  @override
  String get settingsBundleIdLabel => 'ID de aplicación';

  @override
  String get settingsServerSection => 'Servidor y cuenta';

  @override
  String get settingsSignOut => 'Cerrar sesión';

  @override
  String get settingsSignOutTitle => '¿Cerrar sesión del servidor?';

  @override
  String get settingsSignOutBody =>
      'Se eliminarán de este dispositivo las credenciales guardadas y los encabezados de proxy personalizados de este servidor.';

  @override
  String get settingsCancel => 'Cancelar';

  @override
  String get settingsDiagnosticsTitle => 'Diagnóstico';

  @override
  String get settingsDiagnosticsSubtitle =>
      'Inspeccionar y exportar registros censurados';

  @override
  String settingsVersionPrefix(String version) {
    return 'Servidor v$version';
  }

  @override
  String get loginTitle => 'Conectar con Audiobookshelf';

  @override
  String get loginSubtitle =>
      'Introduce la URL de tu servidor y las credenciales de tu cuenta. Se admiten subrutas y encabezados de proxy inverso.';

  @override
  String get loginServerUrlLabel => 'URL del servidor';

  @override
  String get loginServerUrlHint => 'https://books.example.com';

  @override
  String get loginServerUrlRequired =>
      'Introduce una URL de servidor http:// o https:// válida.';

  @override
  String get loginTestConnection => 'Probar conexión';

  @override
  String get loginTestingConnection => 'Probando…';

  @override
  String loginConnectedBadge(String version) {
    return 'Conectado ($version)';
  }

  @override
  String get loginConnectedNoVersion => 'Servidor accesible';

  @override
  String get loginCustomHeadersTitle => 'Encabezados HTTP personalizados';

  @override
  String get loginCustomHeadersSubtitle =>
      'Encabezados opcionales para Cloudflare Access o proxies inversos';

  @override
  String get loginAddHeader => 'Añadir encabezado';

  @override
  String get loginHeaderNameLabel => 'Nombre del encabezado';

  @override
  String get loginHeaderValueLabel => 'Valor del encabezado';

  @override
  String get loginRemoveHeaderTooltip => 'Eliminar encabezado';

  @override
  String get loginUsernameLabel => 'Nombre de usuario';

  @override
  String get loginUsernameRequired => 'Introduce tu nombre de usuario.';

  @override
  String get loginPasswordLabel => 'Contraseña';

  @override
  String get loginPasswordRequired => 'Introduce tu contraseña.';

  @override
  String get loginTogglePasswordTooltip => 'Mostrar u ocultar contraseña';

  @override
  String get loginSignIn => 'Iniciar sesión';

  @override
  String get loginSigningIn => 'Iniciando sesión…';

  @override
  String get loginViewDiagnostics => 'Ver registros de diagnóstico';

  @override
  String get loginSessionExpiredNotice =>
      'Tu sesión ha caducado. Inicia sesión de nuevo para reconectar.';

  @override
  String get authErrorInvalidUrl =>
      'La URL del servidor no es válida. Incluye http:// o https://.';

  @override
  String get authErrorUnreachable =>
      'No se pudo conectar con el servidor. Comprueba la URL y tu conexión de red.';

  @override
  String get authErrorTimeout =>
      'Se agotó el tiempo de espera al conectar con el servidor.';

  @override
  String get authErrorTls =>
      'Error al verificar el certificado TLS. Comprueba el certificado HTTPS de tu servidor.';

  @override
  String get authErrorProxyAuth =>
      'Un proxy o puerta de enlace bloqueó el acceso. Comprueba tus encabezados HTTP personalizados.';

  @override
  String get authErrorCredentials =>
      'Nombre de usuario o contraseña no válidos.';

  @override
  String get authErrorInvalidResponse =>
      'El servidor no devolvió una respuesta válida de Audiobookshelf.';

  @override
  String get authErrorUnknown => 'Algo salió mal al contactar con el servidor.';

  @override
  String get diagnosticsTitle => 'Diagnóstico';

  @override
  String get diagnosticsFilterAll => 'Todos';

  @override
  String get diagnosticsFilterInfo => 'Info+';

  @override
  String get diagnosticsFilterWarning => 'Avisos+';

  @override
  String get diagnosticsFilterError => 'Errores';

  @override
  String get diagnosticsExportTooltip => 'Exportar registros';

  @override
  String get diagnosticsClearTooltip => 'Borrar registros';

  @override
  String get diagnosticsEmpty =>
      'No hay registros de diagnóstico que coincidan con este filtro.';

  @override
  String get diagnosticsExportEmpty => 'Aún no hay registros para exportar.';

  @override
  String get diagnosticsExportFailed =>
      'No se pudieron exportar los registros de diagnóstico.';

  @override
  String get playerTitle => 'Reproduciendo ahora';

  @override
  String get playerNoActiveBook => 'No hay nada reproduciéndose ahora';

  @override
  String get playerNoActiveBookBody =>
      'Selecciona cualquier audiolibro de tu biblioteca para empezar a escuchar.';

  @override
  String get playerPlay => 'Reproducir';

  @override
  String get playerPause => 'Pausar';

  @override
  String playerRewindSeconds(int seconds) {
    return 'Retroceder $seconds s';
  }

  @override
  String playerForwardSeconds(int seconds) {
    return 'Avanzar $seconds s';
  }

  @override
  String get playerPreviousChapter => 'Capítulo anterior';

  @override
  String get playerNextChapter => 'Capítulo siguiente';

  @override
  String get playerScrubChapter => 'Capítulo';

  @override
  String get playerScrubBook => 'Libro completo';

  @override
  String playerSpeedLabel(String speed) {
    return '${speed}x';
  }

  @override
  String get playerSpeedSheetTitle => 'Velocidad de reproducción';

  @override
  String get playerSkipSilenceLabel => 'Saltar silencios';

  @override
  String get playerSkipSilenceSubtitle =>
      'Recortar pausas largas entre la narración';

  @override
  String get playerSleepTimerLabel => 'Temporizador';

  @override
  String get playerSleepOff => 'Desactivado';

  @override
  String get playerSleepEndOfChapter => 'Fin del capítulo';

  @override
  String playerSleepMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String playerSleepGraceHint(int minutes) {
    return 'Agita el teléfono para ampliar +$minutes min';
  }

  @override
  String get playerChaptersLabel => 'Capítulos';

  @override
  String get playerBookmarksLabel => 'Marcadores';

  @override
  String get playerAddBookmark => 'Añadir marcador';

  @override
  String get playerBookmarkTitleLabel => 'Título del marcador';

  @override
  String get playerBookmarkNoteLabel => 'Nota (opcional)';

  @override
  String get playerSaveBookmark => 'Guardar marcador';

  @override
  String get playerNoBookmarks =>
      'Aún no hay marcadores guardados para este libro.';

  @override
  String get playerHistoryLabel => 'Historial';

  @override
  String get playerNoHistory =>
      'Aún no se han registrado saltos de reproducción.';

  @override
  String playerSmartRewindApplied(int seconds) {
    return 'Retroceso de $seconds s al reanudar';
  }

  @override
  String get playerStreamDirect => 'Transmisión directa';

  @override
  String get playerStreamHls => 'Transcodificación HLS';

  @override
  String get playerBuffering => 'Almacenando en búfer…';

  @override
  String get playerPlaybackError =>
      'No se pudo iniciar la reproducción de audio.';

  @override
  String get playerHistoryReasonPlay => 'Iniciado';

  @override
  String get playerHistoryReasonSeek => 'Desplazado';

  @override
  String get playerHistoryReasonChapter => 'Capítulo';

  @override
  String get playerHistoryReasonPause => 'Pausado';

  @override
  String get playerHistoryReasonRewind => 'Retroceso inteligente';

  @override
  String get playerHistoryReasonBookmark => 'Marcador';

  @override
  String get playerStreamLocal => 'Descargado';

  @override
  String downloadsStorageUsed(String size) {
    return '$size usados en el dispositivo';
  }

  @override
  String get downloadsWifiOnlyTitle => 'Descargar solo por Wi-Fi';

  @override
  String get downloadsWifiOnlySubtitle =>
      'Pausar transferencias automáticamente en redes móviles';

  @override
  String get downloadsAutoDeleteTitle => 'Eliminar libros terminados';

  @override
  String get downloadsAutoDeleteSubtitle =>
      'Eliminar archivos descargados cuando se termine un audiolibro';

  @override
  String get downloadsClearAll => 'Borrar todo';

  @override
  String get downloadsStatusQueued => 'En cola';

  @override
  String get downloadsStatusDownloading => 'Descargando';

  @override
  String get downloadsStatusPaused => 'En pausa';

  @override
  String get downloadsStatusCompleted => 'Descargado';

  @override
  String get downloadsStatusFailed => 'Error';

  @override
  String get downloadsWaitingForWifi => 'Esperando Wi-Fi';

  @override
  String get downloadsPause => 'Pausar';

  @override
  String get downloadsResume => 'Reanudar';

  @override
  String get downloadsRetry => 'Reintentar';

  @override
  String get downloadsDelete => 'Eliminar';

  @override
  String get downloadsDeleteTitle => '¿Eliminar archivos sin conexión?';

  @override
  String get downloadsDeleteBody =>
      'Esto elimina el audio descargado de este dispositivo sin afectar a tu servidor Audiobookshelf.';

  @override
  String get downloadsCancel => 'Cancelar';

  @override
  String syncPendingBadge(int count) {
    return '$count pendiente(s) de sincronizar';
  }

  @override
  String get syncNow => 'Sincronizar ahora';

  @override
  String get syncConflictBannerTitle => 'Conflicto de progreso detectado';

  @override
  String syncConflictBannerSubtitle(int count) {
    return '$count audiolibro(s) tienen progreso más reciente tanto en este dispositivo como en el servidor.';
  }

  @override
  String get syncConflictResolve => 'Resolver';

  @override
  String get syncConflictSheetTitle => 'Elegir posición de escucha';

  @override
  String get syncConflictDeviceLabel => 'Este dispositivo';

  @override
  String get syncConflictServerLabel => 'Servidor';

  @override
  String get syncConflictKeepDevice => 'Mantener posición del dispositivo';

  @override
  String get syncConflictUseServer => 'Usar posición del servidor';
}
