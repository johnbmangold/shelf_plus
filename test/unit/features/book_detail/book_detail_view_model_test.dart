import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/features/book_detail/presentation/book_detail_view_model.dart';
import 'package:shelf_plus/features/library/domain/library_models.dart';

import '../../../fakes/fake_cover_theme_extractor.dart';
import '../../../fakes/fake_library_repository.dart';
import '../../../fixtures/abs_library_fixtures.dart';
import '../../../helpers/pump_app.dart';

void main() {
  group('BookDetailViewModel', () {
    test('loads detail, triggers expanded sync when chapters empty, and '
        're-extracts theme on brightness change', () async {
      final repo = FakeLibraryRepository(
        books: const <BookSummary>[AbsLibraryFixtures.bookOne],
      );
      final extractor = FakeCoverThemeExtractor(
        seedColor: const Color(0xFF1F6F8B),
      );
      final vm = BookDetailViewModel(
        libraryRepository: repo,
        coverThemeExtractor: extractor,
        session: testAuthenticatedSession,
        itemId: 'item-1',
        loadImageHeaders: () async => const <String, String>{'X-Test': '1'},
        logger: AppLogger(forwardToDeveloperLog: false),
      );
      addTearDown(() async {
        vm.dispose();
        await repo.dispose();
      });

      vm.start(brightness: Brightness.light);
      await Future<void>.delayed(const Duration(milliseconds: 30));

      check(vm.hasLoadedInitial).isTrue;
      check(vm.detail?.book.id).equals('item-1');
      check(repo.syncBookDetailCalls).equals(1);
      check(vm.dynamicScheme?.brightness).equals(Brightness.light);
      check(vm.imageHeaders).deepEquals(const <String, String>{'X-Test': '1'});

      vm.updateBrightness(Brightness.dark);
      await Future<void>.delayed(const Duration(milliseconds: 30));
      check(vm.dynamicScheme?.brightness).equals(Brightness.dark);
    });

    test('handles syncBookDetail failure gracefully and returns null coverUrl '
        'when hasCover is false', () async {
      final repo = FakeLibraryRepository(
        books: const <BookSummary>[AbsLibraryFixtures.bookThree],
      )..syncError = Exception('offline');
      final vm = BookDetailViewModel(
        libraryRepository: repo,
        coverThemeExtractor: FakeCoverThemeExtractor(),
        session: testAuthenticatedSession,
        itemId: 'item-3',
        loadImageHeaders: () async => const <String, String>{},
        logger: AppLogger(forwardToDeveloperLog: false),
      );
      addTearDown(() async {
        vm.dispose();
        await repo.dispose();
      });

      vm.start(brightness: Brightness.light, autoFetchDetail: false);
      await Future<void>.delayed(const Duration(milliseconds: 20));
      check(vm.coverUrl).isNull;

      await vm.refreshDetail();
      check(vm.isLoadingDetail).isFalse;
    });
  });
}
