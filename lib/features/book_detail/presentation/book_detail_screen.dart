import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/theme/app_theme.dart';
import 'package:shelf_plus/core/theme/dynamic_cover_theme_service.dart';
import 'package:shelf_plus/core/theme/shelf_theme_tokens.dart';
import 'package:shelf_plus/core/theme/theme_controller.dart';
import 'package:shelf_plus/core/widgets/book_cover_image.dart';
import 'package:shelf_plus/features/auth/presentation/auth_controller.dart';
import 'package:shelf_plus/features/book_detail/presentation/book_detail_view_model.dart';
import 'package:shelf_plus/features/library/domain/library_models.dart';
import 'package:shelf_plus/features/library/domain/library_repository.dart';
import 'package:shelf_plus/l10n/generated/app_localizations.dart';

/// Book Detail screen featuring dynamic cover-art theming, editorial header,
/// action buttons, and Overview / Chapters / Bookmarks tabs.
class BookDetailScreen extends StatefulWidget {
  /// Creates a [BookDetailScreen].
  const new({
    required this.itemId,
    required this.libraryRepository,
    required this.authController,
    required this.coverThemeExtractor,
    required this.themeController,
    required this.loadImageHeaders,
    required this.logger,
    this.enableNetworkImages = true,
    this.autoFetchDetail = true,
    super.key,
  });

  /// Library item ID to display.
  final String itemId;

  /// Library repository supplying reactive item details.
  final LibraryRepository libraryRepository;

  /// Auth controller supplying the active server session.
  final AuthController authController;

  /// Service extracting dynamic cover palettes.
  final CoverThemeExtractor coverThemeExtractor;

  /// App theme controller (used to preserve true-black AMOLED surfaces).
  final ThemeController themeController;

  /// Callback returning authenticated cover headers.
  final Future<Map<String, String>> Function() loadImageHeaders;

  /// Application logger.
  final AppLogger logger;

  /// Whether network cover fetching is enabled.
  final bool enableNetworkImages;

  /// Whether expanded chapters should be fetched automatically when missing.
  final bool autoFetchDetail;

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  BookDetailViewModel? _viewModel;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final brightness = Theme.of(context).brightness;
    if (!_started) {
      _started = true;
      final session = widget.authController.session;
      if (session != null) {
        _viewModel =
            BookDetailViewModel(
              libraryRepository: widget.libraryRepository,
              coverThemeExtractor: widget.coverThemeExtractor,
              session: session,
              itemId: widget.itemId,
              loadImageHeaders: widget.loadImageHeaders,
              logger: widget.logger,
            )..start(
              brightness: brightness,
              autoFetchDetail: widget.autoFetchDetail,
            );
      }
    } else {
      _viewModel?.updateBrightness(brightness);
    }
  }

  @override
  void dispose() {
    _viewModel?.dispose();
    super.dispose();
  }

  ThemeData _applyDynamicPalette(
    ThemeData baseTheme,
    ColorScheme? dynamicScheme,
  ) {
    if (dynamicScheme == null) return baseTheme;

    final isAmoled =
        baseTheme.brightness == Brightness.dark &&
        widget.themeController.isAmoled;
    final adjustedScheme = isAmoled
        ? dynamicScheme.copyWith(
            surface: Colors.black,
            surfaceContainerLowest: Colors.black,
            surfaceContainerLow: const Color(0xFF0A0A0B),
            surfaceContainer: const Color(0xFF111113),
          )
        : dynamicScheme;

    final baseTokens = baseTheme.extension<ShelfThemeTokens>();
    final updatedTokens = baseTokens?.copyWith(
      progressFill: adjustedScheme.primary,
    );

    return baseTheme.copyWith(
      colorScheme: adjustedScheme,
      scaffoldBackgroundColor: isAmoled ? Colors.black : adjustedScheme.surface,
      appBarTheme: baseTheme.appBarTheme.copyWith(
        backgroundColor: isAmoled ? Colors.black : adjustedScheme.surface,
        foregroundColor: adjustedScheme.onSurface,
      ),
      extensions: updatedTokens != null
          ? <ThemeExtension<dynamic>>[updatedTokens]
          : baseTheme.extensions.values,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final vm = _viewModel;
    final baseTheme = Theme.of(context);

    if (vm == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.bookDetailNotFound)),
      );
    }

    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) {
        final themed = _applyDynamicPalette(baseTheme, vm.dynamicScheme);
        return AnimatedTheme(
          data: themed,
          child: Builder(
            builder: (themedContext) {
              final detail = vm.detail;
              if (!vm.hasLoadedInitial) {
                return Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: CircularProgressIndicator()),
                );
              }
              if (detail == null) {
                return Scaffold(
                  appBar: AppBar(),
                  body: Center(child: Text(l10n.bookDetailNotFound)),
                );
              }
              return _BookDetailView(
                detail: detail,
                coverUrl: vm.coverUrl,
                headers: vm.imageHeaders,
                enableNetworkImages: widget.enableNetworkImages,
                isLoadingDetail: vm.isLoadingDetail,
              );
            },
          ),
        );
      },
    );
  }
}

class _BookDetailView extends StatelessWidget {
  const new({
    required this.detail,
    required this.coverUrl,
    required this.headers,
    required this.enableNetworkImages,
    required this.isLoadingDetail,
  });

  final BookDetail detail;
  final String? coverUrl;
  final Map<String, String> headers;
  final bool enableNetworkImages;
  final bool isLoadingDetail;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tokens = context.shelfTokens;
    final book = detail.book;
    final isInProgress = book.progress?.isInProgress ?? false;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(book.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        BookCoverImage(
                          title: book.title,
                          size: 124,
                          coverUrl: coverUrl,
                          headers: headers,
                          enableNetworkImage: enableNetworkImages,
                          borderRadius: 16,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                book.title,
                                style: theme.textTheme.headlineSmall,
                              ),
                              if (book.subtitle != null) ...<Widget>[
                                const SizedBox(height: 4),
                                Text(
                                  book.subtitle!,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: tokens.subtleMetaText,
                                  ),
                                ),
                              ],
                              if (book.authorsDisplay.isNotEmpty) ...<Widget>[
                                const SizedBox(height: 8),
                                Text(
                                  book.authorsDisplay,
                                  style: theme.textTheme.titleSmall,
                                ),
                              ],
                              if (book.narratorsDisplay.isNotEmpty) ...<Widget>[
                                const SizedBox(height: 2),
                                Text(
                                  l10n.bookDetailNarratedBy(
                                    book.narratorsDisplay,
                                  ),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: tokens.subtleMetaText,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 8),
                              Text(
                                isInProgress
                                    ? l10n.bookTimeLeft(
                                        DurationFormatter.formatShort(
                                          book.remainingSec,
                                        ),
                                      )
                                    : DurationFormatter.formatShort(
                                        book.durationSec,
                                      ),
                                style: AppTheme.tabularFigureStyle(
                                  theme.textTheme.labelMedium!.copyWith(
                                    color: tokens.subtleMetaText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: FilledButton.icon(
                            key: const Key('book_detail_play_button'),
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      l10n.bookDetailPlaybackPhase3,
                                    ),
                                  ),
                                );
                            },
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: Text(
                              isInProgress
                                  ? l10n.bookDetailResume
                                  : l10n.bookDetailPlay,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          key: const Key('book_detail_download_button'),
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(l10n.bookDetailDownloadPhase4),
                                ),
                              );
                          },
                          icon: const Icon(Icons.download_outlined),
                          label: Text(l10n.bookDetailDownload),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarHeaderDelegate(
                TabBar(
                  tabs: <Widget>[
                    Tab(text: l10n.bookDetailOverviewTab),
                    Tab(text: l10n.bookDetailChaptersTab),
                    Tab(text: l10n.bookDetailBookmarksTab),
                  ],
                ),
                backgroundColor: theme.scaffoldBackgroundColor,
              ),
            ),
          ],
          body: TabBarView(
            children: <Widget>[
              _OverviewTab(book: book),
              _ChaptersTab(
                chapters: detail.chapters,
                isLoading: isLoadingDetail,
              ),
              _BookmarksTab(bookmarks: detail.bookmarks),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  const new(this.tabBar, {required this.backgroundColor});

  final TabBar tabBar;
  final Color backgroundColor;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(color: backgroundColor, child: tabBar);
  }

  @override
  bool shouldRebuild(_TabBarHeaderDelegate oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.tabBar != tabBar;
  }
}

class _OverviewTab extends StatelessWidget {
  const new({required this.book});

  final BookSummary book;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tokens = context.shelfTokens;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        Text(
          book.description ?? l10n.bookDetailNoDescription,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        Card(
          child: Column(
            children: <Widget>[
              if (book.seriesName != null) ...<Widget>[
                ListTile(
                  title: Text(l10n.bookDetailSeriesLabel),
                  trailing: Text(
                    book.seriesSequence != null
                        ? '${book.seriesName} #${book.seriesSequence}'
                        : book.seriesName!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: tokens.subtleMetaText,
                    ),
                  ),
                ),
                const Divider(),
              ],
              if (book.publisher != null) ...<Widget>[
                ListTile(
                  title: Text(l10n.bookDetailPublisherLabel),
                  trailing: Text(
                    book.publisher!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: tokens.subtleMetaText,
                    ),
                  ),
                ),
                const Divider(),
              ],
              if (book.publishedYear != null) ...<Widget>[
                ListTile(
                  title: Text(l10n.bookDetailPublishedLabel),
                  trailing: Text(
                    book.publishedYear!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: tokens.subtleMetaText,
                    ),
                  ),
                ),
                const Divider(),
              ],
              if (book.genres.isNotEmpty)
                ListTile(
                  title: Text(l10n.bookDetailGenresLabel),
                  subtitle: Text(book.genres.join(', ')),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChaptersTab extends StatelessWidget {
  const new({required this.chapters, required this.isLoading});

  final List<ChapterInfo> chapters;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tokens = context.shelfTokens;

    if (chapters.isEmpty) {
      return Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Text(
                l10n.bookDetailNoChapters,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: tokens.subtleMetaText,
                ),
              ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: chapters.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final chapter = chapters[index];
        return ListTile(
          title: Text(chapter.title),
          trailing: Text(
            DurationFormatter.formatTimestamp(chapter.startSec),
            style: AppTheme.tabularFigureStyle(
              theme.textTheme.labelMedium!.copyWith(
                color: tokens.subtleMetaText,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BookmarksTab extends StatelessWidget {
  const new({required this.bookmarks});

  final List<BookmarkEntry> bookmarks;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tokens = context.shelfTokens;

    if (bookmarks.isEmpty) {
      return Center(
        child: Text(
          l10n.bookDetailNoBookmarks,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: tokens.subtleMetaText,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: bookmarks.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final bookmark = bookmarks[index];
        return ListTile(
          leading: const Icon(Icons.bookmark_outline),
          title: Text(bookmark.title),
          subtitle: bookmark.note != null ? Text(bookmark.note!) : null,
          trailing: Text(
            DurationFormatter.formatTimestamp(bookmark.timeSec),
            style: AppTheme.tabularFigureStyle(
              theme.textTheme.labelMedium!.copyWith(
                color: tokens.subtleMetaText,
              ),
            ),
          ),
        );
      },
    );
  }
}
