import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:shelf_plus/core/database/app_database.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/network/abs_api_client.dart';
import 'package:shelf_plus/core/network/abs_library_models.dart';
import 'package:shelf_plus/core/socket/abs_socket_events.dart';
import 'package:shelf_plus/features/auth/domain/server_session.dart';
import 'package:shelf_plus/features/library/domain/library_models.dart';
import 'package:shelf_plus/features/library/domain/library_repository.dart';
import 'package:shelf_plus/features/sync/domain/progress_conflict_resolver.dart';

/// Drift-backed offline-first implementation of [LibraryRepository].
class LibraryRepositoryImpl implements LibraryRepository {
  /// Creates a [LibraryRepositoryImpl].
  const new({
    required this._apiClient,
    required this._database,
    required this._logger,
  });

  final AbsApiClient _apiClient;
  final AppDatabase _database;
  final AppLogger _logger;

  @override
  Stream<List<LibrarySummary>> watchLibraries(String serverId) {
    return _database
        .watchLibraries(serverId)
        .map(
          (rows) => rows
              .map(
                (row) => LibrarySummary(
                  id: row.id,
                  name: row.name,
                  mediaType: row.mediaType,
                  icon: row.icon,
                  displayOrder: row.displayOrder,
                ),
              )
              .toList(growable: false),
        );
  }

  @override
  Stream<List<BookSummary>> watchBooks(String serverId, {String? libraryId}) {
    return _database
        .watchItemsWithProgress(serverId, libraryId: libraryId)
        .map((rows) => rows.map(_mapBookSummary).toList(growable: false));
  }

  @override
  Stream<BookDetail?> watchBookDetail(String serverId, String itemId) {
    return Stream<BookDetail?>.multi((controller) {
      LibraryItemWithProgress? currentItem;
      var currentChapters = const <Chapter>[];
      var currentBookmarks = const <Bookmark>[];
      var hasItem = false;
      var hasChapters = false;
      var hasBookmarks = false;

      void emit() {
        if (controller.isClosed || !hasItem || !hasChapters || !hasBookmarks) {
          return;
        }
        final itemRow = currentItem;
        if (itemRow == null) {
          controller.add(null);
          return;
        }
        controller.add(
          BookDetail(
            book: _mapBookSummary(itemRow),
            chapters: currentChapters
                .map(
                  (c) => ChapterInfo(
                    index: c.chapterIndex,
                    title: c.title,
                    startSec: c.startSec,
                    endSec: c.endSec,
                  ),
                )
                .toList(growable: false),
            bookmarks: currentBookmarks
                .map(
                  (b) => BookmarkEntry(
                    timeSec: b.timeSec,
                    title: b.title,
                    note: b.note,
                    createdAtMs: b.createdAtMs,
                  ),
                )
                .toList(growable: false),
          ),
        );
      }

      final itemSub = _database.watchItemWithProgress(serverId, itemId).listen((
        row,
      ) {
        currentItem = row;
        hasItem = true;
        emit();
      }, onError: controller.addError);

      final chapterSub = _database.watchChapters(serverId, itemId).listen((
        rows,
      ) {
        currentChapters = rows;
        hasChapters = true;
        emit();
      }, onError: controller.addError);

      final bookmarkSub = _database.watchBookmarks(serverId, itemId).listen((
        rows,
      ) {
        currentBookmarks = rows;
        hasBookmarks = true;
        emit();
      }, onError: controller.addError);

      controller.onCancel = () async {
        await itemSub.cancel();
        await chapterSub.cancel();
        await bookmarkSub.cancel();
      };
    });
  }

  @override
  Stream<List<BookCollection>> watchCollections(
    String serverId,
    String libraryId,
  ) {
    return Stream<List<BookCollection>>.multi((controller) {
      var latestCollections = const <Collection>[];
      var latestBooks = const <BookSummary>[];
      var hasCollections = false;
      var hasBooks = false;

      void emit() {
        if (controller.isClosed || !hasCollections || !hasBooks) return;
        final byId = <String, BookSummary>{
          for (final book in latestBooks) book.id: book,
        };
        final mapped = latestCollections
            .map((c) {
              final ids = _decodeStringList(c.bookIdsJson);
              final books = <BookSummary>[for (final id in ids) ?byId[id]];
              return BookCollection(
                id: c.id,
                libraryId: c.libraryId,
                name: c.name,
                description: c.description,
                books: List<BookSummary>.unmodifiable(books),
              );
            })
            .toList(growable: false);
        controller.add(List<BookCollection>.unmodifiable(mapped));
      }

      final colSub = _database.watchCollections(serverId, libraryId).listen((
        rows,
      ) {
        latestCollections = rows;
        hasCollections = true;
        emit();
      }, onError: controller.addError);

      final bookSub = watchBooks(serverId, libraryId: libraryId).listen((rows) {
        latestBooks = rows;
        hasBooks = true;
        emit();
      }, onError: controller.addError);

      controller.onCancel = () async {
        await colSub.cancel();
        await bookSub.cancel();
      };
    });
  }

  @override
  Future<List<BookSummary>> searchBooks({
    required String serverId,
    required String query,
    String? libraryId,
  }) async {
    final rows = await _database.searchLibraryItemsFts(
      serverId: serverId,
      query: query,
      libraryId: libraryId,
    );
    return rows.map(_mapBookSummary).toList(growable: false);
  }

  @override
  Future<void> syncAll(ServerSession session) async {
    final serverId = session.serverId;
    final baseUrl = session.baseUrl;
    _logger.info(
      'Starting library sync for ${session.displayName}',
      scope: 'sync',
    );

    final libraries = await _apiClient.fetchLibraries(baseUrl: baseUrl);
    final bookLibraries = libraries
        .where((lib) => lib.mediaType == 'book')
        .toList(growable: false);

    final nowMs = DateTime.now().toUtc().millisecondsSinceEpoch;
    await _database.replaceLibraries(
      serverId,
      bookLibraries
          .map(
            (lib) => LibrariesCompanion.insert(
              serverId: serverId,
              id: lib.id,
              name: lib.name,
              mediaType: lib.mediaType,
              icon: Value(lib.icon),
              displayOrder: Value(lib.displayOrder),
              lastSyncedAtMs: nowMs,
            ),
          )
          .toList(growable: false),
    );

    for (final library in bookLibraries) {
      await _syncLibraryPages(
        serverId: serverId,
        baseUrl: baseUrl,
        libraryId: library.id,
      );
      await _syncLibraryCollections(
        serverId: serverId,
        baseUrl: baseUrl,
        libraryId: library.id,
      );
    }

    final me = await _apiClient.fetchMe(baseUrl: baseUrl);
    final mergedProgress = <MediaProgressEntriesCompanion>[];
    for (final p in me.mediaProgress) {
      final local = await _database.getMediaProgress(serverId, p.libraryItemId);
      mergedProgress.add(
        ProgressConflictResolver.mergeToCompanion(
          serverId: serverId,
          remote: p,
          local: local,
        ),
      );
    }
    await _database.upsertMediaProgressEntries(mergedProgress);
    await _database.replaceBookmarksForServer(
      serverId,
      me.bookmarks
          .map(
            (b) => BookmarksCompanion.insert(
              serverId: serverId,
              libraryItemId: b.libraryItemId,
              timeSec: b.timeSec,
              title: b.title,
              createdAtMs: Value(b.createdAtMs),
            ),
          )
          .toList(growable: false),
    );

    _logger.info(
      'Completed library sync (${bookLibraries.length} book libraries)',
      scope: 'sync',
    );
  }

  Future<void> _syncLibraryPages({
    required String serverId,
    required String baseUrl,
    required String libraryId,
  }) async {
    var page = 0;
    var fetchedCount = 0;
    var total = 1;

    while (fetchedCount < total) {
      final result = await _apiClient.fetchLibraryItems(
        baseUrl: baseUrl,
        libraryId: libraryId,
        page: page,
      );
      total = result.total;
      if (result.items.isEmpty) break;

      final companions = result.items
          .map((dto) => _itemCompanionFromDto(serverId, dto))
          .toList(growable: false);
      await _database.upsertLibraryItems(serverId, companions);

      for (final dto in result.items) {
        if (dto.chapters.isNotEmpty) {
          await _replaceChaptersFromDto(serverId, dto);
        }
      }

      fetchedCount += result.items.length;
      page++;
    }
  }

  Future<void> _syncLibraryCollections({
    required String serverId,
    required String baseUrl,
    required String libraryId,
  }) async {
    final collections = await _apiClient.fetchCollections(
      baseUrl: baseUrl,
      libraryId: libraryId,
    );
    await _database.replaceCollections(
      serverId,
      libraryId,
      collections
          .map(
            (c) => CollectionsCompanion.insert(
              serverId: serverId,
              id: c.id,
              libraryId: c.libraryId.isNotEmpty ? c.libraryId : libraryId,
              name: c.name,
              description: Value(c.description),
              bookIdsJson: Value(jsonEncode(c.bookIds)),
              updatedAtMs: Value(c.updatedAtMs),
            ),
          )
          .toList(growable: false),
    );
  }

  @override
  Future<void> syncBookDetail(ServerSession session, String itemId) async {
    final dto = await _apiClient.fetchItemExpanded(
      baseUrl: session.baseUrl,
      itemId: itemId,
    );
    await _database.upsertLibraryItems(
      session.serverId,
      <LibraryItemsCompanion>[_itemCompanionFromDto(session.serverId, dto)],
    );
    await _replaceChaptersFromDto(session.serverId, dto);
  }

  @override
  Future<void> handleSocketEvent(String serverId, AbsSocketEvent event) async {
    switch (event) {
      case LibraryItemUpdatedEvent(:final item):
      case LibraryItemAddedEvent(:final item):
        if (item.mediaType != 'book') return;
        await _database.upsertLibraryItems(serverId, <LibraryItemsCompanion>[
          _itemCompanionFromDto(serverId, item),
        ]);
        if (item.chapters.isNotEmpty) {
          await _replaceChaptersFromDto(serverId, item);
        }
      case LibraryItemRemovedEvent(:final itemId):
        await _database.deleteLibraryItem(serverId, itemId);
      case UserProgressUpdatedEvent(:final progress):
        final local = await _database.getMediaProgress(
          serverId,
          progress.libraryItemId,
        );
        await _database.upsertMediaProgressEntries(
          <MediaProgressEntriesCompanion>[
            ProgressConflictResolver.mergeToCompanion(
              serverId: serverId,
              remote: progress,
              local: local,
            ),
          ],
        );
    }
  }

  Future<void> _replaceChaptersFromDto(String serverId, AbsBookItemDto dto) {
    return _database.replaceChapters(serverId, dto.id, <ChaptersCompanion>[
      for (var i = 0; i < dto.chapters.length; i++)
        ChaptersCompanion.insert(
          serverId: serverId,
          libraryItemId: dto.id,
          chapterIndex: i,
          title: dto.chapters[i].title.isNotEmpty
              ? dto.chapters[i].title
              : 'Chapter ${i + 1}',
          startSec: dto.chapters[i].start,
          endSec: dto.chapters[i].end,
        ),
    ]);
  }

  LibraryItemsCompanion _itemCompanionFromDto(
    String serverId,
    AbsBookItemDto dto,
  ) {
    final authorNames = dto.authors.map((a) => a.name).toList(growable: false);
    final primarySeries = dto.series.isNotEmpty ? dto.series.first : null;

    return LibraryItemsCompanion.insert(
      serverId: serverId,
      id: dto.id,
      libraryId: dto.libraryId,
      mediaType: Value(dto.mediaType),
      title: dto.title,
      subtitle: Value(dto.subtitle),
      authors: Value(authorNames.join(', ')),
      authorsJson: Value(jsonEncode(authorNames)),
      narrators: Value(dto.narrators.join(', ')),
      narratorsJson: Value(jsonEncode(dto.narrators)),
      seriesName: Value(primarySeries?.name),
      seriesSequence: Value(primarySeries?.sequence),
      seriesJson: Value(
        jsonEncode(dto.series.map((s) => s.toJson()).toList(growable: false)),
      ),
      genresJson: Value(jsonEncode(dto.genres)),
      tagsJson: Value(jsonEncode(dto.tags)),
      description: Value(dto.description),
      publisher: Value(dto.publisher),
      publishedYear: Value(dto.publishedYear),
      durationSec: Value(dto.durationSec),
      numChapters: Value(dto.numChapters),
      hasCover: Value(dto.hasCover),
      addedAtMs: Value(dto.addedAtMs),
      updatedAtMs: Value(dto.updatedAtMs),
    );
  }

  BookSummary _mapBookSummary(LibraryItemWithProgress row) {
    final item = row.item;
    final progressRow = row.progress;

    return BookSummary(
      id: item.id,
      serverId: item.serverId,
      libraryId: item.libraryId,
      title: item.title,
      subtitle: item.subtitle,
      authorsDisplay: item.authors,
      authorNames: _decodeStringList(item.authorsJson),
      narratorsDisplay: item.narrators,
      narratorNames: _decodeStringList(item.narratorsJson),
      seriesName: item.seriesName,
      seriesSequence: item.seriesSequence,
      seriesRefs: _decodeSeriesRefs(item.seriesJson),
      genres: _decodeStringList(item.genresJson),
      description: item.description,
      publisher: item.publisher,
      publishedYear: item.publishedYear,
      durationSec: item.durationSec,
      numChapters: item.numChapters,
      hasCover: item.hasCover,
      addedAtMs: item.addedAtMs,
      progress: progressRow == null
          ? null
          : BookProgress(
              positionSec: progressRow.localPositionSec,
              durationSec: progressRow.durationSec > 0
                  ? progressRow.durationSec
                  : item.durationSec,
              progress: progressRow.progress,
              isFinished: progressRow.isFinished,
              hideFromContinueListening: progressRow.hideFromContinueListening,
              updatedAtMs: progressRow.localUpdatedAtMs > 0
                  ? progressRow.localUpdatedAtMs
                  : progressRow.serverUpdatedAtMs,
            ),
    );
  }

  List<String> _decodeStringList(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.whereType<String>().toList(growable: false);
      }
    } on FormatException {
      // Ignore malformed cached JSON.
    }
    return const <String>[];
  }

  List<SeriesRef> _decodeSeriesRefs(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .whereType<Map<String, dynamic>>()
            .map(
              (m) => SeriesRef(
                id: m['id'] as String? ?? '',
                name: m['name'] as String? ?? '',
                sequence: m['sequence']?.toString(),
              ),
            )
            .where((s) => s.name.isNotEmpty)
            .toList(growable: false);
      }
    } on FormatException {
      // Ignore malformed cached JSON.
    }
    return const <SeriesRef>[];
  }
}
