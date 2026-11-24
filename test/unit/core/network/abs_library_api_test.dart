import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/network/abs_api_client.dart';
import 'package:shelf_plus/core/network/auth_tokens.dart';

import '../../../fakes/mock_abs_server.dart';

void main() {
  group('AbsApiClient library endpoints', () {
    late MockAbsServer server;
    late AbsApiClient client;

    setUp(() async {
      server = await MockAbsServer.start(
        basePathPrefix: '/audiobookshelf',
        requiredHeaders: const <String, String>{
          'CF-Access-Client-Id': 'proxy-id',
        },
      );
      client = AbsApiClient.create(
        loadBaseUrl: () async => server.baseUrl,
        loadTokens: () async => AuthTokens(
          accessToken: server.currentAccessToken,
          refreshToken: server.currentRefreshToken,
        ),
        saveTokens: (_) async {},
        loadCustomHeaders: () async => const <String, String>{
          'CF-Access-Client-Id': 'proxy-id',
        },
        onSessionExpired: () async {},
        logger: AppLogger(forwardToDeveloperLog: false),
      );
    });

    tearDown(() => server.close());

    test(
      'fetches libraries, items page, expanded item, me, and collections',
      () async {
        final libraries = await client.fetchLibraries(baseUrl: server.baseUrl);
        check(libraries.length).equals(3);
        check(libraries.first.id).equals('lib-main');

        final page = await client.fetchLibraryItems(
          baseUrl: server.baseUrl,
          libraryId: 'lib-main',
        );
        check(page.total).equals(2);
        check(page.items.length).equals(2);
        check(page.items.first.title).equals('Project Hail Mary');

        final expanded = await client.fetchItemExpanded(
          baseUrl: server.baseUrl,
          itemId: 'item-1',
        );
        check(expanded.chapters.length).equals(2);
        check(expanded.chapters.first.title).equals('Chapter 1: Awakening');

        final me = await client.fetchMe(baseUrl: server.baseUrl);
        check(me.mediaProgress.length).equals(1);
        check(me.bookmarks.length).equals(1);

        final collections = await client.fetchCollections(
          baseUrl: server.baseUrl,
          libraryId: 'lib-main',
        );
        check(collections.length).equals(1);
        check(collections.single.bookIds)
            .deepEquals(<String>['item-1', 'item-2']);
      },
    );

    test('buildCoverUrl preserves reverse-proxy subpath', () {
      check(
        AbsApiClient.buildCoverUrl(
          baseUrl: 'https://example.com/audiobookshelf/',
          itemId: 'item-1',
          width: 400,
        ),
      ).equals(
        'https://example.com/audiobookshelf/api/items/item-1/cover?width=400',
      );
    });
  });
}
