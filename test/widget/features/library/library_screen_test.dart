import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/features/library/domain/library_models.dart';

import '../../../fakes/fake_library_repository.dart';
import '../../../fixtures/abs_library_fixtures.dart';
import '../../../helpers/pump_app.dart';

void main() {
  group('LibraryScreen', () {
    testWidgets(
      'switches browse modes, searches, sorts/filters, and opens Book Detail',
      (tester) async {
        final fakeRepo = FakeLibraryRepository(
          libraries: const <LibrarySummary>[
            LibrarySummary(
              id: 'lib-main',
              name: 'Audiobooks',
              mediaType: 'book',
              icon: 'book',
              displayOrder: 0,
            ),
          ],
          books: const <BookSummary>[
            AbsLibraryFixtures.bookOne,
            AbsLibraryFixtures.bookTwo,
            AbsLibraryFixtures.bookThree,
          ],
          collections: const <BookCollection>[
            BookCollection(
              id: 'col-1',
              libraryId: 'lib-main',
              name: 'Favorites',
              books: <BookSummary>[
                AbsLibraryFixtures.bookOne,
                AbsLibraryFixtures.bookTwo,
              ],
            ),
          ],
        );
        await tester.pumpShelfApp(
          dependencies: createTestDependencies(libraryRepository: fakeRepo),
        );

        await tester.tap(find.text('Library'));
        await tester.pumpAndSettle();

        check(find.text('Project Hail Mary').evaluate().length).equals(1);
        check(find.text('Piranesi').evaluate().length).equals(1);

        // Search filters down to Piranesi.
        await tester.enterText(
          find.byKey(const Key('library_search_field')),
          'Clarke',
        );
        await tester.pumpAndSettle();
        check(find.text('Piranesi').evaluate().length).equals(1);
        check(find.text('Project Hail Mary').evaluate()).isEmpty;

        await tester.tap(find.byKey(const Key('library_clear_search_button')));
        await tester.pumpAndSettle();

        // Browse Series and drill down.
        await tester.tap(find.text('Series'));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('series_group_Cosmic Tales')));
        await tester.pumpAndSettle();
        check(find.text('The Martian').evaluate().length).equals(1);
        await tester.tap(find.byKey(const Key('library_group_back_button')));
        await tester.pumpAndSettle();

        // Browse Authors and Collections.
        await tester.tap(find.text('Authors'));
        await tester.pumpAndSettle();
        check(find.text('Susanna Clarke').evaluate().length).equals(1);

        await tester.tap(find.text('Collections'));
        await tester.pumpAndSettle();
        check(find.text('Favorites').evaluate().length).equals(1);

        // Switch back to Books and filter via Sort & Filter sheet.
        await tester.tap(find.text('Books'));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('library_sort_filter_button')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('filter_chip_finished')));
        await tester.pumpAndSettle();
        Navigator.of(tester.element(find.text('Sort & Filter'))).pop();
        await tester.pumpAndSettle();

        check(find.text('The Martian').evaluate().length).equals(1);
        check(find.text('Piranesi').evaluate()).isEmpty;

        await tester.tap(find.byKey(const Key('library_book_item-3')));
        await tester.pumpAndSettle();
        check(find.text('Overview').evaluate().length).equals(1);
      },
    );

    testWidgets('meets accessibility guidelines', (tester) async {
      final handle = tester.ensureSemantics();
      try {
        final fakeRepo = FakeLibraryRepository(
          libraries: const <LibrarySummary>[
            LibrarySummary(
              id: 'lib-main',
              name: 'Audiobooks',
              mediaType: 'book',
              icon: 'book',
              displayOrder: 0,
            ),
          ],
          books: const <BookSummary>[AbsLibraryFixtures.bookOne],
        );
        await tester.pumpShelfApp(
          dependencies: createTestDependencies(libraryRepository: fakeRepo),
        );
        await tester.tap(find.text('Library'));
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
