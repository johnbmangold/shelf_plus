import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/socket/abs_socket_events.dart';
import 'package:shelf_plus/core/socket/abs_socket_service.dart';

void main() {
  group('AbsSocketEventParser', () {
    test('buildEndpoint preserves subpath prefixes', () {
      final root = AbsSocketEventParser.buildEndpoint(
        'https://books.example.com/',
      );
      check(root.origin).equals('https://books.example.com');
      check(root.path).equals('/socket.io');

      final subpath = AbsSocketEventParser.buildEndpoint(
        'https://books.example.com:8443/audiobookshelf/',
      );
      check(subpath.origin).equals('https://books.example.com:8443');
      check(subpath.path).equals('/audiobookshelf/socket.io');
    });

    test('suppresses self-originated user_item_progress_updated events', () {
      final packet = <String, Object?>{
        'sessionId': 'self-session-1',
        'data': <String, Object?>{
          'libraryItemId': 'item-1',
          'episodeId': null,
          'duration': 1000.0,
          'currentTime': 250.0,
          'progress': 0.25,
          'isFinished': false,
          'hideFromContinueListening': false,
          'lastUpdate': 1718000000000,
        },
      };

      final suppressed = AbsSocketEventParser.parse(
        'user_item_progress_updated',
        packet,
        selfSessionIds: const <String>{'self-session-1'},
      );
      check(suppressed).isNull;

      final remote = AbsSocketEventParser.parse(
        'user_item_progress_updated',
        packet,
        selfSessionIds: const <String>{'other-session'},
      );
      check(remote).isA<UserProgressUpdatedEvent>();
      check((remote! as UserProgressUpdatedEvent).progress.currentTimeSec)
          .equals(250);
    });

    test('parses library item add, update, and remove events', () {
      final itemJson = <String, Object?>{
        'id': 'item-9',
        'libraryId': 'lib-main',
        'mediaType': 'book',
        'media': <String, Object?>{
          'metadata': <String, Object?>{'title': 'Dune'},
        },
      };

      final added = AbsSocketEventParser.parse('library_item_added', itemJson);
      check(added).isA<LibraryItemAddedEvent>();

      final updated = AbsSocketEventParser.parse(
        'library_item_updated',
        itemJson,
      );
      check(updated).isA<LibraryItemUpdatedEvent>();

      final removed = AbsSocketEventParser.parse(
        'library_item_removed',
        const <String, Object?>{'id': 'item-9'},
      );
      check(removed).isA<LibraryItemRemovedEvent>();
      check((removed! as LibraryItemRemovedEvent).itemId).equals('item-9');
    });

    test(
      'SocketIoAbsService tracks self session IDs and disconnects cleanly',
      () async {
        final service =
            SocketIoAbsService(logger: AppLogger(forwardToDeveloperLog: false))
              ..registerSelfSessionId('s-1')
              ..unregisterSelfSessionId('s-1');

        check(service.isConnected).isFalse;
        await service.disconnect();
        service.dispose();
      },
    );
  });
}
