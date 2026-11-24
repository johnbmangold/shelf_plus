import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/theme/app_theme_mode.dart';
import 'package:shelf_plus/core/theme/theme_controller.dart';
import 'package:shelf_plus/features/library/domain/library_models.dart';

import '../../../fakes/fake_cover_theme_extractor.dart';
import '../../../fakes/fake_library_repository.dart';
import '../../../fixtures/abs_library_fixtures.dart';
import '../../../helpers/pump_app.dart';

void main() {
  group('BookDetailScreen', () {
    testWidgets(
      'displays dynamic cover theme, Overview, Chapters, and Bookmarks tabs',
      (tester) async {
        final fakeRepo = FakeLibraryRepository(
          books: const <BookSummary>[AbsLibraryFixtures.bookOne],
          chaptersByBookId: const <String, List<ChapterInfo>>{
            'item-1': <ChapterInfo>[
              ChapterInfo(
                index: 0,
                title: 'Chapter 1: Awakening',
                startSec: 0,
                endSec: 1800,
              ),
              ChapterInfo(
                index: 1,
                title: 'Chapter 2: Tau Ceti',
                startSec: 1800,
                endSec: 58200,
              ),
            ],
          },
          bookmarksByBookId: const <String, List<BookmarkEntry>>{
            'item-1': <BookmarkEntry>[
              BookmarkEntry(
                timeSec: 620,
                title: 'Rocky arrives',
                note: 'First contact scene',
                createdAtMs: 1718000000000,
              ),
            ],
          },
        );
        final extractor = FakeCoverThemeExtractor(
          seedColor: const Color(0xFF1F6F8B),
        );
        final themeController = ThemeController(
          initialMode: AppThemeMode.amoled,
        );
        final deps = createTestDependencies(
          libraryRepository: fakeRepo,
          coverThemeExtractor: extractor,
          themeController: themeController,
        );
        await tester.pumpShelfApp(dependencies: deps);

        await tester.tap(find.byKey(const Key('home_hero_book_item-1')));
        await tester.pumpAndSettle();

        check(extractor.calls).isGreaterThan(0);
        check(find.text('A lone astronaut must save Earth.').evaluate().length)
            .equals(1);
        check(find.text('Audible Studios').evaluate().length).equals(1);

        // Switch to Chapters tab.
        await tester.tap(find.text('Chapters'));
        await tester.pumpAndSettle();
        check(find.text('Chapter 1: Awakening').evaluate().length).equals(1);

        // Switch to Bookmarks tab.
        await tester.tap(find.text('Bookmarks'));
        await tester.pumpAndSettle();
        check(find.text('Rocky arrives').evaluate().length).equals(1);
        check(find.text('First contact scene').evaluate().length).equals(1);

        // Tap Play launches playback + pushes FullPlayerScreen.
        await tester.tap(find.byKey(const Key('book_detail_play_button')));
        await tester.pumpAndSettle();
        check(
          find.byKey(const Key('player_play_pause_button')).evaluate().length,
        ).equals(1);

        // Return to Book Detail and verify Download placeholder.
        await tester.tap(find.byKey(const Key('player_close_button')));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('book_detail_download_button')));
        await tester.pumpAndSettle();
        check(
          find.text('Offline downloads launch in Phase 4.').evaluate().length,
        ).equals(1);
      },
    );

    testWidgets('renders empty chapters and bookmarks messages when absent', (
      tester,
    ) async {
      final fakeRepo = FakeLibraryRepository(
        books: const <BookSummary>[AbsLibraryFixtures.bookTwo],
      );
      await tester.pumpShelfApp(
        dependencies: createTestDependencies(libraryRepository: fakeRepo),
      );
      await tester.tap(find.byKey(const Key('home_shelf_book_item-2')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Chapters'));
      await tester.pumpAndSettle();
      check(find.text('No chapters available').evaluate().length).equals(1);

      await tester.tap(find.text('Bookmarks'));
      await tester.pumpAndSettle();
      check(find.text('No bookmarks yet').evaluate().length).equals(1);
    });

    testWidgets('meets accessibility guidelines', (tester) async {
      final handle = tester.ensureSemantics();
      try {
        final fakeRepo = FakeLibraryRepository(
          books: const <BookSummary>[AbsLibraryFixtures.bookOne],
        );
        await tester.pumpShelfApp(
          dependencies: createTestDependencies(libraryRepository: fakeRepo),
        );
        await tester.tap(find.byKey(const Key('home_hero_book_item-1')));
        await tester.pumpAndSettle();

        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
      } finally {
        handle.dispose();
      }
    });
  });
}
