import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/network/abs_api_client.dart';
import 'package:shelf_plus/features/auth/domain/server_session.dart';
import 'package:shelf_plus/features/library/domain/library_models.dart';
import 'package:shelf_plus/features/library/domain/library_repository.dart';

/// Browse sections supported by the Library tab.
enum LibraryBrowseMode {
  /// Flat sortable/filterable books list.
  books,

  /// Grouped by series name and sequence.
  series,

  /// Grouped by author.
  authors,

  /// Server-defined collections.
  collections,
}

/// ViewModel managing Library tab browsing, FTS5 instant search, sorting,
/// filtering, and group drill-down state.
class LibraryViewModel extends ChangeNotifier {
  /// Creates a [LibraryViewModel].
  new({
    required this._libraryRepository,
    required this._session,
    required this._loadImageHeaders,
  });

  final LibraryRepository _libraryRepository;
  final ServerSession _session;
  final Future<Map<String, String>> Function() _loadImageHeaders;

  StreamSubscription<List<LibrarySummary>>? _librariesSub;
  StreamSubscription<List<BookSummary>>? _booksSub;
  StreamSubscription<List<BookCollection>>? _collectionsSub;

  List<LibrarySummary> _libraries = const <LibrarySummary>[];
  String? _selectedLibraryId;
  List<BookSummary> _books = const <BookSummary>[];
  List<BookCollection> _collections = const <BookCollection>[];
  List<BookSummary> _searchResults = const <BookSummary>[];
  Map<String, String> _imageHeaders = const <String, String>{};

  LibraryBrowseMode _browseMode = LibraryBrowseMode.books;
  BookSortOrder _sortOrder = BookSortOrder.titleAsc;
  BookFilterMode _filterMode = BookFilterMode.all;
  String _searchQuery = '';
  String? _selectedGroupTitle;
  List<BookSummary>? _selectedGroupBooks;
  int _searchGeneration = 0;

  /// Cached libraries for the active server.
  List<LibrarySummary> get libraries => _libraries;

  /// Currently selected library ID, or `null` if none loaded yet.
  String? get selectedLibraryId => _selectedLibraryId;

  /// Active browse mode.
  LibraryBrowseMode get browseMode => _browseMode;

  /// Active sort order.
  BookSortOrder get sortOrder => _sortOrder;

  /// Active filter mode.
  BookFilterMode get filterMode => _filterMode;

  /// Current search query string.
  String get searchQuery => _searchQuery;

  /// Whether a non-empty search query is active.
  bool get isSearching => _searchQuery.trim().isNotEmpty;

  /// Active drill-down group title (for Series/Authors/Collections).
  String? get selectedGroupTitle => _selectedGroupTitle;

  /// Active drill-down group books, if inside a group view.
  List<BookSummary>? get selectedGroupBooks => _selectedGroupBooks;

  /// Authenticated headers for cover art requests.
  Map<String, String> get imageHeaders => _imageHeaders;

  /// Books displayed in the Books view (either FTS5 search results or
  /// filtered & sorted catalog).
  List<BookSummary> get visibleBooks {
    final source = isSearching ? _searchResults : _books;
    return LibraryCatalogHelpers.applyFilterAndSort(
      source,
      filter: _filterMode,
      sort: _sortOrder,
    );
  }

  /// Series groups derived from the active library's books.
  List<SeriesGroup> get seriesGroups =>
      LibraryCatalogHelpers.groupBySeries(_books);

  /// Author groups derived from the active library's books.
  List<AuthorGroup> get authorGroups =>
      LibraryCatalogHelpers.groupByAuthor(_books);

  /// Collections for the active library.
  List<BookCollection> get collections => _collections;

  /// Builds a subpath-safe cover URL for [book], or `null` if absent.
  String? coverUrlFor(BookSummary book) {
    if (!book.hasCover) return null;
    return AbsApiClient.buildCoverUrl(
      baseUrl: _session.baseUrl,
      itemId: book.id,
    );
  }

  /// Starts reactive subscriptions for libraries, books, and collections.
  void start() {
    unawaited(_loadHeaders());
    _librariesSub ??= _libraryRepository
        .watchLibraries(_session.serverId)
        .listen((libs) {
          _libraries = libs;
          if (_selectedLibraryId == null ||
              libs.every((l) => l.id != _selectedLibraryId)) {
            final defaultId = _session.defaultLibraryId;
            final hasDefault =
                defaultId != null && libs.any((l) => l.id == defaultId);
            final nextId = hasDefault
                ? defaultId
                : (libs.isNotEmpty ? libs.first.id : null);
            _bindLibrary(nextId);
          } else {
            notifyListeners();
          }
        });
  }

  Future<void> _loadHeaders() async {
    _imageHeaders = await _loadImageHeaders();
    notifyListeners();
  }

  void _bindLibrary(String? libraryId) {
    _selectedLibraryId = libraryId;
    _selectedGroupTitle = null;
    _selectedGroupBooks = null;
    unawaited(_booksSub?.cancel());
    unawaited(_collectionsSub?.cancel());

    _booksSub = _libraryRepository
        .watchBooks(_session.serverId, libraryId: libraryId)
        .listen((books) {
          _books = books;
          if (isSearching) {
            unawaited(_runSearch(_searchQuery));
          }
          notifyListeners();
        });

    if (libraryId != null) {
      _collectionsSub = _libraryRepository
          .watchCollections(_session.serverId, libraryId)
          .listen((cols) {
            _collections = cols;
            notifyListeners();
          });
    } else {
      _collections = const <BookCollection>[];
    }
    notifyListeners();
  }

  /// Switches the active library.
  void selectLibrary(String libraryId) {
    if (_selectedLibraryId == libraryId) return;
    _bindLibrary(libraryId);
  }

  /// Switches the active browse mode and clears any drill-down state.
  void setBrowseMode(LibraryBrowseMode mode) {
    if (_browseMode == mode && _selectedGroupTitle == null) return;
    _browseMode = mode;
    _selectedGroupTitle = null;
    _selectedGroupBooks = null;
    notifyListeners();
  }

  /// Updates the active [BookSortOrder].
  void setSortOrder(BookSortOrder order) {
    if (_sortOrder == order) return;
    _sortOrder = order;
    notifyListeners();
  }

  /// Updates the active [BookFilterMode].
  void setFilterMode(BookFilterMode mode) {
    if (_filterMode == mode) return;
    _filterMode = mode;
    notifyListeners();
  }

  /// Updates the FTS5 search query and executes an instant local search.
  Future<void> updateSearchQuery(String value) async {
    _searchQuery = value;
    _selectedGroupTitle = null;
    _selectedGroupBooks = null;
    if (value.trim().isEmpty) {
      _searchGeneration++;
      _searchResults = const <BookSummary>[];
      notifyListeners();
      return;
    }
    await _runSearch(value);
  }

  Future<void> _runSearch(String query) async {
    final generation = ++_searchGeneration;
    final results = await _libraryRepository.searchBooks(
      serverId: _session.serverId,
      query: query,
      libraryId: _selectedLibraryId,
    );
    if (generation != _searchGeneration) return;
    _searchResults = results;
    notifyListeners();
  }

  /// Enters a group drill-down view (series, author, or collection).
  void openGroup(String title, List<BookSummary> books) {
    _selectedGroupTitle = title;
    _selectedGroupBooks = books;
    notifyListeners();
  }

  /// Exits the current group drill-down view.
  void closeGroup() {
    _selectedGroupTitle = null;
    _selectedGroupBooks = null;
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_librariesSub?.cancel());
    unawaited(_booksSub?.cancel());
    unawaited(_collectionsSub?.cancel());
    super.dispose();
  }
}
