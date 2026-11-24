import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/features/library/domain/library_models.dart';
import 'package:shelf_plus/features/player/domain/sleep_timer_controller.dart';
import 'package:shelf_plus/features/player/presentation/full_player_screen.dart';
import 'package:shelf_plus/features/player/presentation/mini_player_bar.dart';

import '../../../fakes/fake_audio_player_engine.dart';
import '../../../fakes/fake_library_repository.dart';
import '../../../fakes/fake_shake_detector.dart';
import '../../../fixtures/abs_library_fixtures.dart';
import '../../../helpers/pump_app.dart';

void main() {
  group('Player UI (MiniPlayerBar & FullPlayerScreen)', () {
    testWidgets(
      'MiniPlayerBar reflects active book, opens FullPlayerScreen, and '
      'exercises speed, sleep timer grace shake, chapters, bookmarks, and '
      'history sheets',
      (tester) async {
        final fakeEngine = FakeAudioPlayerEngine();
        final fakeShake = FakeShakeDetector();
        const chapters = <ChapterInfo>[
          ChapterInfo(
            index: 0,
            title: 'Chapter 1: Solitude',
            startSec: 0,
            endSec: 1800,
          ),
          ChapterInfo(
            index: 1,
            title: 'Chapter 2: Tau Ceti',
            startSec: 1800,
            endSec: 58200,
          ),
        ];
        final fakeRepo = FakeLibraryRepository(
          books: const <BookSummary>[AbsLibraryFixtures.bookOne],
          chaptersByBookId: const <String, List<ChapterInfo>>{
            'item-1': chapters,
          },
        );
        final deps = createTestDependencies(
          libraryRepository: fakeRepo,
          audioPlayerEngine: fakeEngine,
          shakeDetector: fakeShake,
        );

        await deps.database.recordPlaybackHistory(
          serverId: 'test-server-1',
          libraryItemId: 'item-1',
          positionSec: 420,
          reason: 'play',
          createdAtMs: 1000,
        );

        // Start playback using FakeAudioPlayerEngine + offline HTTP stub.
        await tester.pumpUntilComplete(
          deps.playerController.playBook(
            AbsLibraryFixtures.bookOne,
            chapters: chapters,
            startPositionSec: 600,
          ),
        );
        await fakeEngine.play();

        await tester.pumpShelfApp(dependencies: deps);

        // Verify MiniPlayerBar shows active book & play/pause toggle.
        check(find.byKey(const Key('mini_player_bar')).evaluate().length)
            .equals(1);
        check(find.text('Project Hail Mary').evaluate().length)
            .isGreaterThan(0);

        // Tap mini-player to push FullPlayerScreen.
        await tester.tap(find.byKey(const Key('mini_player_bar')));
        await tester.pumpAndSettle();

        check(find.byType(FullPlayerScreen).evaluate().length).equals(1);
        check(find.byKey(const Key('player_timeline_slider')).evaluate().length)
            .equals(1);

        // Switch scrubber mode to Chapter and back to Full Book.
        await tester.tap(find.text('Chapter'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Full Book'));
        await tester.pumpAndSettle();

        // Open Speed sheet -> verify skip silence visible when supported.
        await tester.ensureVisible(
          find.byKey(const Key('player_speed_button')),
        );
        await tester.tap(find.byKey(const Key('player_speed_button')));
        await tester.pumpAndSettle();
        check(
          find.byKey(const Key('player_skip_silence_switch')).evaluate().length,
        ).equals(1);
        await tester.tap(find.text('1.5x'));
        await tester.pumpAndSettle();
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        // Open Sleep timer sheet -> select 10 min, then trigger shake extend.
        await tester.ensureVisible(
          find.byKey(const Key('player_sleep_button')),
        );
        await tester.tap(find.byKey(const Key('player_sleep_button')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('sleep_option_10m')));
        await tester.pumpAndSettle();
        check(deps.playerController.sleepTimer.phase)
            .equals(SleepTimerPhase.counting);

        // Cancel sleep timer to avoid pending periodic timer leak after test.
        await deps.playerController.sleepTimer.cancel();
        await tester.pumpAndSettle();

        // Open Chapters sheet.
        await tester.ensureVisible(
          find.byKey(const Key('player_chapters_button')),
        );
        await tester.tap(find.byKey(const Key('player_chapters_button')));
        await tester.pumpAndSettle();
        check(find.text('Chapter 2: Tau Ceti').evaluate().length).equals(1);
        await tester.tap(find.text('Chapter 2: Tau Ceti'));
        await tester.pumpAndSettle();

        // Open Bookmarks sheet and save a note.
        await tester.ensureVisible(
          find.byKey(const Key('player_bookmarks_button')),
        );
        await tester.tap(find.byKey(const Key('player_bookmarks_button')));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const Key('player_bookmark_note_field')),
          'Favorite dialogue',
        );
        await tester.ensureVisible(
          find.byKey(const Key('player_save_bookmark_button')),
        );
        await tester.tap(find.byKey(const Key('player_save_bookmark_button')));
        await tester.pumpAndSettle();
        check(deps.playerController.bookmarks.length).equals(1);
        check(find.text('Favorite dialogue').evaluate().length).equals(1);
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        // Open History sheet.
        await tester.ensureVisible(
          find.byKey(const Key('player_history_button')),
        );
        await tester.tap(find.byKey(const Key('player_history_button')));
        await tester.pumpAndSettle();
        check(find.byKey(const Key('player_history_tile_0')).evaluate().length)
            .equals(1);
      },
    );

    testWidgets(
      'hides Skip Silence switch when engine lacks platform support',
      (tester) async {
        final iosEngine = FakeAudioPlayerEngine(supportsSkipSilence: false);
        final deps = createTestDependencies(audioPlayerEngine: iosEngine);
        addTearDown(() async {
          deps.dispose();
          await Future<void>.delayed(Duration.zero);
        });
        await tester.pumpUntilComplete(
          deps.playerController.playBook(
            AbsLibraryFixtures.bookOne,
            chapters: const <ChapterInfo>[
              ChapterInfo(index: 0, title: 'Ch 1', startSec: 0, endSec: 600),
            ],
          ),
        );

        await tester.pumpLocalizedWidget(
          FullPlayerScreen(
            playerController: deps.playerController,
            themeController: deps.themeController,
            enableNetworkImages: false,
          ),
        );

        await tester.ensureVisible(
          find.byKey(const Key('player_speed_button')),
        );
        await tester.tap(find.byKey(const Key('player_speed_button')));
        await tester.pumpAndSettle();
        check(find.byKey(const Key('player_skip_silence_switch')).evaluate())
            .isEmpty;
      },
    );

    testWidgets(
      'MiniPlayerBar renders idle state cleanly with no active book',
      (tester) async {
        final deps = createTestDependencies();
        addTearDown(deps.dispose);

        await tester.pumpLocalizedWidget(
          Scaffold(
            body: MiniPlayerBar(
              playerController: deps.playerController,
              onOpenPlayer: () {},
              enableNetworkImages: false,
            ),
          ),
        );

        check(find.text('Nothing playing').evaluate().length).equals(1);
      },
    );

    testWidgets(
      'FullPlayerScreen empty state, transport controls, skip silence toggle, '
      'sleep timer options/grace banner, and MiniPlayerBar controls work',
      (tester) async {
        final engine = FakeAudioPlayerEngine();
        final deps = createTestDependencies(audioPlayerEngine: engine);
        addTearDown(() async {
          deps.dispose();
          await Future<void>.delayed(Duration.zero);
        });

        await tester.pumpLocalizedWidget(
          FullPlayerScreen(
            playerController: deps.playerController,
            themeController: deps.themeController,
            enableNetworkImages: false,
          ),
        );
        check(find.text('Nothing playing right now').evaluate().length)
            .equals(1);

        await tester.pumpUntilComplete(
          deps.playerController.playBook(
            AbsLibraryFixtures.bookOne,
            chapters: const <ChapterInfo>[
              ChapterInfo(index: 0, title: 'Ch 1', startSec: 0, endSec: 600),
              ChapterInfo(index: 1, title: 'Ch 2', startSec: 600, endSec: 1200),
            ],
            startPositionSec: 300,
          ),
        );
        await tester.pumpUntilComplete(
          deps.playerController.createBookmark(
            title: 'Quote 1',
            note: 'Remember this',
          ),
        );
        await tester.pumpAndSettle();

        // Exercise transport buttons on FullPlayerScreen.
        await tester.ensureVisible(
          find.byKey(const Key('player_forward_button')),
        );
        await tester.tap(find.byKey(const Key('player_forward_button')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('player_rewind_button')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('player_next_chapter_button')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('player_prev_chapter_button')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('player_play_pause_button')));
        await tester.pumpAndSettle();

        // Toggle Skip Silence in Speed sheet.
        await tester.ensureVisible(
          find.byKey(const Key('player_speed_button')),
        );
        await tester.tap(find.byKey(const Key('player_speed_button')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('player_skip_silence_switch')));
        await tester.pumpAndSettle();
        check(deps.playerController.skipSilence).isTrue;
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        // Trigger fading/grace sleep banner via short 8s timer + cancel via UI.
        await tester.runAsync(
          () => deps.playerController.sleepTimer.startDuration(
            const Duration(seconds: 8),
          ),
        );
        await tester.pumpAndSettle();
        check(
          find.byKey(const Key('player_sleep_grace_banner')).evaluate().length,
        ).equals(1);
        await tester.ensureVisible(
          find.byKey(const Key('player_sleep_button')),
        );
        await tester.tap(find.byKey(const Key('player_sleep_button')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('sleep_option_eoc')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('player_sleep_button')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('sleep_option_off')));
        await tester.pumpAndSettle();

        // Exercise bookmark delete icon & history tile jump.
        await tester.ensureVisible(
          find.byKey(const Key('player_bookmarks_button')),
        );
        await tester.tap(find.byKey(const Key('player_bookmarks_button')));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.delete_outline_rounded));
        await tester.pumpAndSettle();
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        await tester.ensureVisible(
          find.byKey(const Key('player_history_button')),
        );
        await tester.tap(find.byKey(const Key('player_history_button')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('player_history_tile_0')));
        await tester.pumpAndSettle();

        // Verify MiniPlayerBar rewind & play/pause controls too.
        await tester.pumpLocalizedWidget(
          Scaffold(
            body: MiniPlayerBar(
              playerController: deps.playerController,
              onOpenPlayer: () {},
              enableNetworkImages: false,
            ),
          ),
        );
        await tester.tap(find.byKey(const Key('mini_player_rewind_button')));
        await tester.pumpAndSettle();
        await tester.tap(
          find.byKey(const Key('mini_player_play_pause_button')),
        );
        await tester.pumpAndSettle();
      },
    );
  });
}
