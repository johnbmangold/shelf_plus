import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:shelf_plus/core/database/tables/app_preferences_table.dart';
import 'package:shelf_plus/core/database/tables/bookmarks_table.dart';
import 'package:shelf_plus/core/database/tables/chapters_table.dart';
import 'package:shelf_plus/core/database/tables/collections_table.dart';
import 'package:shelf_plus/core/database/tables/download_tasks_table.dart';
import 'package:shelf_plus/core/database/tables/downloaded_tracks_table.dart';
import 'package:shelf_plus/core/database/tables/libraries_table.dart';
import 'package:shelf_plus/core/database/tables/library_items_table.dart';
import 'package:shelf_plus/core/database/tables/media_progress_table.dart';
import 'package:shelf_plus/core/database/tables/pending_sync_mutations_table.dart';
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

/// Joined row pairing a [DownloadTask] with its [LibraryItem] and optional
/// [MediaProgressEntry].
class DownloadedBookRow {
  /// Creates a [DownloadedBookRow].
  const new({required this.task, required this.item, this.progress});

  /// Download queue task state.
  final DownloadTask task;

  /// Associated cached library item.
  final LibraryItem item;

  /// Associated progress entry, if any.
  final MediaProgressEntry? progress;
}

/// Joined row pairing a conflicted [MediaProgressEntry] with its [LibraryItem].
class ConflictedProgressRow {
  /// Creates a [ConflictedProgressRow].
  const new({required this.item, required this.progress});

  /// Associated cached library item.
  final LibraryItem item;

  /// Conflicted progress entry (`syncState == 'conflict'`).
  final MediaProgressEntry progress;
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
    DownloadTasks,
    DownloadedTracks,
    PendingSyncMutations,
    AppPreferences,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Opens the persistent on-device database, or wraps a custom [executor].
  new([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'shelf_plus'));

  /// Creates an isolated in-memory database for unit and widget tests.
  factory inMemory() => AppDatabase(
    DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ),
  );

  @override
  int get schemaVersion => 4;

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
      if (from < 4) {
        await m.createTable(downloadTasks);
        await m.createTable(downloadedTracks);
        await m.createTable(pendingSyncMutations);
        await m.createTable(appPreferences);
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
      await (delete(downloadTasks)..where(
            (tbl) =>
                tbl.serverId.equals(serverId) &
                tbl.libraryItemId.equals(itemId),
          ))
          .go();
      await (delete(downloadedTracks)..where(
            (tbl) =>
                tbl.serverId.equals(serverId) &
                tbl.libraryItemId.equals(itemId),
          ))
          .go();
      await (delete(pendingSyncMutations)..where(
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

  /// Replaces synced bookmarks for [serverId], preserving local notes for
  /// matching `(libraryItemId, timeSec)` entries.
  Future<void> replaceBookmarksForServer(
    String serverId,
    List<BookmarksCompanion> entries,
  ) {
    return transaction(() async {
      final existing = await (select(
        bookmarks,
      )..where((tbl) => tbl.serverId.equals(serverId))).get();
      final notesByKey = <(String, double), String?>{
        for (final row in existing)
          if (row.note != null && row.note!.isNotEmpty)
            (row.libraryItemId, row.timeSec): row.note,
      };
      await (delete(
        bookmarks,
      )..where((tbl) => tbl.serverId.equals(serverId))).go();
      if (entries.isNotEmpty) {
        final merged = entries
            .map((entry) {
              final existingNote =
                  notesByKey[(entry.libraryItemId.value, entry.timeSec.value)];
              if (existingNote == null ||
                  (entry.note.present && entry.note.value != null)) {
                return entry;
              }
              return entry.copyWith(note: Value<String?>(existingNote));
            })
            .toList(growable: false);
        await batch((b) => b.insertAll(bookmarks, merged));
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

  // ---------------------------------------------------------------------------
  // Phase 4 AppPreferences
  // ---------------------------------------------------------------------------

  /// Reads a preference value by [key], or returns `null` if unset.
  Future<String?> getPreference(String key) async {
    final row = await (select(
      appPreferences,
    )..where((tbl) => tbl.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  /// Stores or overwrites preference [key] with [value].
  Future<void> setPreference(String key, String value) {
    return into(appPreferences).insertOnConflictUpdate(
      AppPreferencesCompanion.insert(key: key, value: value),
    );
  }

  // ---------------------------------------------------------------------------
  // Phase 4 DownloadTasks & DownloadedTracks
  // ---------------------------------------------------------------------------

  /// Watches download tasks joined with their library items and progress.
  Stream<List<DownloadedBookRow>> watchDownloadedBooks(String serverId) {
    final query =
        select(downloadTasks).join(<Join<HasResultSet, dynamic>>[
            innerJoin(
              libraryItems,
              libraryItems.serverId.equalsExp(downloadTasks.serverId) &
                  libraryItems.id.equalsExp(downloadTasks.libraryItemId),
            ),
            leftOuterJoin(
              mediaProgressEntries,
              mediaProgressEntries.serverId.equalsExp(downloadTasks.serverId) &
                  mediaProgressEntries.libraryItemId.equalsExp(
                    downloadTasks.libraryItemId,
                  ),
            ),
          ])
          ..where(downloadTasks.serverId.equals(serverId))
          ..orderBy(<OrderingTerm>[
            OrderingTerm.desc(downloadTasks.updatedAtMs),
          ]);

    return query.watch().map(
      (rows) => rows
          .map(
            (row) => DownloadedBookRow(
              task: row.readTable(downloadTasks),
              item: row.readTable(libraryItems),
              progress: row.readTableOrNull(mediaProgressEntries),
            ),
          )
          .toList(growable: false),
    );
  }

  /// Watches all [DownloadTask] rows for [serverId].
  Stream<List<DownloadTask>> watchDownloadTasks(String serverId) {
    return (select(downloadTasks)
          ..where((tbl) => tbl.serverId.equals(serverId))
          ..orderBy(<OrderingTerm Function(DownloadTasks)>[
            (tbl) => OrderingTerm.desc(tbl.updatedAtMs),
          ]))
        .watch();
  }

  /// Fetches all [DownloadTask] rows for [serverId].
  Future<List<DownloadTask>> getDownloadTasks(String serverId) {
    return (select(downloadTasks)
          ..where((tbl) => tbl.serverId.equals(serverId))
          ..orderBy(<OrderingTerm Function(DownloadTasks)>[
            (tbl) => OrderingTerm.desc(tbl.updatedAtMs),
          ]))
        .get();
  }

  /// Watches a single [DownloadTask] for [serverId] and [itemId].
  Stream<DownloadTask?> watchDownloadTask(String serverId, String itemId) {
    return (select(downloadTasks)
          ..where(
            (tbl) =>
                tbl.serverId.equals(serverId) &
                tbl.libraryItemId.equals(itemId),
          )
          ..limit(1))
        .watchSingleOrNull();
  }

  /// Fetches a single [DownloadTask] for [serverId] and [itemId].
  Future<DownloadTask?> getDownloadTask(String serverId, String itemId) {
    return (select(downloadTasks)
          ..where(
            (tbl) =>
                tbl.serverId.equals(serverId) &
                tbl.libraryItemId.equals(itemId),
          )
          ..limit(1))
        .getSingleOrNull();
  }

  /// Inserts or updates a [DownloadTask].
  Future<void> upsertDownloadTask(DownloadTasksCompanion entry) {
    return into(downloadTasks).insertOnConflictUpdate(entry);
  }

  /// Partially updates an existing [DownloadTask] for [serverId] and [itemId].
  Future<void> updateDownloadTask(
    String serverId,
    String itemId,
    DownloadTasksCompanion entry,
  ) {
    return (update(downloadTasks)..where(
          (tbl) =>
              tbl.serverId.equals(serverId) & tbl.libraryItemId.equals(itemId),
        ))
        .write(entry);
  }

  /// Deletes both the [DownloadTask] and all [DownloadedTracks] for [itemId].
  Future<void> deleteDownloadForBook(String serverId, String itemId) {
    return transaction(() async {
      await (delete(downloadedTracks)..where(
            (tbl) =>
                tbl.serverId.equals(serverId) &
                tbl.libraryItemId.equals(itemId),
          ))
          .go();
      await (delete(downloadTasks)..where(
            (tbl) =>
                tbl.serverId.equals(serverId) &
                tbl.libraryItemId.equals(itemId),
          ))
          .go();
    });
  }

  /// Returns ordered [DownloadedTrack] rows for [serverId] and [itemId].
  Future<List<DownloadedTrack>> getDownloadedTracks(
    String serverId,
    String itemId,
  ) {
    return (select(downloadedTracks)
          ..where(
            (tbl) =>
                tbl.serverId.equals(serverId) &
                tbl.libraryItemId.equals(itemId),
          )
          ..orderBy(<OrderingTerm Function(DownloadedTracks)>[
            (tbl) => OrderingTerm.asc(tbl.trackIndex),
          ]))
        .get();
  }

  /// Replaces the [DownloadedTrack] entries for [serverId] and [itemId].
  Future<void> replaceDownloadedTracks(
    String serverId,
    String itemId,
    List<DownloadedTracksCompanion> tracks,
  ) {
    return transaction(() async {
      await (delete(downloadedTracks)..where(
            (tbl) =>
                tbl.serverId.equals(serverId) &
                tbl.libraryItemId.equals(itemId),
          ))
          .go();
      if (tracks.isNotEmpty) {
        await batch((b) => b.insertAll(downloadedTracks, tracks));
      }
    });
  }

  /// Updates byte progress and completion status for a single track.
  Future<void> updateDownloadedTrackProgress({
    required String serverId,
    required String libraryItemId,
    required int trackIndex,
    required int downloadedBytes,
    int? expectedBytes,
    bool? isComplete,
  }) {
    return (update(downloadedTracks)..where(
          (tbl) =>
              tbl.serverId.equals(serverId) &
              tbl.libraryItemId.equals(libraryItemId) &
              tbl.trackIndex.equals(trackIndex),
        ))
        .write(
          DownloadedTracksCompanion(
            downloadedBytes: Value<int>(downloadedBytes),
            expectedBytes: expectedBytes == null
                ? const Value<int>.absent()
                : Value<int>(expectedBytes),
            isComplete: isComplete == null
                ? const Value<bool>.absent()
                : Value<bool>(isComplete),
          ),
        );
  }

  // ---------------------------------------------------------------------------
  // Phase 4 Offline Sync & Conflicts
  // ---------------------------------------------------------------------------

  /// Returns the cached [MediaProgressEntry] for [serverId] and [itemId].
  Future<MediaProgressEntry?> getMediaProgress(String serverId, String itemId) {
    return (select(mediaProgressEntries)
          ..where(
            (tbl) =>
                tbl.serverId.equals(serverId) &
                tbl.libraryItemId.equals(itemId),
          )
          ..limit(1))
        .getSingleOrNull();
  }

  /// Watches all progress conflicts (`syncState == 'conflict'`) for [serverId].
  Stream<List<ConflictedProgressRow>> watchConflictedProgress(String serverId) {
    final query =
        select(mediaProgressEntries).join(<Join<HasResultSet, dynamic>>[
            innerJoin(
              libraryItems,
              libraryItems.serverId.equalsExp(mediaProgressEntries.serverId) &
                  libraryItems.id.equalsExp(mediaProgressEntries.libraryItemId),
            ),
          ])
          ..where(
            mediaProgressEntries.serverId.equals(serverId) &
                mediaProgressEntries.syncState.equals('conflict'),
          )
          ..orderBy(<OrderingTerm>[
            OrderingTerm.desc(mediaProgressEntries.localUpdatedAtMs),
          ]);

    return query.watch().map(
      (rows) => rows
          .map(
            (row) => ConflictedProgressRow(
              item: row.readTable(libraryItems),
              progress: row.readTable(mediaProgressEntries),
            ),
          )
          .toList(growable: false),
    );
  }

  /// Enqueues an offline sync mutation, coalescing duplicate `'progress'`
  /// mutations for the same item so only the latest listening position ships.
  Future<void> enqueueSyncMutation({
    required String serverId,
    required String libraryItemId,
    required String mutationType,
    required String payloadJson,
    required int createdAtMs,
  }) {
    return transaction(() async {
      if (mutationType == 'progress') {
        await (delete(pendingSyncMutations)..where(
              (tbl) =>
                  tbl.serverId.equals(serverId) &
                  tbl.libraryItemId.equals(libraryItemId) &
                  tbl.mutationType.equals('progress'),
            ))
            .go();
      }
      await into(pendingSyncMutations).insert(
        PendingSyncMutationsCompanion.insert(
          serverId: serverId,
          libraryItemId: libraryItemId,
          mutationType: mutationType,
          payloadJson: payloadJson,
          createdAtMs: createdAtMs,
        ),
      );
    });
  }

  /// Returns all queued offline mutations for [serverId] in FIFO order.
  Future<List<PendingSyncMutation>> getPendingSyncMutations(String serverId) {
    return (select(pendingSyncMutations)
          ..where((tbl) => tbl.serverId.equals(serverId))
          ..orderBy(<OrderingTerm Function(PendingSyncMutations)>[
            (tbl) => OrderingTerm.asc(tbl.id),
          ]))
        .get();
  }

  /// Watches the pending offline mutation count for [serverId].
  Stream<int> watchPendingSyncCount(String serverId) {
    final query = select(pendingSyncMutations)
      ..where((tbl) => tbl.serverId.equals(serverId));
    return query.watch().map((rows) => rows.length);
  }

  /// Removes a flushed mutation by [id].
  Future<void> deleteSyncMutation(int id) {
    return (delete(
      pendingSyncMutations,
    )..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Removes any queued `'progress'` or `'localSession'` mutations for
  /// [serverId] and [itemId].
  Future<void> deleteProgressMutationsForItem(String serverId, String itemId) {
    return (delete(pendingSyncMutations)..where(
          (tbl) =>
              tbl.serverId.equals(serverId) &
              tbl.libraryItemId.equals(itemId) &
              tbl.mutationType.isIn(const <String>['progress', 'localSession']),
        ))
        .go();
  }

  /// Increments retry count and records [error] for mutation [id].
  Future<void> markSyncMutationFailed(int id, String error) {
    return customStatement(
      'UPDATE pending_sync_mutations '
      'SET retry_count = retry_count + 1, last_error = ? '
      'WHERE id = ?',
      <Object>[error, id],
    );
  }
}
