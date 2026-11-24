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
  });
}
