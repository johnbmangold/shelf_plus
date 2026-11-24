import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/theme/app_theme.dart';
import 'package:shelf_plus/core/theme/shelf_theme_tokens.dart';
import 'package:shelf_plus/core/widgets/book_cover_image.dart';
import 'package:shelf_plus/features/auth/presentation/auth_controller.dart';
import 'package:shelf_plus/features/home/presentation/home_view_model.dart';
import 'package:shelf_plus/features/library/domain/library_models.dart';
import 'package:shelf_plus/features/library/domain/library_repository.dart';
import 'package:shelf_plus/l10n/generated/app_localizations.dart';

/// Home tab displaying Continue Listening hero, In Progress, and Recently
/// Added shelves backed by the offline-first Drift cache.
class HomeScreen extends StatefulWidget {
  /// Creates a [HomeScreen].
  const new({
    required this.libraryRepository,
    required this.authController,
    required this.loadImageHeaders,
    required this.logger,
    required this.bookDetailRouteBuilder,
    this.enableNetworkImages = true,
    this.autoSync = true,
    super.key,
  });

  /// Library repository supplying cached shelves and server sync.
  final LibraryRepository libraryRepository;

  /// Auth controller providing the active server session.
  final AuthController authController;

  /// Callback loading authenticated image headers.
  final Future<Map<String, String>> Function() loadImageHeaders;

  /// Application logger.
  final AppLogger logger;

  /// Builds the route path for opening a book detail page.
  final String Function(String itemId) bookDetailRouteBuilder;

  /// Whether network cover fetching is enabled.
  final bool enableNetworkImages;

  /// Whether [HomeViewModel.start] should sync automatically on mount.
  final bool autoSync;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeViewModel? _viewModel;
  String? _boundServerId;

  @override
  void initState() {
    super.initState();
    widget.authController.addListener(_syncSessionBinding);
    _syncSessionBinding();
  }

  @override
  void dispose() {
    widget.authController.removeListener(_syncSessionBinding);
    _viewModel?.dispose();
    super.dispose();
  }

  void _syncSessionBinding() {
    final session = widget.authController.session;
    if (session?.serverId == _boundServerId) return;

    _viewModel?.dispose();
    _viewModel = null;
    _boundServerId = session?.serverId;

    if (session != null) {
      _viewModel = HomeViewModel(
        libraryRepository: widget.libraryRepository,
        session: session,
        loadImageHeaders: widget.loadImageHeaders,
        logger: widget.logger,
      )..start(autoSync: widget.autoSync);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final vm = _viewModel;

    if (vm == null) {
      return Scaffold(appBar: AppBar(title: Text(l10n.navHome)));
    }

    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.navHome),
            actions: <Widget>[
              IconButton(
                key: const Key('home_sync_button'),
                tooltip: l10n.homeSyncTooltip,
                onPressed: vm.isSyncing ? null : () => unawaited(vm.refresh()),
                icon: vm.isSyncing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.sync),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: vm.refresh,
            child: vm.isEmpty
                ? _HomeEmptyState(isSyncing: vm.isSyncing)
                : _HomeContent(
                    viewModel: vm,
                    enableNetworkImages: widget.enableNetworkImages,
                    onOpenBook: (id) => unawaited(
                      context.push(widget.bookDetailRouteBuilder(id)),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _HomeEmptyState extends StatelessWidget {
  const new({required this.isSyncing});

  final bool isSyncing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tokens = context.shelfTokens;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: <Widget>[
        const SizedBox(height: 64),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (isSyncing)
                  const CircularProgressIndicator()
                else
                  Icon(
                    Icons.auto_stories_outlined,
                    size: 40,
                    color: theme.colorScheme.primary,
                  ),
                const SizedBox(height: 16),
                Text(
                  l10n.homeEmptyTitle,
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.homeEmptySubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: tokens.subtleMetaText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeContent extends StatelessWidget {
  const new({
    required this.viewModel,
    required this.enableNetworkImages,
    required this.onOpenBook,
  });

  final HomeViewModel viewModel;
  final bool enableNetworkImages;
  final void Function(String itemId) onOpenBook;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tokens = context.shelfTokens;
    final hero = viewModel.heroContinueBook;
    final secondaryInProgress = viewModel.inProgressBooks.skip(1).toList();
    final recent = viewModel.recentlyAddedBooks;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: <Widget>[
        if (viewModel.hasSyncError) ...<Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.cloud_off_outlined,
                  size: 18,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.homeOfflineBanner,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        if (hero != null) ...<Widget>[
          Text(l10n.homeContinueListening, style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          _HeroContinueCard(
            book: hero,
            coverUrl: viewModel.coverUrlFor(hero),
            headers: viewModel.imageHeaders,
            enableNetworkImages: enableNetworkImages,
            onTap: () => onOpenBook(hero.id),
          ),
          const SizedBox(height: 24),
        ],
        if (secondaryInProgress.isNotEmpty) ...<Widget>[
          Text(l10n.homeInProgress, style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          _HorizontalBookShelf(
            books: secondaryInProgress,
            viewModel: viewModel,
            enableNetworkImages: enableNetworkImages,
            onOpenBook: onOpenBook,
          ),
          const SizedBox(height: 24),
        ],
        if (recent.isNotEmpty) ...<Widget>[
          Text(l10n.homeRecentlyAdded, style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          _HorizontalBookShelf(
            books: recent,
            viewModel: viewModel,
            enableNetworkImages: enableNetworkImages,
            onOpenBook: onOpenBook,
            subtleMetaColor: tokens.subtleMetaText,
          ),
        ],
      ],
    );
  }
}

class _HeroContinueCard extends StatelessWidget {
  const new({
    required this.book,
    required this.coverUrl,
    required this.headers,
    required this.enableNetworkImages,
    required this.onTap,
  });

  final BookSummary book;
  final String? coverUrl;
  final Map<String, String> headers;
  final bool enableNetworkImages;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tokens = context.shelfTokens;
    final remaining = DurationFormatter.formatShort(book.remainingSec);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: Key('home_hero_book_${book.id}'),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              BookCoverImage(
                title: book.title,
                size: 96,
                coverUrl: coverUrl,
                headers: headers,
                enableNetworkImage: enableNetworkImages,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      book.title,
                      style: theme.textTheme.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (book.authorsDisplay.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 4),
                      Text(
                        book.authorsDisplay,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: tokens.subtleMetaText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: book.completionRatio,
                        minHeight: 6,
                        backgroundColor: tokens.progressTrack,
                        color: tokens.progressFill,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.bookTimeLeft(remaining),
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
        ),
      ),
    );
  }
}

class _HorizontalBookShelf extends StatelessWidget {
  const new({
    required this.books,
    required this.viewModel,
    required this.enableNetworkImages,
    required this.onOpenBook,
    this.subtleMetaColor,
  });

  final List<BookSummary> books;
  final HomeViewModel viewModel;
  final bool enableNetworkImages;
  final void Function(String itemId) onOpenBook;
  final Color? subtleMetaColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.shelfTokens;

    return SizedBox(
      height: 204,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final book = books[index];
          return SizedBox(
            width: 128,
            child: InkWell(
              key: Key('home_shelf_book_${book.id}'),
              borderRadius: BorderRadius.circular(12),
              onTap: () => onOpenBook(book.id),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  BookCoverImage(
                    title: book.title,
                    size: 128,
                    coverUrl: viewModel.coverUrlFor(book),
                    headers: viewModel.imageHeaders,
                    enableNetworkImage: enableNetworkImages,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.title,
                    style: theme.textTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (book.authorsDisplay.isNotEmpty)
                    Text(
                      book.authorsDisplay,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: subtleMetaColor ?? tokens.subtleMetaText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
