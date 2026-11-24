import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/features/library/domain/library_models.dart';

import '../../../fakes/fake_library_repository.dart';
import '../../../fixtures/abs_library_fixtures.dart';
import '../../../helpers/pump_app.dart';

void main() {
  group('HomeScreen', () {
    testWidgets(
      'displays Continue Listening hero, shelves, and opens Book Detail',
      (tester) async {
        final fakeRepo = FakeLibraryRepository(
          books: const <BookSummary>[
            AbsLibraryFixtures.bookOne,
            AbsLibraryFixtures.bookTwo,
            AbsLibraryFixtures.bookThree,
          ],
        );
        final deps = createTestDependencies(libraryRepository: fakeRepo);
        await tester.pumpShelfApp(dependencies: deps);

        check(find.text('Continue listening').evaluate().length).equals(1);
        check(find.text('Recently added').evaluate().length).equals(1);
        check(find.text('Project Hail Mary').evaluate().length)
            .isGreaterThan(0);

        await tester.tap(find.byKey(const Key('home_hero_book_item-1')));
        await tester.pumpAndSettle();

        check(find.text('Overview').evaluate().length).equals(1);
        check(find.text('Chapters').evaluate().length).equals(1);
      },
    );

    testWidgets(
      'shows non-blocking offline banner when sync fails with cached books',
      (tester) async {
        final fakeRepo = FakeLibraryRepository(
          books: const <BookSummary>[AbsLibraryFixtures.bookOne],
        )..syncError = Exception('Offline');

        final deps = createTestDependencies(
          libraryRepository: fakeRepo,
          autoSyncOnStart: true,
        );
        await tester.pumpShelfApp(dependencies: deps);

        check(find.text('Offline — showing cached library').evaluate().length)
            .equals(1);
        check(find.text('Project Hail Mary').evaluate().length)
            .isGreaterThan(0);
      },
    );

    testWidgets('meets accessibility guidelines', (tester) async {
      final handle = tester.ensureSemantics();
      try {
        final fakeRepo = FakeLibraryRepository(
          books: const <BookSummary>[
            AbsLibraryFixtures.bookOne,
            AbsLibraryFixtures.bookTwo,
          ],
        );
        await tester.pumpShelfApp(
          dependencies: createTestDependencies(libraryRepository: fakeRepo),
        );
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
      } finally {
        handle.dispose();
      }
    });
  });
}
