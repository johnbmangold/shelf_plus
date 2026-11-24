import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_plus/core/database/app_database.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/network/abs_api_client.dart';
import 'package:shelf_plus/core/network/abs_library_models.dart';
import 'package:shelf_plus/core/network/auth_tokens.dart';
import 'package:shelf_plus/core/socket/abs_socket_events.dart';
import 'package:shelf_plus/features/auth/domain/server_session.dart';
import 'package:shelf_plus/features/library/data/library_repository_impl.dart';
import 'package:shelf_plus/features/library/domain/library_models.dart';

import '../../../fakes/mock_abs_server.dart';
import '../../../fixtures/abs_library_fixtures.dart';

void main() {
  group('LibraryRepositoryImpl', () {
    late AppDatabase db;
    late MockAbsServer server;
    late LibraryRepositoryImpl repo;
    late ServerSession session;

    setUp(() async {
      db = AppDatabase.inMemory();
      server = await MockAbsServer.start(basePathPrefix: '/abs');
      session = ServerSession(
        serverId: 's1',
        baseUrl: server.baseUrl,
        displayName: 'Mock ABS',
        userId: 'abs-user-1',
        username: 'reader',
        supportsRefreshTokens: true,
      );
      final client = AbsApiClient.create(
        loadBaseUrl: () async => server.baseUrl,
        loadTokens: () async => AuthTokens(
          accessToken: server.currentAccessToken,
          refreshToken: server.currentRefreshToken,
        ),
        saveTokens: (_) async {},
        loadCustomHeaders: () async => const <String, String>{},
        onSessionExpired: () async {},
        logger: AppLogger(forwardToDeveloperLog: false),
      );
      repo = LibraryRepositoryImpl(
        apiClient: client,
        database: db,
        logger: AppLogger(forwardToDeveloperLog: false),
      );
    });

    tearDown(() async {
      await db.close();
      await server.close();
    });

    test('syncAll caches book libraries, items, progress, bookmarks, and '
        'collections, and syncBookDetail caches chapters', () async {
      await repo.syncAll(session);

      final libs = await repo.watchLibraries(session.serverId).first;
      // Podcasts library filtered out in v1.
      check(libs.length).equals(2);

      final books = await repo.watchBooks(session.serverId).first;
      check(books.length).equals(2);
      final hailMary = books.firstWhere((b) => b.id == 'item-1');
      check(hailMary.progress?.positionSec).equals(14200);

      final collections = await repo
          .watchCollections(session.serverId, 'lib-main')
          .first;
      check(collections.length).equals(1);
      check(collections.single.books.length).equals(2);

      await repo.syncBookDetail(session, 'item-1');
      final detail = await repo
          .watchBookDetail(session.serverId, 'item-1')
          .first;
      check(detail).isNotNull();
      check(detail!.chapters.length).equals(2);
      check(detail.bookmarks.length).equals(1);
    });

    test(
      'handleSocketEvent updates progress and removes deleted items',
      () async {
        await repo.syncAll(session);

        await repo.handleSocketEvent(
          session.serverId,
          const UserProgressUpdatedEvent(
            AbsMediaProgressDto(
              libraryItemId: 'item-2',
              durationSec: 25200,
              currentTimeSec: 3600,
              progress: 0.14,
              isFinished: false,
              hideFromContinueListening: false,
              lastUpdateMs: 1719000000000,
            ),
          ),
        );

        final booksAfterProgress = await repo
            .watchBooks(session.serverId)
            .first;
        final piranesi = booksAfterProgress.firstWhere((b) => b.id == 'item-2');
        check(piranesi.progress?.positionSec).equals(3600);

        await repo.handleSocketEvent(
          session.serverId,
          const LibraryItemRemovedEvent('item-2'),
        );
        final booksAfterDelete = await repo.watchBooks(session.serverId).first;
        check(booksAfterDelete.any((b) => b.id == 'item-2')).isFalse;
      },
    );

    test('LibraryCatalogHelpers groups series in sequence order and formats '
        'durations', () {
      final groups = LibraryCatalogHelpers.groupBySeries(const <BookSummary>[
        AbsLibraryFixtures.bookOne,
        AbsLibraryFixtures.bookTwo,
        AbsLibraryFixtures.bookThree,
      ]);
      check(groups.length).equals(1);
      check(groups.single.name).equals('Cosmic Tales');
      check(groups.single.books.map((b) => b.title).toList())
          .deepEquals(<String>['The Martian', 'Project Hail Mary']);

      check(DurationFormatter.formatShort(15120)).equals('4h 12m');
      check(DurationFormatter.formatTimestamp(5045)).equals('01:24:05');
    });
  });
}
