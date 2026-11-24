import 'package:checks/checks.dart';
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_plus/core/database/app_database.dart';

void main() {
  group('AppDatabase Library & FTS5', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase.inMemory();
    });

    tearDown(() async {
      await db.close();
    });

    test(
      'buildFtsMatchQuery sanitizes punctuation and formats prefix tokens',
      () {
        check(AppDatabase.buildFtsMatchQuery('')).equals('');
        check(AppDatabase.buildFtsMatchQuery('   ***  ')).equals('');
        check(AppDatabase.buildFtsMatchQuery('Project: Hail-Mary!'))
            .equals('"Project"* "Hail"* "Mary"*');
      },
    );

    test(
      'upserts items, indexes FTS5 across fields, and deletes cleanly',
      () async {
        await db.replaceLibraries('s1', <LibrariesCompanion>[
          LibrariesCompanion.insert(
            serverId: 's1',
            id: 'lib-1',
            name: 'Audiobooks',
            mediaType: 'book',
            lastSyncedAtMs: 1000,
          ),
        ]);

        await db.upsertLibraryItems('s1', <LibraryItemsCompanion>[
          LibraryItemsCompanion.insert(
            serverId: 's1',
            id: 'b1',
            libraryId: 'lib-1',
            title: 'Project Hail Mary',
            authors: const Value('Andy Weir'),
            narrators: const Value('Ray Porter'),
            seriesName: const Value('Cosmic Tales'),
            tagsJson: const Value('["sci-fi","space"]'),
          ),
          LibraryItemsCompanion.insert(
            serverId: 's1',
            id: 'b2',
            libraryId: 'lib-1',
            title: 'Piranesi',
            authors: const Value('Susanna Clarke'),
            narrators: const Value('Chiwetel Ejiofor'),
            tagsJson: const Value('["labyrinth"]'),
          ),
        ]);

        await db.upsertMediaProgressEntries(<MediaProgressEntriesCompanion>[
          MediaProgressEntriesCompanion.insert(
            serverId: 's1',
            libraryItemId: 'b1',
            localPositionSec: const Value(1200),
            progress: const Value(0.25),
          ),
        ]);

        await db.replaceChapters('s1', 'b1', <ChaptersCompanion>[
          ChaptersCompanion.insert(
            serverId: 's1',
            libraryItemId: 'b1',
            chapterIndex: 0,
            title: 'Chapter 1',
            startSec: 0,
            endSec: 900,
          ),
        ]);

        // Search by narrator prefix.
        final narratorMatches = await db.searchLibraryItemsFts(
          serverId: 's1',
          query: 'Port',
        );
        check(narratorMatches.length).equals(1);
        check(narratorMatches.single.item.id).equals('b1');
        check(narratorMatches.single.progress?.localPositionSec).equals(1200);

        // Search by tag with punctuation.
        final tagMatches = await db.searchLibraryItemsFts(
          serverId: 's1',
          query: 'labyr!',
        );
        check(tagMatches.length).equals(1);
        check(tagMatches.single.item.id).equals('b2');

        // Delete b1 cascades to FTS, chapters, and progress.
        await db.deleteLibraryItem('s1', 'b1');
        check(await db.searchLibraryItemsFts(serverId: 's1', query: 'Hail'))
            .isEmpty;
        check(await db.watchChapters('s1', 'b1').first).isEmpty;
      },
    );

    test('records up to 100 history jumps, upserts/deletes bookmarks, and '
        'cascades deletes', () async {
      await db.upsertLibraryItems('s1', <LibraryItemsCompanion>[
        LibraryItemsCompanion.insert(
          serverId: 's1',
          id: 'b1',
          libraryId: 'lib-1',
          title: 'Project Hail Mary',
        ),
      ]);
      for (var i = 0; i < 110; i++) {
        await db.recordPlaybackHistory(
          serverId: 's1',
          libraryItemId: 'b1',
          positionSec: i * 10.0,
          reason: 'seek',
          createdAtMs: 1000 + i,
        );
      }

      final history = await db.watchPlaybackHistory('s1', 'b1').first;
      check(history.length).equals(100);
      check(history.first.positionSec).equals(1090);
      check(history.last.positionSec).equals(100);

      await db.upsertBookmark(
        BookmarksCompanion.insert(
          serverId: 's1',
          libraryItemId: 'b1',
          timeSec: 325,
          title: 'Key Quote',
          note: const Value<String?>('Favorite passage'),
          createdAtMs: const Value<int>(5000),
        ),
      );
      var bookmarks = await db.watchBookmarks('s1', 'b1').first;
      check(bookmarks.length).equals(1);
      check(bookmarks.first.note).equals('Favorite passage');

      await db.updateLocalProgress(
        serverId: 's1',
        libraryItemId: 'b1',
        positionSec: 500,
        durationSec: 1000,
        updatedAtMs: 6000,
      );
      final withProgress = await db.watchItemsWithProgress('s1').first;
      final b1Row = withProgress
          .where((row) => row.item.id == 'b1')
          .firstOrNull;
      check(b1Row?.progress?.localPositionSec).equals(500);
      check(b1Row?.progress?.syncState).equals('pendingPush');

      await db.deleteBookmark('s1', 'b1', 325);
      bookmarks = await db.watchBookmarks('s1', 'b1').first;
      check(bookmarks).isEmpty;

      await db.deleteLibraryItem('s1', 'b1');
      final remainingHistory = await db.watchPlaybackHistory('s1', 'b1').first;
      check(remainingHistory).isEmpty;
    });
  });
}
