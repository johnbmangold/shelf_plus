import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/network/abs_api_client.dart';
import 'package:shelf_plus/features/auth/domain/server_session.dart';
import 'package:shelf_plus/features/library/domain/library_models.dart';
import 'package:shelf_plus/features/library/domain/library_repository.dart';

/// ViewModel managing the Home tab shelves (`Continue listening`,
/// `In progress`, and `Recently added`) and background/manual sync.
class HomeViewModel extends ChangeNotifier {
  /// Creates a [HomeViewModel].
  new({
    required this._libraryRepository,
    required this._session,
    required this._loadImageHeaders,
    required this._logger,
  });

  final LibraryRepository _libraryRepository;
  final ServerSession _session;
  final Future<Map<String, String>> Function() _loadImageHeaders;
  final AppLogger _logger;

  StreamSubscription<List<BookSummary>>? _booksSub;
  List<BookSummary> _allBooks = const <BookSummary>[];
  Map<String, String> _imageHeaders = const <String, String>{};
  bool _isSyncing = false;
  bool _hasSyncError = false;
  bool _hasLoadedInitial = false;

  /// Whether a server sync is currently running.
  bool get isSyncing => _isSyncing;

  /// Whether the most recent sync failed (non-blocking if cached data exists).
  bool get hasSyncError => _hasSyncError;

  /// Whether at least one cache snapshot has been received.
  bool get hasLoadedInitial => _hasLoadedInitial;

  /// Headers required to load authenticated cover images.
  Map<String, String> get imageHeaders => _imageHeaders;

  /// Top in-progress book for the Continue Listening hero card.
  BookSummary? get heroContinueBook =>
      inProgressBooks.isEmpty ? null : inProgressBooks.first;

  /// Books currently in progress, ordered by most recently updated.
  List<BookSummary> get inProgressBooks {
    final active =
        _allBooks
            .where(
              (b) =>
                  b.progress != null &&
                  b.progress!.isInProgress &&
                  !b.progress!.hideFromContinueListening,
            )
            .toList(growable: true)
          ..sort(
            (a, b) => (b.progress?.updatedAtMs ?? 0).compareTo(
              a.progress?.updatedAtMs ?? 0,
            ),
          );
    return List<BookSummary>.unmodifiable(active);
  }

  /// Most recently added audiobooks.
  List<BookSummary> get recentlyAddedBooks {
    final sorted = _allBooks.toList(growable: true)
      ..sort((a, b) => b.addedAtMs.compareTo(a.addedAtMs));
    return List<BookSummary>.unmodifiable(sorted.take(20));
  }

  /// Whether there are any cached books to display.
  bool get isEmpty => _allBooks.isEmpty;

  /// Builds a subpath-safe cover URL for [book], or `null` if no cover
  /// exists.
  String? coverUrlFor(BookSummary book) {
    if (!book.hasCover) return null;
    return AbsApiClient.buildCoverUrl(
      baseUrl: _session.baseUrl,
      itemId: book.id,
    );
  }

  /// Starts watching local cached books and triggers an initial background
  /// sync.
  void start({bool autoSync = true}) {
    _booksSub ??= _libraryRepository.watchBooks(_session.serverId).listen((
      books,
    ) {
      _allBooks = books;
      _hasLoadedInitial = true;
      notifyListeners();
    });
    unawaited(_refreshImageHeaders());
    if (autoSync) {
      unawaited(refresh());
    }
  }

  Future<void> _refreshImageHeaders() async {
    _imageHeaders = await _loadImageHeaders();
    notifyListeners();
  }

  /// Synchronizes libraries, items, and progress from the server.
  Future<void> refresh() async {
    if (_isSyncing) return;
    _isSyncing = true;
    _hasSyncError = false;
    notifyListeners();

    try {
      await _refreshImageHeaders();
      await _libraryRepository.syncAll(_session);
    } on Exception catch (err) {
      _hasSyncError = true;
      _logger.warning(
        'Home sync failed; using cached data',
        scope: 'home',
        error: err,
      );
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    unawaited(_booksSub?.cancel());
    super.dispose();
  }
}
