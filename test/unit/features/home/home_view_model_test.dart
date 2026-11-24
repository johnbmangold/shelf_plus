import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/features/home/presentation/home_view_model.dart';
import 'package:shelf_plus/features/library/domain/library_models.dart';

import '../../../fakes/fake_library_repository.dart';
import '../../../fixtures/abs_library_fixtures.dart';
import '../../../helpers/pump_app.dart';

void main() {
  group('HomeViewModel', () {
    test('orders hero, in-progress, and recently added shelves', () async {
      final repo = FakeLibraryRepository(
        books: const <BookSummary>[
          AbsLibraryFixtures.bookOne,
          AbsLibraryFixtures.bookTwo,
          AbsLibraryFixtures.bookThree,
        ],
      );
      final vm = HomeViewModel(
        libraryRepository: repo,
        session: testAuthenticatedSession,
        loadImageHeaders: () async => const <String, String>{},
        logger: AppLogger(forwardToDeveloperLog: false),
      );
      addTearDown(() async {
        vm.dispose();
        await repo.dispose();
      });

      vm.start();
      await Future<void>.delayed(const Duration(milliseconds: 30));

      check(repo.syncAllCalls).equals(1);
      check(vm.hasSyncError).isFalse;
      check(vm.heroContinueBook?.id).equals('item-1');
      check(vm.recentlyAddedBooks.first.id).equals('item-1');
      check(vm.coverUrlFor(AbsLibraryFixtures.bookThree)).isNull;
      check(vm.coverUrlFor(AbsLibraryFixtures.bookOne)).isNotNull();
    });

    test(
      'sets hasSyncError when refresh throws while preserving cache',
      () async {
        final repo = FakeLibraryRepository(
          books: const <BookSummary>[AbsLibraryFixtures.bookOne],
        )..syncError = Exception('network down');
        final vm = HomeViewModel(
          libraryRepository: repo,
          session: testAuthenticatedSession,
          loadImageHeaders: () async => const <String, String>{},
          logger: AppLogger(forwardToDeveloperLog: false),
        );
        addTearDown(() async {
          vm.dispose();
          await repo.dispose();
        });

        vm.start(autoSync: false);
        await Future<void>.delayed(const Duration(milliseconds: 20));
        await vm.refresh();

        check(vm.hasSyncError).isTrue;
        check(vm.isSyncing).isFalse;
        check(vm.isEmpty).isFalse;
      },
    );
  });
}
