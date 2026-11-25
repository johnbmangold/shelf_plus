import 'dart:async';

import 'package:shelf_plus/core/socket/abs_socket_events.dart';
import 'package:shelf_plus/features/auth/domain/server_session.dart';
import 'package:shelf_plus/features/library/domain/library_models.dart';
import 'package:shelf_plus/features/library/domain/library_repository.dart';

/// In-memory [LibraryRepository] fake for fast ViewModel and widget tests.
class FakeLibraryRepository implements LibraryRepository {
  /// Creates a [FakeLibraryRepository] pre-populated with optional data.
  new({
    this._libraries = const <LibrarySummary>[],
    this._books = const <BookSummary>[],
    this._collections = const <BookCollection>[],
    Map<String, List<ChapterInfo>> chaptersByBookId =
        const <String, List<ChapterInfo>>{},
    Map<String, List<BookmarkEntry>> bookmarksByBookId =
        const <String, List<BookmarkEntry>>{},
  }) : _chaptersByBookId = Map<String, List<ChapterInfo>>.from(
         chaptersByBookId,
       ),
       _bookmarksByBookId = Map<String, List<BookmarkEntry>>.from(
         bookmarksByBookId,
       );

  final StreamController<List<LibrarySummary>> _librariesController =
      StreamController<List<LibrarySummary>>.broadcast();
  final StreamController<List<BookSummary>> _booksController =
      StreamController<List<BookSummary>>.broadcast();
  final StreamController<List<BookCollection>> _collectionsController =
      StreamController<List<BookCollection>>.broadcast();

  List<LibrarySummary> _libraries;
  List<BookSummary> _books;
  List<BookCollection> _collections;
  final Map<String, List<ChapterInfo>> _chaptersByBookId;
  final Map<String, List<BookmarkEntry>> _bookmarksByBookId;

  /// Optional error thrown on [syncAll].
  Exception? syncError;

  /// Count of [syncAll] invocations.
  int syncAllCalls = 0;

  /// Count of [syncBookDetail] invocations.
  int syncBookDetailCalls = 0;

  /// Updates stored books and emits on watchers.
  void setBooks(List<BookSummary> books) {
    _books = books;
    if (!_booksController.isClosed) _booksController.add(books);
  }

  /// Updates stored libraries and emits on watchers.
  void setLibraries(List<LibrarySummary> libraries) {
    _libraries = libraries;
    if (!_librariesController.isClosed) _librariesController.add(libraries);
  }

  /// Updates stored collections and emits on watchers.
  void setCollections(List<BookCollection> collections) {
    _collections = collections;
    if (!_collectionsController.isClosed) {
      _collectionsController.add(collections);
    }
  }

  @override
  Stream<List<LibrarySummary>> watchLibraries(String serverId) {
    return Stream<List<LibrarySummary>>.multi((controller) {
      controller.add(_libraries);
      final sub = _librariesController.stream.listen(controller.add);
      controller.onCancel = sub.cancel;
    });
  }

  @override
  Stream<List<BookSummary>> watchBooks(String serverId, {String? libraryId}) {
    return Stream<List<BookSummary>>.multi((controller) {
      List<BookSummary> filter(List<BookSummary> all) => libraryId == null
          ? all
          : all.where((b) => b.libraryId == libraryId).toList();

      controller.add(filter(_books));
      final sub = _booksController.stream.listen(
        (all) => controller.add(filter(all)),
      );
      controller.onCancel = sub.cancel;
    });
  }

  @override
  Stream<BookDetail?> watchBookDetail(String serverId, String itemId) async* {
    BookDetail? buildDetail(List<BookSummary> list) {
      for (final book in list) {
        if (book.id == itemId) {
          return BookDetail(
            book: book,
            chapters: _chaptersByBookId[itemId] ?? const <ChapterInfo>[],
            bookmarks: _bookmarksByBookId[itemId] ?? const <BookmarkEntry>[],
          );
        }
      }
      return null;
    }

    yield buildDetail(_books);
    await for (final list in _booksController.stream) {
      yield buildDetail(list);
    }
  }

  @override
  Stream<List<BookCollection>> watchCollections(
    String serverId,
    String libraryId,
  ) {
    return Stream<List<BookCollection>>.multi((controller) {
      controller.add(
        _collections.where((c) => c.libraryId == libraryId).toList(),
      );
      final sub = _collectionsController.stream.listen(
        (cols) => controller.add(
          cols.where((c) => c.libraryId == libraryId).toList(),
        ),
      );
      controller.onCancel = sub.cancel;
    });
  }

  @override
  Future<List<BookSummary>> searchBooks({
    required String serverId,
    required String query,
    String? libraryId,
  }) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const <BookSummary>[];
    return _books
        .where((b) {
          if (libraryId != null && b.libraryId != libraryId) return false;
          return b.title.toLowerCase().contains(q) ||
              b.authorsDisplay.toLowerCase().contains(q) ||
              b.narratorsDisplay.toLowerCase().contains(q) ||
              (b.seriesName?.toLowerCase().contains(q) ?? false);
        })
        .toList(growable: false);
  }

  @override
  Future<void> syncAll(ServerSession session) async {
    syncAllCalls++;
    if (syncError != null) throw syncError!;
  }

  @override
  Future<void> syncBookDetail(ServerSession session, String itemId) async {
    syncBookDetailCalls++;
  }

  @override
  Future<void> handleSocketEvent(String serverId, AbsSocketEvent event) async {}

  /// Releases stream controllers.
  Future<void> dispose() async {
    await _librariesController.close();
    await _booksController.close();
    await _collectionsController.close();
  }
}
