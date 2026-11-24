import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/theme/app_theme.dart';
import 'package:shelf_plus/features/library/domain/library_models.dart';
import 'package:shelf_plus/features/player/presentation/full_player_screen.dart';
import 'package:shelf_plus/features/player/presentation/mini_player_bar.dart';

import '../fakes/fake_audio_player_engine.dart';
import '../fixtures/abs_library_fixtures.dart';
import '../helpers/pump_app.dart';

void main() {
  group('Player Golden Tests', () {
    testWidgets('FullPlayerScreen and MiniPlayerBar editorial golden', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(412, 892);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final engine = FakeAudioPlayerEngine();
      final deps = createTestDependencies(audioPlayerEngine: engine);
      addTearDown(deps.dispose);

      await tester.runAsync(() async {
        await deps.playerController.playBook(
          AbsLibraryFixtures.bookOne,
          chapters: const <ChapterInfo>[
            ChapterInfo(
              index: 0,
              title: 'Chapter 1: First Awakening',
              startSec: 0,
              endSec: 1800,
            ),
          ],
          startPositionSec: 600,
        );
      });

      await tester.pumpLocalizedWidget(
        FullPlayerScreen(
          playerController: deps.playerController,
          themeController: deps.themeController,
          enableNetworkImages: false,
        ),
        theme: AppTheme.light(useGoogleFonts: false),
      );

      await expectLater(
        find.byType(FullPlayerScreen),
        matchesGoldenFile('goldens/full_player_light.png'),
      );

      await tester.pumpLocalizedWidget(
        Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: MiniPlayerBar(
              playerController: deps.playerController,
              onOpenPlayer: () {},
              enableNetworkImages: false,
            ),
          ),
        ),
        theme: AppTheme.dark(useGoogleFonts: false),
      );

      await expectLater(
        find.byType(MiniPlayerBar),
        matchesGoldenFile('goldens/mini_player_dark.png'),
      );
    });
  });
}
