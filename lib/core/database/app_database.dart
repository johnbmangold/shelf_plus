import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:shelf_plus/core/database/tables/bookmarks_table.dart';
import 'package:shelf_plus/core/database/tables/chapters_table.dart';
import 'package:shelf_plus/core/database/tables/collections_table.dart';
import 'package:shelf_plus/core/database/tables/libraries_table.dart';
import 'package:shelf_plus/core/database/tables/library_items_table.dart';
import 'package:shelf_plus/core/database/tables/media_progress_table.dart';
import 'package:shelf_plus/core/database/tables/playback_history_table.dart';
import 'package:shelf_plus/core/database/tables/server_profiles_table.dart';

part 'app_database.g.dart';

/// Joined row pairing a cached [LibraryItem] with its optional
/// [MediaProgressEntry].
class LibraryItemWithProgress {
  /// Creates a [LibraryItemWithProgress].
  const new({required this.item, this.progress});

  /// Cached library item row.
  final LibraryItem item;

  /// Optional progress entry for the item.
  final MediaProgressEntry? progress;
}

/// Local SQLite database powered by Drift with FTS5 full-text search.
@DriftDatabase(
  tables: <Type>[
    ServerProfiles,
    Libraries,
    LibraryItems,
    Chapters,
    MediaProgressEntries,
    Bookmarks,
    Collections,
    PlaybackHistoryEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Opens the persistent on-device database, or wraps a custom [executor].
  new([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'shelf_plus'));

  /// Creates an isolated in-memory database for unit and widget tests.
  factory inMemory() => AppDatabase(NativeDatabase.memory());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _createFtsTable();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(libraries);
        await m.createTable(libraryItems);
        await m.createTable(chapters);
        await m.createTable(mediaProgressEntries);
        await m.createTable(bookmarks);
        await m.createTable(collections);
        await _createFtsTable();
      }
      if (from < 3) {
        await m.createTable(playbackHistoryEntries);
      }
    },
  );

  Future<void> _createFtsTable() async {
    await customStatement('''
      CREATE VIRTUAL TABLE IF NOT EXISTS library_items_fts USING fts5(
        server_id UNINDEXED,
        item_id UNINDEXED,
        library_id UNINDEXED,
        title,
        subtitle,
        authors,
        narrators,
        series_name,
        tags
      )
    ''');
  }

  // ---------------------------------------------------------------------------
  // ServerProfiles
  // ---------------------------------------------------------------------------

  /// Returns the currently active [ServerProfile], or `null` if signed out.
  Future<ServerProfile?> getActiveServer() {
    return (select(serverProfiles)
          ..where((tbl) => tbl.isActive.equals(true))
          ..limit(1))
        .getSingleOrNull();
  }

  /// Watches the currently active [ServerProfile].
  Stream<ServerProfile?> watchActiveServer() {
    return (select(serverProfiles)
          ..where((tbl) => tbl.isActive.equals(true))
          ..limit(1))
        .watchSingleOrNull();
  }

  /// Finds a stored server profile by its normalized [baseUrl].
  Future<ServerProfile?> findServerByUrl(String baseUrl) {
    return (select(serverProfiles)
          ..where((tbl) => tbl.baseUrl.equals(baseUrl))
          ..limit(1))
        .getSingleOrNull();
  }

  /// Persists [companion] and marks it as the sole active server profile.
  Future<void> saveActiveServer(ServerProfilesCompanion companion) {
    return transaction(() async {
      await update(serverProfiles)
          .write(const ServerProfilesCompanion(isActive: Value(false)));
      await into(
        serverProfiles,
      ).insertOnConflictUpdate(companion.copyWith(isActive: const Value(true)));
    });
  }

  /// Marks all server profiles inactive without deleting cached metadata.
  Future<void> clearActiveServer() {
    return update(serverProfiles)
        .write(const ServerProfilesCompanion(isActive: Value(false)));
  }

  /// Deletes the server profile identified by [id].
  Future<void> deleteServer(String id) {
    return (delete(serverProfiles)..where((tbl) => tbl.id.equals(id))).go();
  }

  // ---------------------------------------------------------------------------
  // Libraries
  // ---------------------------------------------------------------------------

  /// Watches all cached libraries for [serverId], ordered by `displayOrder`.
  Stream<List<Library>> watchLibraries(String serverId) {
    return (select(libraries)
          ..where((tbl) => tbl.serverId.equals(serverId))
          ..orderBy(<OrderingTerm Function(Libraries)>[
            (tbl) => OrderingTerm.asc(tbl.displayOrder),
            (tbl) => OrderingTerm.asc(tbl.name),
          ]))
        .watch();
  }

  /// Replaces the cached libraries list for [serverId].
  Future<void> replaceLibraries(
    String serverId,
    List<LibrariesCompanion> entries,
  ) {
    return transaction(() async {
      await (delete(
        libraries,
      )..where((tbl) => tbl.serverId.equals(serverId))).go();
      if (entries.isNotEmpty) {
        await batch((b) => b.insertAll(libraries, entries));
      }
    });
  }

  // ---------------------------------------------------------------------------
  // LibraryItems & FTS5
  // ---------------------------------------------------------------------------

  /// Upserts [entries] into `library_items` and synchronizes
  /// `library_items_fts` in a single transaction.
  Future<void> upsertLibraryItems(
    String serverId,
    List<LibraryItemsCompanion> entries,
  ) {
    if (entries.isEmpty) return Future<void>.value();
    return transaction(() async {
      for (final entry in entries) {
        await into(libraryItems).insertOnConflictUpdate(entry);
        final itemId = entry.id.value;
        final libraryId = entry.libraryId.value;
        final title = entry.title.value;
        final subtitle = entry.subtitle.present
            ? (entry.subtitle.value ?? '')
            : '';
        final authors = entry.authors.present ? entry.authors.value : '';
        final narrators = entry.narrators.present ? entry.narrators.value : '';
        final seriesName = entry.seriesName.present
            ? (entry.seriesName.value ?? '')
            : '';
        final tags = entry.tagsJson.present
            ? _decodeTagsForFts(entry.tagsJson.value)
            : '';

        await customStatement(
          'DELETE FROM library_items_fts WHERE server_id = ? AND item_id = ?',
          <Object>[serverId, itemId],
        );
        await customStatement(
          '''
          INSERT INTO library_items_fts (
            server_id, item_id, library_id, title, subtitle, authors,
            narrators, series_name, tags
          ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
          ''',
          <Object>[
            serverId,
            itemId,
            libraryId,
            title,
            subtitle,
            authors,
            narrators,
            seriesName,
            tags,
          ],
        );
      }
    });
  }

  /// Removes an item and all associated FTS, chapter, progress, and bookmark
  /// rows for [serverId] and [itemId].
  Future<void> deleteLibraryItem(String serverId, String itemId) {
    return transaction(() async {
      await customStatement(
        'DELETE FROM library_items_fts WHERE server_id = ? AND item_id = ?',
        <Object>[serverId, itemId],
      );
      await (delete(chapters)..where(
            (tbl) =>
                tbl.serverId.equals(serverId) &
                tbl.libraryItemId.equals(itemId),
          ))
          .go();
      await (delete(mediaProgressEntries)..where(
            (tbl) =>
                tbl.serverId.equals(serverId) &
                tbl.libraryItemId.equals(itemId),
          ))
          .go();
      await (delete(bookmarks)..where(
            (tbl) =>
                tbl.serverId.equals(serverId) &
                tbl.libraryItemId.equals(itemId),
          ))
          .go();
      await (delete(playbackHistoryEntries)..where(
            (tbl) =>
                tbl.serverId.equals(serverId) &
                tbl.libraryItemId.equals(itemId),
          ))
          .go();
      await (delete(libraryItems)..where(
            (tbl) => tbl.serverId.equals(serverId) & tbl.id.equals(itemId),
          ))
          .go();
    });
  }

  /// Watches cached library items with joined progress for [serverId],
  /// optionally filtered by [libraryId].
  Stream<List<LibraryItemWithProgress>> watchItemsWithProgress(
    String serverId, {
    String? libraryId,
  }) {
    final query = select(libraryItems).join(<Join<HasResultSet, dynamic>>[
      leftOuterJoin(
        mediaProgressEntries,
        mediaProgressEntries.serverId.equalsExp(libraryItems.serverId) &
            mediaProgressEntries.libraryItemId.equalsExp(libraryItems.id),
      ),
    ]);

    var filter = libraryItems.serverId.equals(serverId);
    if (libraryId != null) {
      filter = filter & libraryItems.libraryId.equals(libraryId);
    }
    query
      ..where(filter)
      ..orderBy(<OrderingTerm>[OrderingTerm.asc(libraryItems.title)]);

    return query.watch().map(
      (rows) => rows
          .map(
            (row) => LibraryItemWithProgress(
              item: row.readTable(libraryItems),
              progress: row.readTableOrNull(mediaProgressEntries),
            ),
          )
          .toList(growable: false),
    );
  }

  /// Watches a single [LibraryItemWithProgress] for [serverId] and [itemId].
  Stream<LibraryItemWithProgress?> watchItemWithProgress(
    String serverId,
    String itemId,
  ) {
    final query =
        select(libraryItems).join(<Join<HasResultSet, dynamic>>[
          leftOuterJoin(
            mediaProgressEntries,
            mediaProgressEntries.serverId.equalsExp(libraryItems.serverId) &
                mediaProgressEntries.libraryItemId.equalsExp(libraryItems.id),
          ),
        ])..where(
          libraryItems.serverId.equals(serverId) &
              libraryItems.id.equals(itemId),
        );

    return query.watchSingleOrNull().map(
      (row) => row == null
          ? null
          : LibraryItemWithProgress(
              item: row.readTable(libraryItems),
              progress: row.readTableOrNull(mediaProgressEntries),
            ),
    );
  }

  /// Performs an instant FTS5 prefix search across title, subtitle, authors,
  /// narrators, series name, and tags, ranked by BM25 relevance.
  Future<List<LibraryItemWithProgress>> searchLibraryItemsFts({
    required String serverId,
    required String query,
    String? libraryId,
  }) async {
    final ftsQuery = buildFtsMatchQuery(query);
    if (ftsQuery.isEmpty) {
      return const <LibraryItemWithProgress>[];
    }

    final sql = StringBuffer(
      'SELECT item_id FROM library_items_fts '
      'WHERE library_items_fts MATCH ? AND server_id = ?',
    );
    final args = <Variable<Object>>[
      Variable.withString(ftsQuery),
      Variable.withString(serverId),
    ];
    if (libraryId != null) {
      sql.write(' AND library_id = ?');
      args.add(Variable.withString(libraryId));
    }
    sql.write(' ORDER BY bm25(library_items_fts) LIMIT 100');

    final rows = await customSelect(sql.toString(), variables: args).get();
    if (rows.isEmpty) {
      return const <LibraryItemWithProgress>[];
    }

    final orderedIds = rows
        .map((row) => row.read<String>('item_id'))
        .toList(growable: false);

    final joined =
        await (select(libraryItems).join(<Join<HasResultSet, dynamic>>[
              leftOuterJoin(
                mediaProgressEntries,
                mediaProgressEntries.serverId.equalsExp(libraryItems.serverId) &
                    mediaProgressEntries.libraryItemId.equalsExp(
                      libraryItems.id,
                    ),
              ),
            ])..where(
              libraryItems.serverId.equals(serverId) &
                  libraryItems.id.isIn(orderedIds),
            ))
            .get();

    final byId = <String, LibraryItemWithProgress>{};
    for (final row in joined) {
      final item = row.readTable(libraryItems);
      byId[item.id] = LibraryItemWithProgress(
        item: item,
        progress: row.readTableOrNull(mediaProgressEntries),
      );
    }

    return <LibraryItemWithProgress>[for (final id in orderedIds) ?byId[id]];
  }

  /// Converts arbitrary user input into a safe FTS5 prefix `MATCH` expression.
  static String buildFtsMatchQuery(String rawQuery) {
    final cleaned = rawQuery
        .replaceAll(RegExp(r'[^\p{L}\p{N}_]+', unicode: true), ' ')
        .trim();
    if (cleaned.isEmpty) return '';
    final tokens = cleaned
        .split(RegExp(r'\s+'))
        .where((token) => token.isNotEmpty)
        .map((token) => '"$token"*');
    return tokens.join(' ');
  }

  static String _decodeTagsForFts(String tagsJson) {
    try {
      final decoded = jsonDecode(tagsJson);
      if (decoded is List) {
        return decoded.whereType<String>().join(' ');
      }
    } on FormatException {
      // Ignore malformed tag JSON.
    }
    return '';
  }

  // ---------------------------------------------------------------------------
  // Chapters
  // ---------------------------------------------------------------------------

  /// Watches chapters for [serverId] and [libraryItemId] ordered by index.
  Stream<List<Chapter>> watchChapters(String serverId, String libraryItemId) {
    return (select(chapters)
          ..where(
            (tbl) =>
                tbl.serverId.equals(serverId) &
                tbl.libraryItemId.equals(libraryItemId),
          )
          ..orderBy(<OrderingTerm Function(Chapters)>[
            (tbl) => OrderingTerm.asc(tbl.chapterIndex),
          ]))
        .watch();
  }

  /// Replaces cached chapters for [serverId] and [libraryItemId].
  Future<void> replaceChapters(
    String serverId,
    String libraryItemId,
    List<ChaptersCompanion> entries,
  ) {
    return transaction(() async {
      await (delete(chapters)..where(
            (tbl) =>
                tbl.serverId.equals(serverId) &
                tbl.libraryItemId.equals(libraryItemId),
          ))
          .go();
      if (entries.isNotEmpty) {
        await batch((b) => b.insertAll(chapters, entries));
      }
    });
  }

  // ---------------------------------------------------------------------------
  // MediaProgressEntries
  // ---------------------------------------------------------------------------

  /// Upserts [entries] into `media_progress_entries`.
  Future<void> upsertMediaProgressEntries(
    List<MediaProgressEntriesCompanion> entries,
  ) {
    if (entries.isEmpty) return Future<void>.value();
    return transaction(() async {
      for (final entry in entries) {
        await into(mediaProgressEntries).insertOnConflictUpdate(entry);
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Bookmarks
  // ---------------------------------------------------------------------------

  /// Watches bookmarks for [serverId] and [libraryItemId] ordered by timestamp.
  Stream<List<Bookmark>> watchBookmarks(String serverId, String libraryItemId) {
    return (select(bookmarks)
          ..where(
            (tbl) =>
                tbl.serverId.equals(serverId) &
                tbl.libraryItemId.equals(libraryItemId),
          )
          ..orderBy(<OrderingTerm Function(Bookmarks)>[
            (tbl) => OrderingTerm.asc(tbl.timeSec),
          ]))
        .watch();
  }

  /// Replaces all synced bookmarks for [serverId].
  Future<void> replaceBookmarksForServer(
    String serverId,
    List<BookmarksCompanion> entries,
  ) {
    return transaction(() async {
      await (delete(
        bookmarks,
      )..where((tbl) => tbl.serverId.equals(serverId))).go();
      if (entries.isNotEmpty) {
        await batch((b) => b.insertAll(bookmarks, entries));
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Collections
  // ---------------------------------------------------------------------------

  /// Watches cached collections for [serverId] and [libraryId].
  Stream<List<Collection>> watchCollections(String serverId, String libraryId) {
    return (select(collections)
          ..where(
            (tbl) =>
                tbl.serverId.equals(serverId) & tbl.libraryId.equals(libraryId),
          )
          ..orderBy(<OrderingTerm Function(Collections)>[
            (tbl) => OrderingTerm.asc(tbl.name),
          ]))
        .watch();
  }

  /// Replaces cached collections for [serverId] and [libraryId].
  Future<void> replaceCollections(
    String serverId,
    String libraryId,
    List<CollectionsCompanion> entries,
  ) {
    return transaction(() async {
      await (delete(collections)..where(
            (tbl) =>
                tbl.serverId.equals(serverId) & tbl.libraryId.equals(libraryId),
          ))
          .go();
      if (entries.isNotEmpty) {
        await batch((b) => b.insertAll(collections, entries));
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Phase 3 Playback Progress, Bookmarks, and History
  // ---------------------------------------------------------------------------

  /// Updates local playback progress for [serverId] and [libraryItemId].
  Future<void> updateLocalProgress({
    required String serverId,
    required String libraryItemId,
    required double positionSec,
    required double durationSec,
    required int updatedAtMs,
    bool markSynced = false,
  }) {
    final safePos = positionSec < 0 ? 0.0 : positionSec;
    final ratio = durationSec > 0
        ? (safePos / durationSec).clamp(0.0, 1.0)
        : 0.0;
    final finished = durationSec > 0 && safePos >= durationSec - 1;
    return transaction(() async {
      final existing =
          await (select(mediaProgressEntries)..where(
                (tbl) =>
                    tbl.serverId.equals(serverId) &
                    tbl.libraryItemId.equals(libraryItemId),
              ))
              .getSingleOrNull();
      final resolvedDuration = durationSec > 0
          ? durationSec
          : (existing?.durationSec ?? 0.0);
      await into(mediaProgressEntries).insertOnConflictUpdate(
        MediaProgressEntriesCompanion.insert(
          serverId: serverId,
          libraryItemId: libraryItemId,
          durationSec: Value<double>(resolvedDuration),
          localPositionSec: Value<double>(safePos),
          serverPositionSec: Value<double>(
            markSynced ? safePos : (existing?.serverPositionSec ?? 0.0),
          ),
          lastSyncedPositionSec: Value<double>(
            markSynced ? safePos : (existing?.lastSyncedPositionSec ?? 0.0),
          ),
          progress: Value<double>(ratio),
          isFinished: Value<bool>(finished),
          hideFromContinueListening: Value<bool>(
            existing?.hideFromContinueListening ?? false,
          ),
          localUpdatedAtMs: Value<int>(updatedAtMs),
          serverUpdatedAtMs: Value<int>(
            markSynced ? updatedAtMs : (existing?.serverUpdatedAtMs ?? 0),
          ),
          syncState: Value<String>(markSynced ? 'synced' : 'pendingPush'),
        ),
      );
    });
  }

  /// Inserts or updates a single [entry] bookmark.
  Future<void> upsertBookmark(BookmarksCompanion entry) {
    return into(bookmarks).insertOnConflictUpdate(entry);
  }

  /// Deletes the bookmark at [timeSec] for [serverId] and [libraryItemId].
  Future<void> deleteBookmark(
    String serverId,
    String libraryItemId,
    double timeSec,
  ) {
    return (delete(bookmarks)..where(
          (tbl) =>
              tbl.serverId.equals(serverId) &
              tbl.libraryItemId.equals(libraryItemId) &
              tbl.timeSec.equals(timeSec),
        ))
        .go();
  }

  /// Watches playback jump history for [serverId] and [libraryItemId],
  /// ordered newest-first.
  Stream<List<PlaybackHistoryEntry>> watchPlaybackHistory(
    String serverId,
    String libraryItemId,
  ) {
    return (select(playbackHistoryEntries)
          ..where(
            (tbl) =>
                tbl.serverId.equals(serverId) &
                tbl.libraryItemId.equals(libraryItemId),
          )
          ..orderBy(<OrderingTerm Function(PlaybackHistoryEntries)>[
            (tbl) => OrderingTerm.desc(tbl.createdAtMs),
            (tbl) => OrderingTerm.desc(tbl.id),
          ]))
        .watch();
  }

  /// Records a playback jump history entry and retains at most 100 entries
  /// per item.
  Future<void> recordPlaybackHistory({
    required String serverId,
    required String libraryItemId,
    required double positionSec,
    required String reason,
    required int createdAtMs,
    int maxEntries = 100,
  }) {
    return transaction(() async {
      await into(playbackHistoryEntries).insert(
        PlaybackHistoryEntriesCompanion.insert(
          serverId: serverId,
          libraryItemId: libraryItemId,
          positionSec: positionSec,
          reason: reason,
          createdAtMs: createdAtMs,
        ),
      );
      final overflow =
          await (select(playbackHistoryEntries)
                ..where(
                  (tbl) =>
                      tbl.serverId.equals(serverId) &
                      tbl.libraryItemId.equals(libraryItemId),
                )
                ..orderBy(<OrderingTerm Function(PlaybackHistoryEntries)>[
                  (tbl) => OrderingTerm.desc(tbl.createdAtMs),
                  (tbl) => OrderingTerm.desc(tbl.id),
                ])
                ..limit(1000, offset: maxEntries))
              .get();
      if (overflow.isNotEmpty) {
        final ids = overflow.map((e) => e.id).toList(growable: false);
        await (delete(
          playbackHistoryEntries,
        )..where((tbl) => tbl.id.isIn(ids))).go();
      }
    });
  }
}
