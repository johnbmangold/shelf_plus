import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/database/app_database.dart';
import 'package:shelf_plus/core/network/abs_api_client.dart';
import 'package:shelf_plus/core/theme/shelf_theme_tokens.dart';
import 'package:shelf_plus/core/widgets/book_cover_image.dart';
import 'package:shelf_plus/features/auth/presentation/auth_controller.dart';
import 'package:shelf_plus/features/downloads/domain/download_models.dart';
import 'package:shelf_plus/features/downloads/presentation/download_controller.dart';
import 'package:shelf_plus/features/library/domain/library_repository.dart';
import 'package:shelf_plus/features/player/presentation/player_controller.dart';
import 'package:shelf_plus/features/sync/presentation/offline_sync_controller.dart';
import 'package:shelf_plus/features/sync/presentation/sync_conflict_sheet.dart';
import 'package:shelf_plus/l10n/generated/app_localizations.dart';

/// Downloads & Offline Sync tab displaying storage usage, transfer policy
/// toggles, sync queue controls, conflict alerts, and queued/completed books.
class DownloadsScreen extends StatelessWidget {
  /// Creates a [DownloadsScreen].
  const new({
    required this.downloadController,
    required this.syncController,
    required this.playerController,
    required this.libraryRepository,
    required this.authController,
    required this.loadImageHeaders,
    required this.onOpenPlayer,
    this.enableNetworkImages = true,
    super.key,
  });

  /// Manages offline audiobook transfers and cleanup.
  final DownloadController downloadController;

  /// Manages queued offline progress/bookmark mutations and conflicts.
  final OfflineSyncController syncController;

  /// Shared player controller used to play downloaded audiobooks immediately.
  final PlayerController playerController;

  /// Library repository supplying full book details & chapters.
  final LibraryRepository libraryRepository;

  /// Auth controller supplying active server context.
  final AuthController authController;

  /// Authenticated cover headers callback.
  final Future<Map<String, String>> Function() loadImageHeaders;

  /// Opens the Full Player screen when playback starts.
  final VoidCallback onOpenPlayer;

  /// Whether cover images fetch from the network.
  final bool enableNetworkImages;

  Future<void> _confirmDeleteBook(BuildContext context, String itemId) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.downloadsDeleteTitle),
        content: Text(l10n.downloadsDeleteBody),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.downloadsCancel),
          ),
          FilledButton(
            key: Key('confirm_delete_download_$itemId'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.downloadsDelete),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await downloadController.cancelAndDeleteDownload(itemId);
    }
  }

  Future<void> _playDownloadedBook(
    BuildContext context,
    DownloadedBookRow row,
  ) async {
    final serverId = authController.session?.serverId;
    if (serverId == null) return;
    final detail = await libraryRepository
        .watchBookDetail(serverId, row.item.id)
        .first;
    if (detail == null) return;
    unawaited(
      playerController.playBook(detail.book, chapters: detail.chapters),
    );
    onOpenPlayer();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tokens = context.shelfTokens;

    return ListenableBuilder(
      listenable: Listenable.merge(<Listenable>[
        downloadController,
        syncController,
      ]),
      builder: (context, _) {
        final items = downloadController.downloads;
        final conflicts = syncController.conflicts;
        final pendingCount = syncController.pendingCount;

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.navDownloads),
            actions: <Widget>[
              if (items.isNotEmpty)
                TextButton(
                  key: const Key('downloads_clear_all_button'),
                  onPressed: () {
                    unawaited(downloadController.deleteAllDownloads());
                  },
                  child: Text(l10n.downloadsClearAll),
                ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: <Widget>[
              if (conflicts.isNotEmpty) ...<Widget>[
                Card(
                  key: const Key('downloads_conflict_banner'),
                  color: theme.colorScheme.errorContainer,
                  child: ListTile(
                    leading: Icon(
                      Icons.sync_problem_rounded,
                      color: theme.colorScheme.onErrorContainer,
                    ),
                    title: Text(
                      l10n.syncConflictBannerTitle,
                      style: TextStyle(
                        color: theme.colorScheme.onErrorContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      l10n.syncConflictBannerSubtitle(conflicts.length),
                      style: TextStyle(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                    trailing: FilledButton(
                      key: const Key('downloads_conflict_resolve_button'),
                      onPressed: () {
                        unawaited(
                          showSyncConflictSheet(
                            context: context,
                            syncController: syncController,
                          ),
                        );
                      },
                      child: Text(l10n.syncConflictResolve),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.storage_outlined),
                      title: Text(
                        l10n.downloadsStorageUsed(
                          ByteFormatter.format(
                            downloadController.totalBytesUsed,
                          ),
                        ),
                      ),
                      subtitle: pendingCount > 0
                          ? Text(l10n.syncPendingBadge(pendingCount))
                          : null,
                      trailing: FilledButton.tonal(
                        key: const Key('downloads_sync_now_button'),
                        onPressed: syncController.isFlushing
                            ? null
                            : () {
                                unawaited(
                                  syncController.flushPendingMutations(),
                                );
                              },
                        child: Text(l10n.syncNow),
                      ),
                    ),
                    const Divider(),
                    SwitchListTile(
                      key: const Key('downloads_wifi_only_switch'),
                      title: Text(l10n.downloadsWifiOnlyTitle),
                      subtitle: Text(l10n.downloadsWifiOnlySubtitle),
                      value: downloadController.wifiOnly,
                      onChanged: (value) {
                        unawaited(downloadController.setWifiOnly(value));
                      },
                    ),
                    const Divider(),
                    SwitchListTile(
                      key: const Key('downloads_auto_delete_switch'),
                      title: Text(l10n.downloadsAutoDeleteTitle),
                      subtitle: Text(l10n.downloadsAutoDeleteSubtitle),
                      value: downloadController.autoDeleteFinished,
                      onChanged: (value) {
                        unawaited(
                          downloadController.setAutoDeleteFinished(value),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (items.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.download_for_offline_outlined,
                          size: 40,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.downloadsEmptyTitle,
                          style: theme.textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.downloadsEmptySubtitle,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: tokens.subtleMetaText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                for (final row in items)
                  _DownloadBookCard(
                    row: row,
                    baseUrl: authController.session?.baseUrl ?? '',
                    loadImageHeaders: loadImageHeaders,
                    enableNetworkImages: enableNetworkImages,
                    onPlay: () {
                      unawaited(_playDownloadedBook(context, row));
                    },
                    onPause: () {
                      unawaited(
                        downloadController.pauseDownload(
                          row.task.libraryItemId,
                        ),
                      );
                    },
                    onResume: () {
                      unawaited(
                        downloadController.resumeDownload(
                          row.task.libraryItemId,
                        ),
                      );
                    },
                    onDelete: () {
                      unawaited(
                        _confirmDeleteBook(context, row.task.libraryItemId),
                      );
                    },
                  ),
            ],
          ),
        );
      },
    );
  }
}

class _DownloadBookCard extends StatefulWidget {
  const new({
    required this.row,
    required this.baseUrl,
    required this.loadImageHeaders,
    required this.enableNetworkImages,
    required this.onPlay,
    required this.onPause,
    required this.onResume,
    required this.onDelete,
  });

  final DownloadedBookRow row;
  final String baseUrl;
  final Future<Map<String, String>> Function() loadImageHeaders;
  final bool enableNetworkImages;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onDelete;

  @override
  State<_DownloadBookCard> createState() => _DownloadBookCardState();
}

class _DownloadBookCardState extends State<_DownloadBookCard> {
  late final Future<Map<String, String>> _headersFuture =
      widget.enableNetworkImages
      ? widget.loadImageHeaders()
      : Future<Map<String, String>>.value(const <String, String>{});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tokens = context.shelfTokens;
    final task = widget.row.task;
    final item = widget.row.item;
    final status = parseDownloadStatus(task.status);
    final ratio = task.totalBytes > 0
        ? (task.bytesDownloaded / task.totalBytes).clamp(0.0, 1.0)
        : (status == DownloadStatus.completed ? 1.0 : 0.0);

    final statusLabel = switch (status) {
      DownloadStatus.queued => l10n.downloadsStatusQueued,
      DownloadStatus.downloading => l10n.downloadsStatusDownloading,
      DownloadStatus.paused =>
        task.errorMessage == DownloadController.waitingForWifiMarker
            ? l10n.downloadsWaitingForWifi
            : l10n.downloadsStatusPaused,
      DownloadStatus.completed => l10n.downloadsStatusCompleted,
      DownloadStatus.failed => l10n.downloadsStatusFailed,
    };

    final coverUrl = item.hasCover && widget.baseUrl.isNotEmpty
        ? AbsApiClient.buildCoverUrl(baseUrl: widget.baseUrl, itemId: item.id)
        : null;

    return Card(
      key: Key('download_card_${item.id}'),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                FutureBuilder<Map<String, String>>(
                  future: _headersFuture,
                  builder: (context, snapshot) {
                    return BookCoverImage(
                      title: item.title,
                      size: 56,
                      coverUrl: coverUrl,
                      headers: snapshot.data ?? const <String, String>{},
                      enableNetworkImage: widget.enableNetworkImages,
                      borderRadius: 10,
                    );
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.title,
                        style: theme.textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.authors.isNotEmpty)
                        Text(
                          item.authors,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: tokens.subtleMetaText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 4),
                      Text(
                        _formatProgressLine(statusLabel, task),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: status == DownloadStatus.failed
                              ? theme.colorScheme.error
                              : tokens.subtleMetaText,
                        ),
                      ),
                    ],
                  ),
                ),
                if (status == DownloadStatus.completed)
                  IconButton(
                    key: Key('download_play_${item.id}'),
                    tooltip: l10n.playerPlay,
                    onPressed: widget.onPlay,
                    icon: const Icon(Icons.play_arrow_rounded),
                  )
                else if (status == DownloadStatus.downloading ||
                    status == DownloadStatus.queued)
                  IconButton(
                    key: Key('download_pause_${item.id}'),
                    tooltip: l10n.downloadsPause,
                    onPressed: widget.onPause,
                    icon: const Icon(Icons.pause_rounded),
                  )
                else
                  IconButton(
                    key: Key('download_resume_${item.id}'),
                    tooltip: status == DownloadStatus.failed
                        ? l10n.downloadsRetry
                        : l10n.downloadsResume,
                    onPressed: widget.onResume,
                    icon: const Icon(Icons.refresh_rounded),
                  ),
                IconButton(
                  key: Key('download_delete_${item.id}'),
                  tooltip: l10n.downloadsDelete,
                  onPressed: widget.onDelete,
                  icon: const Icon(Icons.delete_outline_rounded),
                ),
              ],
            ),
            if (status != DownloadStatus.completed) ...<Widget>[
              const SizedBox(height: 10),
              LinearProgressIndicator(value: ratio),
            ],
          ],
        ),
      ),
    );
  }

  static String _formatProgressLine(String statusLabel, DownloadTask task) {
    final downloaded = ByteFormatter.format(task.bytesDownloaded);
    if (task.totalBytes <= 0) {
      return '$statusLabel • $downloaded';
    }
    return '$statusLabel • $downloaded / ${ByteFormatter.format(task.totalBytes)}';
  }
}
