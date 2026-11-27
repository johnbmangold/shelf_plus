// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Shelf Plus';

  @override
  String get navHome => 'Início';

  @override
  String get navLibrary => 'Biblioteca';

  @override
  String get navDownloads => 'Downloads';

  @override
  String get navSettings => 'Configurações';

  @override
  String get homeEmptyTitle => 'Sua estante de áudio';

  @override
  String get homeEmptySubtitle =>
      'Puxe para baixo para sincronizar sua biblioteca do Audiobookshelf e começar a ouvir.';

  @override
  String get homeContinueListening => 'Continuar ouvindo';

  @override
  String get homeInProgress => 'Em andamento';

  @override
  String get homeRecentlyAdded => 'Adicionados recentemente';

  @override
  String get homeOfflineBanner => 'Offline — mostrando biblioteca em cache';

  @override
  String get homeSyncTooltip => 'Sincronizar biblioteca';

  @override
  String bookTimeLeft(String time) {
    return 'Restam $time';
  }

  @override
  String get bookFinished => 'Concluído';

  @override
  String get libraryEmptyTitle => 'Navegador da biblioteca';

  @override
  String get libraryEmptySubtitle =>
      'Sincronize seu servidor Audiobookshelf para explorar livros, séries, autores e coleções.';

  @override
  String get librarySearchHint =>
      'Buscar títulos, autores, narradores, séries…';

  @override
  String get libraryTabBooks => 'Livros';

  @override
  String get libraryTabSeries => 'Séries';

  @override
  String get libraryTabAuthors => 'Autores';

  @override
  String get libraryTabCollections => 'Coleções';

  @override
  String get librarySortAndFilter => 'Ordenar e filtrar';

  @override
  String get librarySortLabel => 'Ordenar por';

  @override
  String get libraryFilterLabel => 'Filtrar';

  @override
  String get librarySortTitleAsc => 'Título A–Z';

  @override
  String get librarySortAuthorAsc => 'Autor A–Z';

  @override
  String get librarySortAddedDesc => 'Adicionados recentemente';

  @override
  String get librarySortDurationDesc => 'Mais longos primeiro';

  @override
  String get libraryFilterAll => 'Todos';

  @override
  String get libraryFilterInProgress => 'Em andamento';

  @override
  String get libraryFilterFinished => 'Concluídos';

  @override
  String get libraryFilterNotStarted => 'Não iniciados';

  @override
  String libraryBookCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count livros',
      one: '1 livro',
    );
    return '$_temp0';
  }

  @override
  String get libraryNoMatches => 'Nenhum livro correspondente';

  @override
  String get libraryNoGroups => 'Nada aqui ainda';

  @override
  String get libraryClearSearchTooltip => 'Limpar busca';

  @override
  String get bookDetailOverviewTab => 'Visão geral';

  @override
  String get bookDetailChaptersTab => 'Capítulos';

  @override
  String get bookDetailBookmarksTab => 'Marcadores';

  @override
  String bookDetailNarratedBy(String narrators) {
    return 'Narrado por $narrators';
  }

  @override
  String get bookDetailPlay => 'Reproduzir';

  @override
  String get bookDetailResume => 'Retomar';

  @override
  String get bookDetailDownload => 'Baixar';

  @override
  String get bookDetailPlaybackPhase3 =>
      'A reprodução de áudio chega na Fase 3.';

  @override
  String get bookDetailDownloadPhase4 =>
      'Os downloads offline chegam na Fase 4.';

  @override
  String get bookDetailNoChapters => 'Nenhum capítulo disponível';

  @override
  String get bookDetailNoBookmarks => 'Nenhum marcador ainda';

  @override
  String get bookDetailNoDescription =>
      'Nenhuma sinopse disponível para este audiolivro.';

  @override
  String get bookDetailPublisherLabel => 'Editora';

  @override
  String get bookDetailPublishedLabel => 'Publicado';

  @override
  String get bookDetailGenresLabel => 'Gêneros';

  @override
  String get bookDetailSeriesLabel => 'Série';

  @override
  String get bookDetailNotFound => 'Livro não encontrado no cache local.';

  @override
  String get downloadsEmptyTitle => 'Downloads offline';

  @override
  String get downloadsEmptySubtitle =>
      'Transferências em segundo plano e audiolivros baixados aparecerão aqui.';

  @override
  String get miniPlayerIdleTitle => 'Nada tocando';

  @override
  String get miniPlayerIdleSubtitle => 'Escolha um livro para começar a ouvir';

  @override
  String get settingsAppearance => 'Aparência';

  @override
  String get settingsThemeLabel => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsEnvironment => 'Ambiente';

  @override
  String get settingsFlavorLabel => 'Variante';

  @override
  String get settingsBundleIdLabel => 'ID do aplicativo';

  @override
  String get settingsServerSection => 'Servidor e conta';

  @override
  String get settingsSignOut => 'Sair';

  @override
  String get settingsSignOutTitle => 'Sair do servidor?';

  @override
  String get settingsSignOutBody =>
      'As credenciais salvas e os cabeçalhos de proxy personalizados deste servidor serão removidos deste dispositivo.';

  @override
  String get settingsCancel => 'Cancelar';

  @override
  String get settingsDiagnosticsTitle => 'Diagnóstico';

  @override
  String get settingsDiagnosticsSubtitle =>
      'Inspecionar e exportar registros censurados';

  @override
  String settingsVersionPrefix(String version) {
    return 'Servidor v$version';
  }

  @override
  String get loginTitle => 'Conectar ao Audiobookshelf';

  @override
  String get loginSubtitle =>
      'Digite a URL do seu servidor e as credenciais da conta. Subcaminhos e cabeçalhos de proxy reverso são suportados.';

  @override
  String get loginServerUrlLabel => 'URL do servidor';

  @override
  String get loginServerUrlHint => 'https://books.example.com';

  @override
  String get loginServerUrlRequired =>
      'Digite uma URL de servidor http:// ou https:// válida.';

  @override
  String get loginTestConnection => 'Testar conexão';

  @override
  String get loginTestingConnection => 'Testando…';

  @override
  String loginConnectedBadge(String version) {
    return 'Conectado ($version)';
  }

  @override
  String get loginConnectedNoVersion => 'Servidor acessível';

  @override
  String get loginCustomHeadersTitle => 'Cabeçalhos HTTP personalizados';

  @override
  String get loginCustomHeadersSubtitle =>
      'Cabeçalhos opcionais para Cloudflare Access ou proxies reversos';

  @override
  String get loginAddHeader => 'Adicionar cabeçalho';

  @override
  String get loginHeaderNameLabel => 'Nome do cabeçalho';

  @override
  String get loginHeaderValueLabel => 'Valor do cabeçalho';

  @override
  String get loginRemoveHeaderTooltip => 'Remover cabeçalho';

  @override
  String get loginUsernameLabel => 'Nome de usuário';

  @override
  String get loginUsernameRequired => 'Digite seu nome de usuário.';

  @override
  String get loginPasswordLabel => 'Senha';

  @override
  String get loginPasswordRequired => 'Digite sua senha.';

  @override
  String get loginTogglePasswordTooltip => 'Alternar visibilidade da senha';

  @override
  String get loginSignIn => 'Entrar';

  @override
  String get loginSigningIn => 'Entrando…';

  @override
  String get loginViewDiagnostics => 'Ver registros de diagnóstico';

  @override
  String get loginSessionExpiredNotice =>
      'Sua sessão expirou. Entre novamente para reconectar.';

  @override
  String get authErrorInvalidUrl =>
      'A URL do servidor é inválida. Inclua http:// ou https://.';

  @override
  String get authErrorUnreachable =>
      'Não foi possível alcançar o servidor. Verifique a URL e sua conexão de rede.';

  @override
  String get authErrorTimeout =>
      'Tempo limite esgotado ao aguardar o servidor.';

  @override
  String get authErrorTls =>
      'Falha na verificação do certificado TLS. Verifique o certificado HTTPS do servidor.';

  @override
  String get authErrorProxyAuth =>
      'O acesso foi bloqueado por um proxy ou gateway. Verifique seus cabeçalhos HTTP personalizados.';

  @override
  String get authErrorCredentials => 'Nome de usuário ou senha inválidos.';

  @override
  String get authErrorInvalidResponse =>
      'O servidor não retornou uma resposta válida do Audiobookshelf.';

  @override
  String get authErrorUnknown => 'Algo deu errado ao contatar o servidor.';

  @override
  String get diagnosticsTitle => 'Diagnóstico';

  @override
  String get diagnosticsFilterAll => 'Todos';

  @override
  String get diagnosticsFilterInfo => 'Info+';

  @override
  String get diagnosticsFilterWarning => 'Avisos+';

  @override
  String get diagnosticsFilterError => 'Erros';

  @override
  String get diagnosticsExportTooltip => 'Exportar registros';

  @override
  String get diagnosticsClearTooltip => 'Limpar registros';

  @override
  String get diagnosticsEmpty =>
      'Nenhum registro de diagnóstico corresponde a este filtro.';

  @override
  String get diagnosticsExportEmpty => 'Ainda não há registros para exportar.';

  @override
  String get diagnosticsExportFailed =>
      'Não foi possível exportar os registros de diagnóstico.';

  @override
  String get playerTitle => 'Tocando agora';

  @override
  String get playerNoActiveBook => 'Nada tocando no momento';

  @override
  String get playerNoActiveBookBody =>
      'Selecione qualquer audiolivro da sua biblioteca para começar a ouvir.';

  @override
  String get playerPlay => 'Reproduzir';

  @override
  String get playerPause => 'Pausar';

  @override
  String playerRewindSeconds(int seconds) {
    return 'Retroceder ${seconds}s';
  }

  @override
  String playerForwardSeconds(int seconds) {
    return 'Avançar ${seconds}s';
  }

  @override
  String get playerPreviousChapter => 'Capítulo anterior';

  @override
  String get playerNextChapter => 'Próximo capítulo';

  @override
  String get playerScrubChapter => 'Capítulo';

  @override
  String get playerScrubBook => 'Livro inteiro';

  @override
  String playerSpeedLabel(String speed) {
    return '${speed}x';
  }

  @override
  String get playerSpeedSheetTitle => 'Velocidade de reprodução';

  @override
  String get playerSkipSilenceLabel => 'Pular silêncio';

  @override
  String get playerSkipSilenceSubtitle =>
      'Reduzir pausas longas durante a narração';

  @override
  String get playerSleepTimerLabel => 'Temporizador';

  @override
  String get playerSleepOff => 'Desligado';

  @override
  String get playerSleepEndOfChapter => 'Fim do capítulo';

  @override
  String playerSleepMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String playerSleepGraceHint(int minutes) {
    return 'Agite o telefone para estender +$minutes min';
  }

  @override
  String get playerChaptersLabel => 'Capítulos';

  @override
  String get playerBookmarksLabel => 'Marcadores';

  @override
  String get playerAddBookmark => 'Adicionar marcador';

  @override
  String get playerBookmarkTitleLabel => 'Título do marcador';

  @override
  String get playerBookmarkNoteLabel => 'Nota (opcional)';

  @override
  String get playerSaveBookmark => 'Salvar marcador';

  @override
  String get playerNoBookmarks =>
      'Nenhum marcador salvo para este livro ainda.';

  @override
  String get playerHistoryLabel => 'Histórico';

  @override
  String get playerNoHistory => 'Nenhum salto de reprodução registrado ainda.';

  @override
  String playerSmartRewindApplied(int seconds) {
    return 'Retrocedido ${seconds}s ao retomar';
  }

  @override
  String get playerStreamDirect => 'Transmissão direta';

  @override
  String get playerStreamHls => 'Transcodificação HLS';

  @override
  String get playerBuffering => 'Armazenando em buffer…';

  @override
  String get playerPlaybackError =>
      'Não foi possível iniciar a reprodução de áudio.';

  @override
  String get playerHistoryReasonPlay => 'Iniciado';

  @override
  String get playerHistoryReasonSeek => 'Avançado/retrocedido';

  @override
  String get playerHistoryReasonChapter => 'Capítulo';

  @override
  String get playerHistoryReasonPause => 'Pausado';

  @override
  String get playerHistoryReasonRewind => 'Retrocesso inteligente';

  @override
  String get playerHistoryReasonBookmark => 'Marcador';

  @override
  String get playerStreamLocal => 'Baixado';

  @override
  String downloadsStorageUsed(String size) {
    return '$size usados no dispositivo';
  }

  @override
  String get downloadsWifiOnlyTitle => 'Baixar apenas via Wi-Fi';

  @override
  String get downloadsWifiOnlySubtitle =>
      'Pausar transferências automaticamente em redes móveis';

  @override
  String get downloadsAutoDeleteTitle => 'Excluir livros concluídos';

  @override
  String get downloadsAutoDeleteSubtitle =>
      'Remover arquivos baixados após concluir um audiolivro';

  @override
  String get downloadsClearAll => 'Limpar tudo';

  @override
  String get downloadsStatusQueued => 'Na fila';

  @override
  String get downloadsStatusDownloading => 'Baixando';

  @override
  String get downloadsStatusPaused => 'Pausado';

  @override
  String get downloadsStatusCompleted => 'Baixado';

  @override
  String get downloadsStatusFailed => 'Falhou';

  @override
  String get downloadsWaitingForWifi => 'Aguardando Wi-Fi';

  @override
  String get downloadsPause => 'Pausar';

  @override
  String get downloadsResume => 'Retomar';

  @override
  String get downloadsRetry => 'Tentar novamente';

  @override
  String get downloadsDelete => 'Excluir';

  @override
  String get downloadsDeleteTitle => 'Remover arquivos offline?';

  @override
  String get downloadsDeleteBody =>
      'Isso exclui o áudio baixado deste dispositivo sem afetar seu servidor Audiobookshelf.';

  @override
  String get downloadsCancel => 'Cancelar';

  @override
  String syncPendingBadge(int count) {
    return '$count pendente(s) de sincronização';
  }

  @override
  String get syncNow => 'Sincronizar agora';

  @override
  String get syncConflictBannerTitle => 'Conflito de progresso detectado';

  @override
  String syncConflictBannerSubtitle(int count) {
    return '$count audiolivro(s) têm progresso mais recente neste dispositivo e no servidor.';
  }

  @override
  String get syncConflictResolve => 'Resolver';

  @override
  String get syncConflictSheetTitle => 'Escolher posição de escuta';

  @override
  String get syncConflictDeviceLabel => 'Este dispositivo';

  @override
  String get syncConflictServerLabel => 'Servidor';

  @override
  String get syncConflictKeepDevice => 'Manter posição do dispositivo';

  @override
  String get syncConflictUseServer => 'Usar posição do servidor';
}
