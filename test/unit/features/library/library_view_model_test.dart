import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_plus/features/library/domain/library_models.dart';
import 'package:shelf_plus/features/library/presentation/library_view_model.dart';

import '../../../fakes/fake_library_repository.dart';
import '../../../fixtures/abs_library_fixtures.dart';
import '../../../helpers/pump_app.dart';

void main() {
  group('LibraryViewModel', () {
    late FakeLibraryRepository repo;
    late LibraryViewModel vm;

    setUp(() {
      repo = FakeLibraryRepository(
        libraries: const <LibrarySummary>[
          LibrarySummary(
            id: 'lib-main',
            name: 'Audiobooks',
            mediaType: 'book',
            icon: 'book',
            displayOrder: 0,
          ),
          LibrarySummary(
            id: 'lib-scifi',
            name: 'Sci-Fi',
            mediaType: 'book',
            icon: 'book',
            displayOrder: 1,
          ),
        ],
        books: const <BookSummary>[
          AbsLibraryFixtures.bookOne,
          AbsLibraryFixtures.bookTwo,
          AbsLibraryFixtures.bookThree,
        ],
      );
      vm = LibraryViewModel(
        libraryRepository: repo,
        session: testAuthenticatedSession,
        loadImageHeaders: () async => const <String, String>{},
      );
    });

    tearDown(() async {
      vm.dispose();
      await repo.dispose();
    });

    test('loads default library, sorts, filters, and runs search', () async {
      vm.start();
      await Future<void>.delayed(const Duration(milliseconds: 20));

      check(vm.selectedLibraryId).equals('lib-main');
      check(vm.visibleBooks.length).equals(3);

      vm.setFilterMode(BookFilterMode.inProgress);
      check(vm.visibleBooks.length).equals(1);
      check(vm.visibleBooks.single.id).equals('item-1');

      vm
        ..setFilterMode(BookFilterMode.all)
        ..setSortOrder(BookSortOrder.durationDesc);
      check(vm.visibleBooks.first.id).equals('item-1');

      await vm.updateSearchQuery('Clarke');
      check(vm.isSearching).isTrue;
      check(vm.visibleBooks.length).equals(1);
      check(vm.visibleBooks.single.title).equals('Piranesi');

      await vm.updateSearchQuery('');
      check(vm.isSearching).isFalse;
      check(vm.visibleBooks.length).equals(3);
    });

    test(
      'switches libraries and opens/closes series group drill-down',
      () async {
        vm.start();
        await Future<void>.delayed(const Duration(milliseconds: 20));

        vm.setBrowseMode(LibraryBrowseMode.series);
        check(vm.seriesGroups.length).equals(1);

        vm.openGroup(vm.seriesGroups.single.name, vm.seriesGroups.single.books);
        check(vm.selectedGroupTitle).equals('Cosmic Tales');
        check(vm.selectedGroupBooks?.length).equals(2);

        vm.closeGroup();
        check(vm.selectedGroupTitle).isNull;

        vm.selectLibrary('lib-scifi');
        await Future<void>.delayed(const Duration(milliseconds: 20));
        check(vm.selectedLibraryId).equals('lib-scifi');
        check(vm.visibleBooks).isEmpty;
      },
    );
  });
}
