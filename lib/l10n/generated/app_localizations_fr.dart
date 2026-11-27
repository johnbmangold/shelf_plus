// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Shelf Plus';

  @override
  String get navHome => 'Accueil';

  @override
  String get navLibrary => 'Bibliothèque';

  @override
  String get navDownloads => 'Téléchargements';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get homeEmptyTitle => 'Votre étagère d\'écoute';

  @override
  String get homeEmptySubtitle =>
      'Tirez vers le bas pour synchroniser votre bibliothèque Audiobookshelf et commencer l\'écoute.';

  @override
  String get homeContinueListening => 'Continuer l\'écoute';

  @override
  String get homeInProgress => 'En cours';

  @override
  String get homeRecentlyAdded => 'Ajoutés récemment';

  @override
  String get homeOfflineBanner =>
      'Hors ligne — affichage de la bibliothèque en cache';

  @override
  String get homeSyncTooltip => 'Synchroniser la bibliothèque';

  @override
  String bookTimeLeft(String time) {
    return '$time restant';
  }

  @override
  String get bookFinished => 'Terminé';

  @override
  String get libraryEmptyTitle => 'Explorateur de bibliothèque';

  @override
  String get libraryEmptySubtitle =>
      'Synchronisez votre serveur Audiobookshelf pour parcourir livres, séries, auteurs et collections.';

  @override
  String get librarySearchHint =>
      'Rechercher titres, auteurs, narrateurs, séries…';

  @override
  String get libraryTabBooks => 'Livres';

  @override
  String get libraryTabSeries => 'Séries';

  @override
  String get libraryTabAuthors => 'Auteurs';

  @override
  String get libraryTabCollections => 'Collections';

  @override
  String get librarySortAndFilter => 'Trier et filtrer';

  @override
  String get librarySortLabel => 'Trier par';

  @override
  String get libraryFilterLabel => 'Filtrer';

  @override
  String get librarySortTitleAsc => 'Titre A–Z';

  @override
  String get librarySortAuthorAsc => 'Auteur A–Z';

  @override
  String get librarySortAddedDesc => 'Ajoutés récemment';

  @override
  String get librarySortDurationDesc => 'Les plus longs d\'abord';

  @override
  String get libraryFilterAll => 'Tous';

  @override
  String get libraryFilterInProgress => 'En cours';

  @override
  String get libraryFilterFinished => 'Terminés';

  @override
  String get libraryFilterNotStarted => 'Non commencés';

  @override
  String libraryBookCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count livres',
      one: '1 livre',
    );
    return '$_temp0';
  }

  @override
  String get libraryNoMatches => 'Aucun livre correspondant';

  @override
  String get libraryNoGroups => 'Rien ici pour le moment';

  @override
  String get libraryClearSearchTooltip => 'Effacer la recherche';

  @override
  String get bookDetailOverviewTab => 'Aperçu';

  @override
  String get bookDetailChaptersTab => 'Chapitres';

  @override
  String get bookDetailBookmarksTab => 'Signets';

  @override
  String bookDetailNarratedBy(String narrators) {
    return 'Lu par $narrators';
  }

  @override
  String get bookDetailPlay => 'Lire';

  @override
  String get bookDetailResume => 'Reprendre';

  @override
  String get bookDetailDownload => 'Télécharger';

  @override
  String get bookDetailPlaybackPhase3 => 'La lecture audio arrive en Phase 3.';

  @override
  String get bookDetailDownloadPhase4 =>
      'Les téléchargements hors ligne arrivent en Phase 4.';

  @override
  String get bookDetailNoChapters => 'Aucun chapitre disponible';

  @override
  String get bookDetailNoBookmarks => 'Aucun signet pour le moment';

  @override
  String get bookDetailNoDescription =>
      'Aucun synopsis disponible pour ce livre audio.';

  @override
  String get bookDetailPublisherLabel => 'Éditeur';

  @override
  String get bookDetailPublishedLabel => 'Publié';

  @override
  String get bookDetailGenresLabel => 'Genres';

  @override
  String get bookDetailSeriesLabel => 'Série';

  @override
  String get bookDetailNotFound => 'Livre introuvable dans le cache local.';

  @override
  String get downloadsEmptyTitle => 'Téléchargements hors ligne';

  @override
  String get downloadsEmptySubtitle =>
      'Les transferts en arrière-plan et les livres audio téléchargés apparaîtront ici.';

  @override
  String get miniPlayerIdleTitle => 'Aucune lecture';

  @override
  String get miniPlayerIdleSubtitle =>
      'Choisissez un livre pour commencer l\'écoute';

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get settingsThemeLabel => 'Thème';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsEnvironment => 'Environnement';

  @override
  String get settingsFlavorLabel => 'Variante';

  @override
  String get settingsBundleIdLabel => 'ID de l\'application';

  @override
  String get settingsServerSection => 'Serveur et compte';

  @override
  String get settingsSignOut => 'Se déconnecter';

  @override
  String get settingsSignOutTitle => 'Se déconnecter du serveur ?';

  @override
  String get settingsSignOutBody =>
      'Les identifiants enregistrés et les en-têtes proxy personnalisés de ce serveur seront supprimés de cet appareil.';

  @override
  String get settingsCancel => 'Annuler';

  @override
  String get settingsDiagnosticsTitle => 'Diagnostics';

  @override
  String get settingsDiagnosticsSubtitle =>
      'Inspecter et exporter les journaux expurgés';

  @override
  String settingsVersionPrefix(String version) {
    return 'Serveur v$version';
  }

  @override
  String get loginTitle => 'Se connecter à Audiobookshelf';

  @override
  String get loginSubtitle =>
      'Saisissez l\'URL de votre serveur et vos identifiants. Les sous-chemins et en-têtes de proxy inverse sont pris en charge.';

  @override
  String get loginServerUrlLabel => 'URL du serveur';

  @override
  String get loginServerUrlHint => 'https://books.example.com';

  @override
  String get loginServerUrlRequired =>
      'Saisissez une URL de serveur http:// ou https:// valide.';

  @override
  String get loginTestConnection => 'Tester la connexion';

  @override
  String get loginTestingConnection => 'Test en cours…';

  @override
  String loginConnectedBadge(String version) {
    return 'Connecté ($version)';
  }

  @override
  String get loginConnectedNoVersion => 'Serveur accessible';

  @override
  String get loginCustomHeadersTitle => 'En-têtes HTTP personnalisés';

  @override
  String get loginCustomHeadersSubtitle =>
      'En-têtes facultatifs pour Cloudflare Access ou proxys inverses';

  @override
  String get loginAddHeader => 'Ajouter un en-tête';

  @override
  String get loginHeaderNameLabel => 'Nom de l\'en-tête';

  @override
  String get loginHeaderValueLabel => 'Valeur de l\'en-tête';

  @override
  String get loginRemoveHeaderTooltip => 'Supprimer l\'en-tête';

  @override
  String get loginUsernameLabel => 'Nom d\'utilisateur';

  @override
  String get loginUsernameRequired => 'Saisissez votre nom d\'utilisateur.';

  @override
  String get loginPasswordLabel => 'Mot de passe';

  @override
  String get loginPasswordRequired => 'Saisissez votre mot de passe.';

  @override
  String get loginTogglePasswordTooltip =>
      'Afficher ou masquer le mot de passe';

  @override
  String get loginSignIn => 'Se connecter';

  @override
  String get loginSigningIn => 'Connexion…';

  @override
  String get loginViewDiagnostics => 'Voir les journaux de diagnostic';

  @override
  String get loginSessionExpiredNotice =>
      'Votre session a expiré. Reconnectez-vous.';

  @override
  String get authErrorInvalidUrl =>
      'L\'URL du serveur est invalide. Incluez http:// ou https://.';

  @override
  String get authErrorUnreachable =>
      'Impossible de joindre le serveur. Vérifiez l\'URL et votre connexion réseau.';

  @override
  String get authErrorTimeout =>
      'Délai d\'attente dépassé lors de la connexion au serveur.';

  @override
  String get authErrorTls =>
      'Échec de la vérification du certificat TLS. Vérifiez le certificat HTTPS de votre serveur.';

  @override
  String get authErrorProxyAuth =>
      'L\'accès a été bloqué par un proxy ou une passerelle. Vérifiez vos en-têtes HTTP personnalisés.';

  @override
  String get authErrorCredentials =>
      'Nom d\'utilisateur ou mot de passe invalide.';

  @override
  String get authErrorInvalidResponse =>
      'Le serveur n\'a pas renvoyé une réponse Audiobookshelf valide.';

  @override
  String get authErrorUnknown =>
      'Une erreur est survenue lors de la connexion au serveur.';

  @override
  String get diagnosticsTitle => 'Diagnostics';

  @override
  String get diagnosticsFilterAll => 'Tous';

  @override
  String get diagnosticsFilterInfo => 'Info+';

  @override
  String get diagnosticsFilterWarning => 'Avert.+';

  @override
  String get diagnosticsFilterError => 'Erreurs';

  @override
  String get diagnosticsExportTooltip => 'Exporter les journaux';

  @override
  String get diagnosticsClearTooltip => 'Effacer les journaux';

  @override
  String get diagnosticsEmpty =>
      'Aucun journal de diagnostic ne correspond à ce filtre.';

  @override
  String get diagnosticsExportEmpty =>
      'Il n\'y a aucun journal à exporter pour le moment.';

  @override
  String get diagnosticsExportFailed =>
      'Impossible d\'exporter les journaux de diagnostic.';

  @override
  String get playerTitle => 'Lecture en cours';

  @override
  String get playerNoActiveBook => 'Rien en cours de lecture';

  @override
  String get playerNoActiveBookBody =>
      'Sélectionnez un livre audio dans votre bibliothèque pour commencer l\'écoute.';

  @override
  String get playerPlay => 'Lire';

  @override
  String get playerPause => 'Pause';

  @override
  String playerRewindSeconds(int seconds) {
    return 'Reculer de $seconds s';
  }

  @override
  String playerForwardSeconds(int seconds) {
    return 'Avancer de $seconds s';
  }

  @override
  String get playerPreviousChapter => 'Chapitre précédent';

  @override
  String get playerNextChapter => 'Chapitre suivant';

  @override
  String get playerScrubChapter => 'Chapitre';

  @override
  String get playerScrubBook => 'Livre entier';

  @override
  String playerSpeedLabel(String speed) {
    return '${speed}x';
  }

  @override
  String get playerSpeedSheetTitle => 'Vitesse de lecture';

  @override
  String get playerSkipSilenceLabel => 'Ignorer les silences';

  @override
  String get playerSkipSilenceSubtitle =>
      'Réduire les longues pauses pendant la narration';

  @override
  String get playerSleepTimerLabel => 'Minuteur de veille';

  @override
  String get playerSleepOff => 'Désactivé';

  @override
  String get playerSleepEndOfChapter => 'Fin du chapitre';

  @override
  String playerSleepMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String playerSleepGraceHint(int minutes) {
    return 'Secouez le téléphone pour prolonger de +$minutes min';
  }

  @override
  String get playerChaptersLabel => 'Chapitres';

  @override
  String get playerBookmarksLabel => 'Signets';

  @override
  String get playerAddBookmark => 'Ajouter un signet';

  @override
  String get playerBookmarkTitleLabel => 'Titre du signet';

  @override
  String get playerBookmarkNoteLabel => 'Note (facultatif)';

  @override
  String get playerSaveBookmark => 'Enregistrer le signet';

  @override
  String get playerNoBookmarks => 'Aucun signet enregistré pour ce livre.';

  @override
  String get playerHistoryLabel => 'Historique';

  @override
  String get playerNoHistory =>
      'Aucun saut de lecture enregistré pour le moment.';

  @override
  String playerSmartRewindApplied(int seconds) {
    return 'Retour de $seconds s à la reprise';
  }

  @override
  String get playerStreamDirect => 'Flux direct';

  @override
  String get playerStreamHls => 'Transcodage HLS';

  @override
  String get playerBuffering => 'Mise en mémoire tampon…';

  @override
  String get playerPlaybackError => 'Impossible de démarrer la lecture audio.';

  @override
  String get playerHistoryReasonPlay => 'Démarré';

  @override
  String get playerHistoryReasonSeek => 'Déplacé';

  @override
  String get playerHistoryReasonChapter => 'Chapitre';

  @override
  String get playerHistoryReasonPause => 'En pause';

  @override
  String get playerHistoryReasonRewind => 'Retour intelligent';

  @override
  String get playerHistoryReasonBookmark => 'Signet';

  @override
  String get playerStreamLocal => 'Téléchargé';

  @override
  String downloadsStorageUsed(String size) {
    return '$size utilisés sur l\'appareil';
  }

  @override
  String get downloadsWifiOnlyTitle => 'Télécharger uniquement en Wi-Fi';

  @override
  String get downloadsWifiOnlySubtitle =>
      'Mettre automatiquement les transferts en pause sur réseau cellulaire';

  @override
  String get downloadsAutoDeleteTitle => 'Supprimer les livres terminés';

  @override
  String get downloadsAutoDeleteSubtitle =>
      'Supprimer les fichiers téléchargés une fois le livre audio terminé';

  @override
  String get downloadsClearAll => 'Tout effacer';

  @override
  String get downloadsStatusQueued => 'En file d\'attente';

  @override
  String get downloadsStatusDownloading => 'Téléchargement';

  @override
  String get downloadsStatusPaused => 'En pause';

  @override
  String get downloadsStatusCompleted => 'Téléchargé';

  @override
  String get downloadsStatusFailed => 'Échec';

  @override
  String get downloadsWaitingForWifi => 'En attente du Wi-Fi';

  @override
  String get downloadsPause => 'Pause';

  @override
  String get downloadsResume => 'Reprendre';

  @override
  String get downloadsRetry => 'Réessayer';

  @override
  String get downloadsDelete => 'Supprimer';

  @override
  String get downloadsDeleteTitle => 'Supprimer les fichiers hors ligne ?';

  @override
  String get downloadsDeleteBody =>
      'Cela supprime l\'audio téléchargé de cet appareil sans affecter votre serveur Audiobookshelf.';

  @override
  String get downloadsCancel => 'Annuler';

  @override
  String syncPendingBadge(int count) {
    return '$count en attente de synchro';
  }

  @override
  String get syncNow => 'Synchroniser';

  @override
  String get syncConflictBannerTitle => 'Conflit de progression détecté';

  @override
  String syncConflictBannerSubtitle(int count) {
    return '$count livre(s) audio ont une progression plus récente sur cet appareil et sur le serveur.';
  }

  @override
  String get syncConflictResolve => 'Résoudre';

  @override
  String get syncConflictSheetTitle => 'Choisir la position d\'écoute';

  @override
  String get syncConflictDeviceLabel => 'Cet appareil';

  @override
  String get syncConflictServerLabel => 'Serveur';

  @override
  String get syncConflictKeepDevice => 'Garder la position de l\'appareil';

  @override
  String get syncConflictUseServer => 'Utiliser la position du serveur';
}
