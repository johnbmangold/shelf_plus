import 'package:checks/checks.dart';
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_plus/core/database/app_database.dart';

void main() {
  group('AppDatabase ServerProfiles', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase.inMemory();
    });

    tearDown(() async {
      await db.close();
    });

    test(
      'saves active server, switches active flag, and clears cleanly',
      () async {
        check(await db.getActiveServer()).isNull;

        await db.saveActiveServer(
          ServerProfilesCompanion.insert(
            id: 's1',
            baseUrl: 'https://one.example.com',
            displayName: 'one.example.com',
            serverVersion: const Value('2.26.0'),
            userId: 'u1',
            username: 'alice',
            supportsRefreshTokens: const Value(true),
            lastConnectedAt: DateTime.utc(2026),
          ),
        );

        final first = await db.getActiveServer();
        check(first).isNotNull();
        check(first!.id).equals('s1');
        check(first.isActive).isTrue;

        await db.saveActiveServer(
          ServerProfilesCompanion.insert(
            id: 's2',
            baseUrl: 'https://two.example.com',
            displayName: 'two.example.com',
            userId: 'u2',
            username: 'bob',
            lastConnectedAt: DateTime.utc(2026, 2),
          ),
        );

        final second = await db.getActiveServer();
        check(second?.id).equals('s2');

        final foundFirst = await db.findServerByUrl('https://one.example.com');
        check(foundFirst?.isActive).equals(false);

        await db.clearActiveServer();
        check(await db.getActiveServer()).isNull;

        await db.deleteServer('s1');
        check(await db.findServerByUrl('https://one.example.com')).isNull;
      },
    );

    test('watchActiveServer emits updates', () async {
      final emitted = <String?>[];
      final sub = db.watchActiveServer().listen((s) => emitted.add(s?.id));
      addTearDown(sub.cancel);

      await db.saveActiveServer(
        ServerProfilesCompanion.insert(
          id: 's1',
          baseUrl: 'https://one.example.com',
          displayName: 'one.example.com',
          userId: 'u1',
          username: 'alice',
          lastConnectedAt: DateTime.utc(2026),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));
      await db.clearActiveServer();
      await Future<void>.delayed(const Duration(milliseconds: 20));

      check(emitted).contains('s1');
      check(emitted.last).isNull;
    });
  });
}
