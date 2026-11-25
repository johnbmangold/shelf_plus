import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/theme/shelf_theme_tokens.dart';
import 'package:shelf_plus/core/widgets/book_cover_image.dart';
import 'package:shelf_plus/features/library/domain/library_models.dart';
import 'package:shelf_plus/features/player/presentation/player_controller.dart';
import 'package:shelf_plus/l10n/generated/app_localizations.dart';

/// Persistent mini-player bar pinned above the bottom [NavigationBar].
class MiniPlayerBar extends StatelessWidget {
  /// Creates a [MiniPlayerBar].
  const new({
    required this.playerController,
    required this.onOpenPlayer,
    this.enableNetworkImages = true,
    super.key,
  });

  /// Shared application player controller.
  final PlayerController playerController;

  /// Invoked when the user taps the mini-player to open the full player.
  final VoidCallback onOpenPlayer;

  /// Whether network cover fetching is enabled.
  final bool enableNetworkImages;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: playerController,
      builder: (context, _) {
        final book = playerController.activeBook;
        if (book == null) {
          return _IdleMiniPlayer(tokens: context.shelfTokens);
        }
        return _ActiveMiniPlayer(
          book: book,
          controller: playerController,
          onOpenPlayer: onOpenPlayer,
          enableNetworkImages: enableNetworkImages,
        );
      },
    );
  }
}

class _IdleMiniPlayer extends StatelessWidget {
  const new({required this.tokens});

  final ShelfThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.miniPlayerSurface,
        border: Border(top: BorderSide(color: tokens.hairlineBorder)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: tokens.hairlineBorder),
              ),
              child: Icon(
                Icons.headphones_outlined,
                color: tokens.subtleMetaText,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    l10n.miniPlayerIdleTitle,
                    style: theme.textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    l10n.miniPlayerIdleSubtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: tokens.subtleMetaText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveMiniPlayer extends StatelessWidget {
  const new({
    required this.book,
    required this.controller,
    required this.onOpenPlayer,
    required this.enableNetworkImages,
  });

  final BookSummary book;
  final PlayerController controller;
  final VoidCallback onOpenPlayer;
  final bool enableNetworkImages;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.shelfTokens;
    final theme = Theme.of(context);
    final chapter = controller.currentChapter;
    final subtitle = chapter?.title.isNotEmpty == true
        ? chapter!.title
        : (book.authorsDisplay.isEmpty
              ? DurationFormatter.formatTimestamp(controller.positionSec)
              : book.authorsDisplay);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.miniPlayerSurface,
        border: Border(top: BorderSide(color: tokens.hairlineBorder)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          LinearProgressIndicator(
            key: const Key('mini_player_progress'),
            value: controller.progressRatio,
            minHeight: 2.5,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            semanticsLabel: book.title,
            semanticsValue: '${(controller.progressRatio * 100).round()}%',
          ),
          Semantics(
            container: true,
            label: '${book.title}, $subtitle',
            hint: l10n.playerTitle,
            child: InkWell(
              key: const Key('mini_player_bar'),
              onTap: onOpenPlayer,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: <Widget>[
                    BookCoverImage(
                      title: book.title,
                      size: 42,
                      coverUrl: controller.activeCoverUrl,
                      headers: controller.activeCoverHeaders,
                      enableNetworkImage: enableNetworkImages,
                      borderRadius: 8,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            book.title,
                            style: theme.textTheme.titleSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            controller.isBusy ? l10n.playerBuffering : subtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: tokens.subtleMetaText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      key: const Key('mini_player_rewind_button'),
                      tooltip: l10n.playerRewindSeconds(15),
                      onPressed: () {
                        unawaited(controller.rewind());
                      },
                      icon: const Icon(Icons.replay_10_rounded),
                    ),
                    IconButton.filled(
                      key: const Key('mini_player_play_pause_button'),
                      tooltip: controller.isPlaying
                          ? l10n.playerPause
                          : l10n.playerPlay,
                      onPressed: () {
                        unawaited(controller.togglePlayPause());
                      },
                      icon: Icon(
                        controller.isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
