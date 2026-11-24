import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/theme/app_theme.dart';
import 'package:shelf_plus/core/theme/shelf_theme_tokens.dart';
import 'package:shelf_plus/core/widgets/book_cover_image.dart';
import 'package:shelf_plus/features/auth/presentation/auth_controller.dart';
import 'package:shelf_plus/features/library/domain/library_models.dart';
import 'package:shelf_plus/features/library/domain/library_repository.dart';
import 'package:shelf_plus/features/library/presentation/library_view_model.dart';
import 'package:shelf_plus/l10n/generated/app_localizations.dart';

/// Library tab supporting Books / Series / Authors / Collections browsing,
/// instant FTS5 offline search, and Sort & Filter options.
class LibraryScreen extends StatefulWidget {
  /// Creates a [LibraryScreen].
  const new({
    required this.libraryRepository,
    required this.authController,
    required this.loadImageHeaders,
    required this.bookDetailRouteBuilder,
    this.enableNetworkImages = true,
    super.key,
  });

  /// Library repository supplying reactive catalogs and FTS5 search.
  final LibraryRepository libraryRepository;

  /// Active auth controller providing the current server session.
  final AuthController authController;

  /// Callback returning authenticated cover image headers.
  final Future<Map<String, String>> Function() loadImageHeaders;

  /// Builds the route path for opening a book detail page.
  final String Function(String itemId) bookDetailRouteBuilder;

  /// Whether network cover fetching is enabled.
  final bool enableNetworkImages;

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  LibraryViewModel? _viewModel;
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
    _searchController.dispose();
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
      _viewModel = LibraryViewModel(
        libraryRepository: widget.libraryRepository,
        session: session,
        loadImageHeaders: widget.loadImageHeaders,
      )..start();
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _showSortFilterSheet(LibraryViewModel vm) async {
    final l10n = AppLocalizations.of(context);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return ListenableBuilder(
          listenable: vm,
          builder: (context, _) {
            final theme = Theme.of(context);
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      l10n.librarySortAndFilter,
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.librarySortLabel,
                      style: theme.textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        _sortChip(
                          vm,
                          BookSortOrder.titleAsc,
                          l10n.librarySortTitleAsc,
                        ),
                        _sortChip(
                          vm,
                          BookSortOrder.authorAsc,
                          l10n.librarySortAuthorAsc,
                        ),
                        _sortChip(
                          vm,
                          BookSortOrder.addedDesc,
                          l10n.librarySortAddedDesc,
                        ),
                        _sortChip(
                          vm,
                          BookSortOrder.durationDesc,
                          l10n.librarySortDurationDesc,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.libraryFilterLabel,
                      style: theme.textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        _filterChip(
                          vm,
                          BookFilterMode.all,
                          l10n.libraryFilterAll,
                        ),
                        _filterChip(
                          vm,
                          BookFilterMode.inProgress,
                          l10n.libraryFilterInProgress,
                        ),
                        _filterChip(
                          vm,
                          BookFilterMode.finished,
                          l10n.libraryFilterFinished,
                        ),
                        _filterChip(
                          vm,
                          BookFilterMode.notStarted,
                          l10n.libraryFilterNotStarted,
                        ),
                      ],
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

  Widget _sortChip(LibraryViewModel vm, BookSortOrder order, String label) {
    return ChoiceChip(
      key: Key('sort_chip_${order.name}'),
      label: Text(label),
      selected: vm.sortOrder == order,
      onSelected: (_) => vm.setSortOrder(order),
    );
  }

  Widget _filterChip(LibraryViewModel vm, BookFilterMode mode, String label) {
    return ChoiceChip(
      key: Key('filter_chip_${mode.name}'),
      label: Text(label),
      selected: vm.filterMode == mode,
      onSelected: (_) => vm.setFilterMode(mode),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final vm = _viewModel;
    if (vm == null) {
      return Scaffold(appBar: AppBar(title: Text(l10n.navLibrary)));
    }

    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) {
        final selectedGroup = vm.selectedGroupTitle;
        return Scaffold(
          appBar: AppBar(
            leading: selectedGroup != null
                ? IconButton(
                    key: const Key('library_group_back_button'),
                    onPressed: vm.closeGroup,
                    icon: const Icon(Icons.arrow_back),
                  )
                : null,
            title: Text(selectedGroup ?? l10n.navLibrary),
            actions: <Widget>[
              if (vm.libraries.length > 1)
                PopupMenuButton<String>(
                  key: const Key('library_switcher_button'),
                  icon: const Icon(Icons.collections_bookmark_outlined),
                  onSelected: vm.selectLibrary,
                  itemBuilder: (context) => <PopupMenuEntry<String>>[
                    for (final lib in vm.libraries)
                      PopupMenuItem<String>(
                        value: lib.id,
                        child: Text(lib.name),
                      ),
                  ],
                ),
              IconButton(
                key: const Key('library_sort_filter_button'),
                tooltip: l10n.librarySortAndFilter,
                onPressed: () => unawaited(_showSortFilterSheet(vm)),
                icon: const Icon(Icons.tune),
              ),
            ],
          ),
          body: Column(
            children: <Widget>[
              if (selectedGroup == null) ...<Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: TextField(
                    key: const Key('library_search_field'),
                    controller: _searchController,
                    onChanged: (value) =>
                        unawaited(vm.updateSearchQuery(value)),
                    decoration: InputDecoration(
                      hintText: l10n.librarySearchHint,
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                      isDense: true,
                      suffixIcon: vm.isSearching
                          ? IconButton(
                              key: const Key('library_clear_search_button'),
                              tooltip: l10n.libraryClearSearchTooltip,
                              onPressed: () {
                                _searchController.clear();
                                unawaited(vm.updateSearchQuery(''));
                              },
                              icon: const Icon(Icons.clear),
                            )
                          : null,
                    ),
                  ),
                ),
                if (!vm.isSearching)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<LibraryBrowseMode>(
                        showSelectedIcon: false,
                        segments: <ButtonSegment<LibraryBrowseMode>>[
                          ButtonSegment<LibraryBrowseMode>(
                            value: LibraryBrowseMode.books,
                            label: Text(l10n.libraryTabBooks),
                          ),
                          ButtonSegment<LibraryBrowseMode>(
                            value: LibraryBrowseMode.series,
                            label: Text(l10n.libraryTabSeries),
                          ),
                          ButtonSegment<LibraryBrowseMode>(
                            value: LibraryBrowseMode.authors,
                            label: Text(l10n.libraryTabAuthors),
                          ),
                          ButtonSegment<LibraryBrowseMode>(
                            value: LibraryBrowseMode.collections,
                            label: Text(l10n.libraryTabCollections),
                          ),
                        ],
                        selected: <LibraryBrowseMode>{vm.browseMode},
                        onSelectionChanged: (selected) {
                          vm.setBrowseMode(selected.first);
                        },
                      ),
                    ),
                  ),
              ],
              Expanded(child: _buildBody(context, vm)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, LibraryViewModel vm) {
    final l10n = AppLocalizations.of(context);
    final groupBooks = vm.selectedGroupBooks;
    if (groupBooks != null) {
      return _BookList(
        books: groupBooks,
        viewModel: vm,
        enableNetworkImages: widget.enableNetworkImages,
        onOpenBook: (id) =>
            unawaited(context.push(widget.bookDetailRouteBuilder(id))),
      );
    }

    if (vm.isSearching || vm.browseMode == LibraryBrowseMode.books) {
      final books = vm.visibleBooks;
      if (books.isEmpty) {
        return _EmptyMessageCard(
          icon: Icons.library_books_outlined,
          title: vm.isSearching
              ? l10n.libraryNoMatches
              : l10n.libraryEmptyTitle,
          subtitle: vm.isSearching
              ? l10n.librarySearchHint
              : l10n.libraryEmptySubtitle,
        );
      }
      return _BookList(
        books: books,
        viewModel: vm,
        enableNetworkImages: widget.enableNetworkImages,
        onOpenBook: (id) =>
            unawaited(context.push(widget.bookDetailRouteBuilder(id))),
      );
    }

    switch (vm.browseMode) {
      case LibraryBrowseMode.books:
        return const SizedBox.shrink();
      case LibraryBrowseMode.series:
        final groups = vm.seriesGroups;
        if (groups.isEmpty) {
          return _EmptyMessageCard(
            icon: Icons.collections_bookmark_outlined,
            title: l10n.libraryNoGroups,
            subtitle: l10n.libraryEmptySubtitle,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          itemCount: groups.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final group = groups[index];
            return Card(
              child: ListTile(
                key: Key('series_group_${group.name}'),
                leading: const Icon(Icons.auto_awesome_motion_outlined),
                title: Text(group.name),
                subtitle: Text(l10n.libraryBookCount(group.books.length)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => vm.openGroup(group.name, group.books),
              ),
            );
          },
        );
      case LibraryBrowseMode.authors:
        final authors = vm.authorGroups;
        if (authors.isEmpty) {
          return _EmptyMessageCard(
            icon: Icons.person_outline,
            title: l10n.libraryNoGroups,
            subtitle: l10n.libraryEmptySubtitle,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          itemCount: authors.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final author = authors[index];
            return Card(
              child: ListTile(
                key: Key('author_group_${author.name}'),
                leading: const Icon(Icons.person_outline),
                title: Text(author.name),
                subtitle: Text(l10n.libraryBookCount(author.books.length)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => vm.openGroup(author.name, author.books),
              ),
            );
          },
        );
      case LibraryBrowseMode.collections:
        final cols = vm.collections;
        if (cols.isEmpty) {
          return _EmptyMessageCard(
            icon: Icons.folder_copy_outlined,
            title: l10n.libraryNoGroups,
            subtitle: l10n.libraryEmptySubtitle,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          itemCount: cols.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final col = cols[index];
            return Card(
              child: ListTile(
                key: Key('collection_group_${col.id}'),
                leading: const Icon(Icons.folder_copy_outlined),
                title: Text(col.name),
                subtitle: Text(l10n.libraryBookCount(col.books.length)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => vm.openGroup(col.name, col.books),
              ),
            );
          },
        );
    }
  }
}

class _BookList extends StatelessWidget {
  const new({
    required this.books,
    required this.viewModel,
    required this.enableNetworkImages,
    required this.onOpenBook,
  });

  final List<BookSummary> books;
  final LibraryViewModel viewModel;
  final bool enableNetworkImages;
  final void Function(String itemId) onOpenBook;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tokens = context.shelfTokens;

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: books.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final book = books[index];
        final isFinished = book.progress?.isFinished ?? false;
        final isInProgress = book.progress?.isInProgress ?? false;

        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            key: Key('library_book_${book.id}'),
            onTap: () => onOpenBook(book.id),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: <Widget>[
                  BookCoverImage(
                    title: book.title,
                    size: 72,
                    coverUrl: viewModel.coverUrlFor(book),
                    headers: viewModel.imageHeaders,
                    enableNetworkImage: enableNetworkImages,
                    borderRadius: 10,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          book.title,
                          style: theme.textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (book.authorsDisplay.isNotEmpty) ...<Widget>[
                          const SizedBox(height: 2),
                          Text(
                            book.authorsDisplay,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: tokens.subtleMetaText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 6),
                        Row(
                          children: <Widget>[
                            Text(
                              isFinished
                                  ? l10n.bookFinished
                                  : isInProgress
                                  ? l10n.bookTimeLeft(
                                      DurationFormatter.formatShort(
                                        book.remainingSec,
                                      ),
                                    )
                                  : DurationFormatter.formatShort(
                                      book.durationSec,
                                    ),
                              style: AppTheme.tabularFigureStyle(
                                theme.textTheme.labelSmall!.copyWith(
                                  color: tokens.subtleMetaText,
                                ),
                              ),
                            ),
                            if (book.seriesName != null &&
                                book.seriesName!.isNotEmpty) ...<Widget>[
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  book.seriesSequence != null
                                      ? '${book.seriesName} '
                                            '#${book.seriesSequence}'
                                      : book.seriesName!,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: tokens.subtleMetaText,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
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

class _EmptyMessageCard extends StatelessWidget {
  const new({required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.shelfTokens;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(icon, size: 40, color: theme.colorScheme.primary),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: tokens.subtleMetaText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
