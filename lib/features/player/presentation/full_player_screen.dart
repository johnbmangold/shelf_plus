import 'dart:async';
import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/network/abs_playback_models.dart';
import 'package:shelf_plus/core/theme/app_theme.dart';
import 'package:shelf_plus/core/theme/shelf_theme_tokens.dart';
import 'package:shelf_plus/core/theme/theme_controller.dart';
import 'package:shelf_plus/core/widgets/book_cover_image.dart';
import 'package:shelf_plus/features/library/domain/library_models.dart';
import 'package:shelf_plus/features/player/domain/sleep_timer_controller.dart';
import 'package:shelf_plus/features/player/presentation/player_controller.dart';
import 'package:shelf_plus/l10n/generated/app_localizations.dart';

/// Scrubbing scope supported on the Full Player timeline slider.
enum PlayerScrubberMode {
  /// Scrubs within the active chapter boundaries.
  chapter,

  /// Scrubs across the entire audiobook duration.
  book,
}

/// Full-screen audiobook player featuring dynamic cover theming, dual
/// chapter/book scrubbing, speed & Android-only skip silence, smart rewind,
/// sleep timer with fade + shake-to-extend grace banner, chapters,
/// bookmarks with notes, and playback jump history.
class FullPlayerScreen extends StatefulWidget {
  /// Creates a [FullPlayerScreen].
  const new({
    required this.playerController,
    required this.themeController,
    this.enableNetworkImages = true,
    super.key,
  });

  /// Shared application player controller.
  final PlayerController playerController;

  /// App theme controller (used to preserve true-black AMOLED surfaces).
  final ThemeController themeController;

  /// Whether network cover fetching is enabled.
  final bool enableNetworkImages;

  @override
  State<FullPlayerScreen> createState() => _FullPlayerScreenState();
}

class _FullPlayerScreenState extends State<FullPlayerScreen> {
  PlayerScrubberMode _scrubMode = PlayerScrubberMode.book;
  double? _dragRatio;

  ThemeData _resolveTheme(BuildContext context) {
    final baseTheme = Theme.of(context);
    final isDark = baseTheme.brightness == Brightness.dark;
    final dynamicScheme = isDark
        ? widget.playerController.dynamicDarkScheme
        : widget.playerController.dynamicLightScheme;
    return AppTheme.applyDynamicScheme(
      baseTheme: baseTheme,
      scheme: dynamicScheme,
      amoled: isDark && widget.themeController.isAmoled,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.playerController,
      builder: (context, _) {
        final l10n = AppLocalizations.of(context);
        final themed = _resolveTheme(context);
        final book = widget.playerController.activeBook;

        return Theme(
          data: themed,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                key: const Key('player_close_button'),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 30),
              ),
              title: Text(l10n.playerTitle),
              centerTitle: true,
              actions: <Widget>[
                if (widget.playerController.playMethod != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Center(
                      child: _StreamBadge(
                        playMethod: widget.playerController.playMethod!,
                      ),
                    ),
                  ),
              ],
            ),
            body: book == null
                ? _EmptyPlayerState(l10n: l10n)
                : _ActivePlayerBody(
                    book: book,
                    controller: widget.playerController,
                    enableNetworkImages: widget.enableNetworkImages,
                    scrubMode: _scrubMode,
                    dragRatio: _dragRatio,
                    onScrubModeChanged: (mode) {
                      setState(() {
                        _scrubMode = mode;
                        _dragRatio = null;
                      });
                    },
                    onScrubChanged: (value) {
                      setState(() {
                        _dragRatio = value;
                      });
                    },
                    onScrubCommitted: (value, startSec, spanSec) {
                      setState(() {
                        _dragRatio = null;
                      });
                      final targetSec = startSec + (value * spanSec);
                      unawaited(
                        widget.playerController.seekToBookPosition(targetSec),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}

class _StreamBadge extends StatelessWidget {
  const new({required this.playMethod});

  final AbsPlayMethod playMethod;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isHls = playMethod == AbsPlayMethod.transcode;
    return Container(
      key: const Key('player_stream_badge'),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isHls ? l10n.playerStreamHls : l10n.playerStreamDirect,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSecondaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmptyPlayerState extends StatelessWidget {
  const new({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.shelfTokens;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.headphones_outlined,
              size: 56,
              color: tokens.subtleMetaText,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.playerNoActiveBook,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.playerNoActiveBookBody,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: tokens.subtleMetaText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivePlayerBody extends StatelessWidget {
  const new({
    required this.book,
    required this.controller,
    required this.enableNetworkImages,
    required this.scrubMode,
    required this.dragRatio,
    required this.onScrubModeChanged,
    required this.onScrubChanged,
    required this.onScrubCommitted,
  });

  final BookSummary book;
  final PlayerController controller;
  final bool enableNetworkImages;
  final PlayerScrubberMode scrubMode;
  final double? dragRatio;
  final ValueChanged<PlayerScrubberMode> onScrubModeChanged;
  final ValueChanged<double> onScrubChanged;
  final void Function(double ratio, double startSec, double spanSec)
  onScrubCommitted;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tokens = context.shelfTokens;
    final chapter = controller.currentChapter;
    final hasChapterSpan =
        scrubMode == PlayerScrubberMode.chapter &&
        chapter != null &&
        chapter.durationSec > 0;
    final rangeStartSec = hasChapterSpan ? chapter.startSec : 0.0;
    final rangeSpanSec = hasChapterSpan
        ? chapter.durationSec
        : (controller.durationSec > 0 ? controller.durationSec : 1.0);
    final currentOffsetSec = (controller.positionSec - rangeStartSec).clamp(
      0.0,
      rangeSpanSec,
    );
    final activeRatio =
        dragRatio ?? (currentOffsetSec / rangeSpanSec).clamp(0.0, 1.0);
    final displayElapsedSec = activeRatio * rangeSpanSec;
    final displayRemainingSec = (rangeSpanSec - displayElapsedSec).clamp(
      0.0,
      rangeSpanSec,
    );
    final remainingLabel =
        '-${DurationFormatter.formatTimestamp(displayRemainingSec)}';
    final sleepTimer = controller.sleepTimer;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final artworkSize = math
              .min(constraints.maxWidth * 0.56, constraints.maxHeight * 0.34)
              .clamp(120.0, 250.0);
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: BookCoverImage(
                    title: book.title,
                    size: artworkSize,
                    coverUrl: controller.activeCoverUrl,
                    headers: controller.activeCoverHeaders,
                    enableNetworkImage: enableNetworkImages,
                    borderRadius: 18,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  book.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  book.authorsDisplay,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: tokens.subtleMetaText,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (chapter != null) ...<Widget>[
                  const SizedBox(height: 6),
                  Text(
                    chapter.title,
                    key: const Key('player_current_chapter'),
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (controller.lastSmartRewindSeconds != null) ...<Widget>[
                  const SizedBox(height: 10),
                  Center(
                    child: Chip(
                      key: const Key('player_smart_rewind_badge'),
                      avatar: const Icon(Icons.replay_rounded, size: 16),
                      label: Text(
                        l10n.playerSmartRewindApplied(
                          controller.lastSmartRewindSeconds!,
                        ),
                      ),
                    ),
                  ),
                ],
                if (sleepTimer.isFadeOrGraceActive) ...<Widget>[
                  const SizedBox(height: 10),
                  Card(
                    key: const Key('player_sleep_grace_banner'),
                    color: theme.colorScheme.tertiaryContainer,
                    child: ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.vibration_rounded,
                        color: theme.colorScheme.onTertiaryContainer,
                      ),
                      title: Text(
                        l10n.playerSleepGraceHint(
                          sleepTimer.defaultExtendDuration.inMinutes,
                        ),
                        style: TextStyle(
                          color: theme.colorScheme.onTertiaryContainer,
                        ),
                      ),
                      trailing: TextButton(
                        onPressed: () {
                          unawaited(sleepTimer.extend());
                        },
                        child: Text(
                          '+${sleepTimer.defaultExtendDuration.inMinutes}m',
                        ),
                      ),
                    ),
                  ),
                ],
                if (controller.errorMessage != null) ...<Widget>[
                  const SizedBox(height: 10),
                  MaterialBanner(
                    content: Text(controller.errorMessage!),
                    actions: const <Widget>[SizedBox.shrink()],
                  ),
                ],
                const SizedBox(height: 14),
                Center(
                  child: SegmentedButton<PlayerScrubberMode>(
                    key: const Key('player_scrubber_mode'),
                    segments: <ButtonSegment<PlayerScrubberMode>>[
                      ButtonSegment<PlayerScrubberMode>(
                        value: PlayerScrubberMode.book,
                        label: Text(l10n.playerScrubBook),
                      ),
                      ButtonSegment<PlayerScrubberMode>(
                        value: PlayerScrubberMode.chapter,
                        enabled: chapter != null,
                        label: Text(l10n.playerScrubChapter),
                      ),
                    ],
                    selected: <PlayerScrubberMode>{
                      if (hasChapterSpan)
                        PlayerScrubberMode.chapter
                      else
                        PlayerScrubberMode.book,
                    },
                    onSelectionChanged: (selection) {
                      onScrubModeChanged(selection.first);
                    },
                  ),
                ),
                Slider(
                  key: const Key('player_timeline_slider'),
                  value: activeRatio,
                  onChanged: onScrubChanged,
                  onChangeEnd: (value) {
                    onScrubCommitted(value, rangeStartSec, rangeSpanSec);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        DurationFormatter.formatTimestamp(displayElapsedSec),
                        key: const Key('player_elapsed_text'),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: tokens.subtleMetaText,
                        ),
                      ),
                      Text(
                        remainingLabel,
                        key: const Key('player_remaining_text'),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: tokens.subtleMetaText,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      key: const Key('player_prev_chapter_button'),
                      tooltip: l10n.playerPreviousChapter,
                      onPressed: controller.chapters.isEmpty
                          ? null
                          : () {
                              unawaited(controller.previousChapter());
                            },
                      icon: const Icon(Icons.skip_previous_rounded, size: 30),
                    ),
                    IconButton(
                      key: const Key('player_rewind_button'),
                      tooltip: l10n.playerRewindSeconds(15),
                      onPressed: () {
                        unawaited(controller.rewind());
                      },
                      icon: const Icon(Icons.replay_10_rounded, size: 34),
                    ),
                    SizedBox(
                      width: 68,
                      height: 68,
                      child: FilledButton(
                        key: const Key('player_play_pause_button'),
                        style: FilledButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {
                          unawaited(controller.togglePlayPause());
                        },
                        child: Icon(
                          controller.isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          size: 38,
                        ),
                      ),
                    ),
                    IconButton(
                      key: const Key('player_forward_button'),
                      tooltip: l10n.playerForwardSeconds(30),
                      onPressed: () {
                        unawaited(controller.forward());
                      },
                      icon: const Icon(Icons.forward_30_rounded, size: 34),
                    ),
                    IconButton(
                      key: const Key('player_next_chapter_button'),
                      tooltip: l10n.playerNextChapter,
                      onPressed: controller.chapters.isEmpty
                          ? null
                          : () {
                              unawaited(controller.nextChapter());
                            },
                      icon: const Icon(Icons.skip_next_rounded, size: 30),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    _PlayerToolButton(
                      buttonKey: const Key('player_speed_button'),
                      icon: Icons.speed_rounded,
                      label: l10n.playerSpeedLabel(
                        controller.speed.toStringAsFixed(2),
                      ),
                      onPressed: () => _showSpeedSheet(context, controller),
                    ),
                    _PlayerToolButton(
                      buttonKey: const Key('player_sleep_button'),
                      icon: Icons.bedtime_outlined,
                      label: sleepTimer.phase == SleepTimerPhase.off
                          ? l10n.playerSleepTimerLabel
                          : DurationFormatter.formatTimestamp(
                              sleepTimer.remaining.inSeconds.toDouble(),
                            ),
                      onPressed: () =>
                          _showSleepTimerSheet(context, controller),
                    ),
                    _PlayerToolButton(
                      buttonKey: const Key('player_chapters_button'),
                      icon: Icons.format_list_bulleted_rounded,
                      label: l10n.playerChaptersLabel,
                      onPressed: () => _showChaptersSheet(context, controller),
                    ),
                    _PlayerToolButton(
                      buttonKey: const Key('player_bookmarks_button'),
                      icon: Icons.bookmark_outline_rounded,
                      label: l10n.playerBookmarksLabel,
                      onPressed: () => _showBookmarksSheet(context, controller),
                    ),
                    _PlayerToolButton(
                      buttonKey: const Key('player_history_button'),
                      icon: Icons.history_rounded,
                      label: l10n.playerHistoryLabel,
                      onPressed: () => _showHistorySheet(context, controller),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PlayerToolButton extends StatelessWidget {
  const new({
    required this.buttonKey,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final Key buttonKey;
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      key: buttonKey,
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}

Future<void> _showSpeedSheet(
  BuildContext context,
  PlayerController controller,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      return ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final l10n = AppLocalizations.of(context);
          final theme = Theme.of(context);
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    '${l10n.playerSpeedSheetTitle}: '
                    '${controller.speed.toStringAsFixed(2)}x',
                    style: theme.textTheme.titleMedium,
                  ),
                  Slider(
                    key: const Key('player_speed_slider'),
                    min: 0.5,
                    max: 3,
                    divisions: 50,
                    value: controller.speed.clamp(0.5, 3),
                    label: '${controller.speed.toStringAsFixed(2)}x',
                    onChanged: (value) {
                      unawaited(controller.setSpeed(value));
                    },
                  ),
                  Wrap(
                    spacing: 8,
                    children: const <double>[0.8, 1, 1.25, 1.5, 2]
                        .map(
                          (preset) => ActionChip(
                            label: Text('${preset}x'),
                            onPressed: () {
                              unawaited(controller.setSpeed(preset));
                            },
                          ),
                        )
                        .toList(growable: false),
                  ),
                  if (controller.supportsSkipSilence) ...<Widget>[
                    const SizedBox(height: 12),
                    SwitchListTile(
                      key: const Key('player_skip_silence_switch'),
                      title: Text(l10n.playerSkipSilenceLabel),
                      subtitle: Text(l10n.playerSkipSilenceSubtitle),
                      value: controller.skipSilence,
                      onChanged: (value) {
                        unawaited(controller.setSkipSilence(value));
                      },
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Future<void> _showSleepTimerSheet(
  BuildContext context,
  PlayerController controller,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      return ListenableBuilder(
        listenable: controller.sleepTimer,
        builder: (context, _) {
          final l10n = AppLocalizations.of(context);
          final sleepTimer = controller.sleepTimer;
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    l10n.playerSleepTimerLabel,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    key: const Key('sleep_option_off'),
                    title: Text(l10n.playerSleepOff),
                    onTap: () {
                      unawaited(sleepTimer.cancel());
                      Navigator.of(context).pop();
                    },
                  ),
                  for (final minutes in const <int>[10, 15, 30, 45, 60])
                    ListTile(
                      key: Key('sleep_option_${minutes}m'),
                      title: Text(l10n.playerSleepMinutes(minutes)),
                      onTap: () {
                        unawaited(
                          sleepTimer.startDuration(Duration(minutes: minutes)),
                        );
                        Navigator.of(context).pop();
                      },
                    ),
                  ListTile(
                    key: const Key('sleep_option_eoc'),
                    title: Text(l10n.playerSleepEndOfChapter),
                    onTap: () {
                      unawaited(
                        sleepTimer.startEndOfChapter(
                          currentPositionSec: controller.positionSec,
                          activeChapterEndSec:
                              controller.currentChapter?.endSec,
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Future<void> _showChaptersSheet(
  BuildContext context,
  PlayerController controller,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      final l10n = AppLocalizations.of(sheetContext);
      final chapters = controller.chapters;
      final activeIndex = controller.currentChapterIndex;
      return SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(sheetContext).height * 0.6,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.playerChaptersLabel,
                  style: Theme.of(sheetContext).textTheme.titleMedium,
                ),
              ),
              Expanded(
                child: chapters.isEmpty
                    ? Center(child: Text(l10n.bookDetailNoChapters))
                    : ListView.builder(
                        itemCount: chapters.length,
                        itemBuilder: (context, index) {
                          final chapter = chapters[index];
                          final isCurrent = index == activeIndex;
                          return ListTile(
                            key: Key('player_chapter_tile_$index'),
                            selected: isCurrent,
                            leading: Icon(
                              isCurrent
                                  ? Icons.equalizer_rounded
                                  : Icons.play_arrow_outlined,
                            ),
                            title: Text(chapter.title),
                            trailing: Text(
                              DurationFormatter.formatTimestamp(
                                chapter.startSec,
                              ),
                            ),
                            onTap: () {
                              unawaited(controller.jumpToChapter(chapter));
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _showBookmarksSheet(
  BuildContext context,
  PlayerController controller,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) => _BookmarksSheetContent(controller: controller),
  );
}

class _BookmarksSheetContent extends StatefulWidget {
  const new({required this.controller});

  final PlayerController controller;

  @override
  State<_BookmarksSheetContent> createState() => _BookmarksSheetContentState();
}

class _BookmarksSheetContentState extends State<_BookmarksSheetContent> {
  late final TextEditingController _titleController = TextEditingController(
    text: widget.controller.currentChapter?.title ?? '',
  );
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final l10n = AppLocalizations.of(context);
        final bookmarks = controller.bookmarks;
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
              bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    l10n.playerBookmarksLabel,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    key: const Key('player_bookmark_title_field'),
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: l10n.playerBookmarkTitleLabel,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    key: const Key('player_bookmark_note_field'),
                    controller: _noteController,
                    decoration: InputDecoration(
                      labelText: l10n.playerBookmarkNoteLabel,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    key: const Key('player_save_bookmark_button'),
                    onPressed: () {
                      unawaited(
                        controller.createBookmark(
                          title: _titleController.text,
                          note: _noteController.text,
                        ),
                      );
                      _noteController.clear();
                    },
                    icon: const Icon(Icons.bookmark_add_outlined),
                    label: Text(l10n.playerSaveBookmark),
                  ),
                  const SizedBox(height: 12),
                  if (bookmarks.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        l10n.playerNoBookmarks,
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    for (final bookmark in bookmarks)
                      ListTile(
                        title: Text(bookmark.title),
                        subtitle: bookmark.note == null
                            ? null
                            : Text(bookmark.note!),
                        leading: Text(
                          DurationFormatter.formatTimestamp(bookmark.timeSec),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline_rounded),
                          onPressed: () {
                            unawaited(
                              controller.deleteBookmark(bookmark.timeSec),
                            );
                          },
                        ),
                        onTap: () {
                          unawaited(controller.jumpToBookmark(bookmark));
                          Navigator.of(context).pop();
                        },
                      ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Future<void> _showHistorySheet(
  BuildContext context,
  PlayerController controller,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      return ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final l10n = AppLocalizations.of(context);
          final history = controller.history;
          return SafeArea(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.55,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      l10n.playerHistoryLabel,
                      style: Theme.of(sheetContext).textTheme.titleMedium,
                    ),
                  ),
                  Expanded(
                    child: history.isEmpty
                        ? Center(child: Text(l10n.playerNoHistory))
                        : ListView.builder(
                            itemCount: history.length,
                            itemBuilder: (context, index) {
                              final entry = history[index];
                              return ListTile(
                                key: Key('player_history_tile_$index'),
                                leading: Text(
                                  DurationFormatter.formatTimestamp(
                                    entry.positionSec,
                                  ),
                                ),
                                title: Text(_reasonLabel(l10n, entry.reason)),
                                onTap: () {
                                  unawaited(controller.jumpToHistory(entry));
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

String _reasonLabel(AppLocalizations l10n, String reason) {
  return switch (reason) {
    'play' => l10n.playerHistoryReasonPlay,
    'seek' => l10n.playerHistoryReasonSeek,
    'chapter' => l10n.playerHistoryReasonChapter,
    'pause' => l10n.playerHistoryReasonPause,
    'rewind' => l10n.playerHistoryReasonRewind,
    'bookmark' => l10n.playerHistoryReasonBookmark,
    _ => reason,
  };
}
