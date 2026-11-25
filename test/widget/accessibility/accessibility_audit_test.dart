import 'package:checks/checks.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/app/flavor_config.dart';
import 'package:shelf_plus/core/database/app_database.dart';
import 'package:shelf_plus/core/network/abs_library_models.dart';
import 'package:shelf_plus/core/theme/app_theme.dart';
import 'package:shelf_plus/core/theme/shelf_theme_tokens.dart';
import 'package:shelf_plus/features/downloads/presentation/downloads_screen.dart';
import 'package:shelf_plus/features/home/presentation/home_screen.dart';
import 'package:shelf_plus/features/library/domain/library_models.dart';
import 'package:shelf_plus/features/library/presentation/library_screen.dart';
import 'package:shelf_plus/features/player/presentation/full_player_screen.dart';
import 'package:shelf_plus/features/player/presentation/mini_player_bar.dart';
import 'package:shelf_plus/features/settings/presentation/settings_screen.dart';
import 'package:shelf_plus/features/sync/domain/progress_conflict_resolver.dart';
import 'package:shelf_plus/l10n/generated/app_localizations.dart';

import '../../fakes/fake_library_repository.dart';
import '../../fixtures/abs_library_fixtures.dart';
import '../../helpers/pump_app.dart';

double _contrastRatio(Color foreground, Color background) {
  final l1 = foreground.computeLuminance();
  final l2 = background.computeLuminance();
  final lighter = l1 > l2 ? l1 : l2;
  final darker = l1 > l2 ? l2 : l1;
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  group('Accessibility, WCAG Contrast & 200% Text Scaling Audit', () {
    test(
      'Editorial Light, Dark, and AMOLED themes satisfy WCAG AA (>= 4.5)',
      () {
        final themes = <(String, ThemeData)>[
          ('light', AppTheme.light(useGoogleFonts: false)),
          ('dark', AppTheme.dark(useGoogleFonts: false)),
          ('amoled', AppTheme.amoled(useGoogleFonts: false)),
        ];

        for (final (name, theme) in themes) {
          final scheme = theme.colorScheme;
          final tokens = theme.extension<ShelfThemeTokens>()!;

          check(
            _contrastRatio(scheme.onSurface, scheme.surface),
            because: '$name onSurface/surface',
          ).isGreaterOrEqual(4.5);
          check(
            _contrastRatio(tokens.subtleMetaText, scheme.surface),
            because: '$name subtleMetaText/surface',
          ).isGreaterOrEqual(4.5);
          check(
            _contrastRatio(tokens.subtleMetaText, tokens.elevatedCardSurface),
            because: '$name subtleMetaText/elevatedCardSurface',
          ).isGreaterOrEqual(4.5);
          check(
            _contrastRatio(scheme.onPrimary, scheme.primary),
            because: '$name onPrimary/primary',
          ).isGreaterOrEqual(4.5);
          check(
            _contrastRatio(scheme.onErrorContainer, scheme.errorContainer),
            because: '$name onErrorContainer/errorContainer',
          ).isGreaterOrEqual(4.5);
          check(
            _contrastRatio(scheme.onSurface, tokens.miniPlayerSurface),
            because: '$name onSurface/miniPlayerSurface',
          ).isGreaterOrEqual(4.5);
        }
      },
    );

    testWidgets(
      'Player, Downloads, and Settings pass tap target and labeled semantics '
      'guidelines',
      (tester) async {
        final fakeRepo = FakeLibraryRepository(
          books: const <BookSummary>[AbsLibraryFixtures.bookOne],
        );
        final deps = createTestDependencies(libraryRepository: fakeRepo);
        addTearDown(() async {
          deps.dispose();
          await Future<void>.delayed(Duration.zero);
        });

        await deps.database.upsertLibraryItems(
          'test-server-1',
          <LibraryItemsCompanion>[
            LibraryItemsCompanion.insert(
              serverId: 'test-server-1',
              id: 'item-1',
              libraryId: 'lib-main',
              title: 'Project Hail Mary',
              authors: const Value<String>('Andy Weir'),
              durationSec: const Value<double>(58200),
            ),
          ],
        );
        await deps.downloadController.enqueueDownload(
          AbsLibraryFixtures.bookOne,
        );
        await tester.pump(const Duration(milliseconds: 120));
        await deps.database.upsertMediaProgressEntries(
          <MediaProgressEntriesCompanion>[
            ProgressConflictResolver.mergeToCompanion(
              serverId: 'test-server-1',
              remote: const AbsMediaProgressDto(
                libraryItemId: 'item-1',
                durationSec: 58200,
                currentTimeSec: 1800,
                progress: 1800 / 58200,
                isFinished: false,
                hideFromContinueListening: false,
                lastUpdateMs: 9000,
              ),
              local: const MediaProgressEntry(
                serverId: 'test-server-1',
                libraryItemId: 'item-1',
                durationSec: 58200,
                localPositionSec: 900,
                serverPositionSec: 100,
                lastSyncedPositionSec: 100,
                progress: 900 / 58200,
                isFinished: false,
                hideFromContinueListening: false,
                localUpdatedAtMs: 8000,
                serverUpdatedAtMs: 7000,
                syncState: 'pendingPush',
              ),
            ),
          ],
        );
        await tester.pumpUntilComplete(
          deps.playerController.playBook(
            AbsLibraryFixtures.bookOne,
            chapters: const <ChapterInfo>[
              ChapterInfo(
                index: 0,
                title: 'Chapter 1: Solitude',
                startSec: 0,
                endSec: 1800,
              ),
            ],
            startPositionSec: 600,
          ),
        );

        Future<void> auditWidget(Widget child) async {
          final handle = tester.ensureSemantics();
          await tester.pumpLocalizedWidget(child);
          await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
          await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
          handle.dispose();
        }

        await auditWidget(
          FullPlayerScreen(
            playerController: deps.playerController,
            themeController: deps.themeController,
            enableNetworkImages: false,
          ),
        );
        await auditWidget(
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
        );
        await auditWidget(
          DownloadsScreen(
            downloadController: deps.downloadController,
            syncController: deps.offlineSyncController,
            playerController: deps.playerController,
            libraryRepository: deps.libraryRepository,
            authController: deps.authController,
            loadImageHeaders: deps.credentialsStore.loadActiveRequestHeaders,
            onOpenPlayer: () {},
            enableNetworkImages: false,
          ),
        );
        await auditWidget(
          SettingsScreen(
            themeController: deps.themeController,
            flavorConfig: const FlavorConfig.dev(),
            authController: deps.authController,
            diagnosticsRoute: '/settings/diagnostics',
          ),
        );
      },
    );

    testWidgets(
      'Primary screens render at 200% text scaling on 390x844 across all '
      'themes without overflow',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(390, 844));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final fakeRepo = FakeLibraryRepository(
          libraries: const <LibrarySummary>[
            LibrarySummary(
              id: 'lib-main',
              name: 'Audiobooks',
              mediaType: 'book',
              icon: 'book',
              displayOrder: 0,
            ),
          ],
          books: const <BookSummary>[
            AbsLibraryFixtures.bookOne,
            AbsLibraryFixtures.bookTwo,
          ],
        );
        final deps = createTestDependencies(libraryRepository: fakeRepo);
        addTearDown(() async {
          deps.dispose();
          await Future<void>.delayed(Duration.zero);
        });

        await tester.pumpUntilComplete(
          deps.playerController.playBook(
            AbsLibraryFixtures.bookOne,
            chapters: const <ChapterInfo>[
              ChapterInfo(
                index: 0,
                title: 'Chapter 1: Solitude',
                startSec: 0,
                endSec: 1800,
              ),
            ],
            startPositionSec: 450,
          ),
        );

        final themes = <ThemeData>[
          AppTheme.light(useGoogleFonts: false),
          AppTheme.dark(useGoogleFonts: false),
          AppTheme.amoled(useGoogleFonts: false),
        ];

        final screens = <Widget>[
          HomeScreen(
            libraryRepository: deps.libraryRepository,
            authController: deps.authController,
            loadImageHeaders: deps.credentialsStore.loadActiveRequestHeaders,
            logger: deps.logger,
            bookDetailRouteBuilder: (id) => '/book/$id',
            enableNetworkImages: false,
            autoSync: false,
          ),
          LibraryScreen(
            libraryRepository: deps.libraryRepository,
            authController: deps.authController,
            loadImageHeaders: deps.credentialsStore.loadActiveRequestHeaders,
            bookDetailRouteBuilder: (id) => '/book/$id',
            enableNetworkImages: false,
          ),
          DownloadsScreen(
            downloadController: deps.downloadController,
            syncController: deps.offlineSyncController,
            playerController: deps.playerController,
            libraryRepository: deps.libraryRepository,
            authController: deps.authController,
            loadImageHeaders: deps.credentialsStore.loadActiveRequestHeaders,
            onOpenPlayer: () {},
            enableNetworkImages: false,
          ),
          SettingsScreen(
            themeController: deps.themeController,
            flavorConfig: const FlavorConfig.dev(),
            authController: deps.authController,
            diagnosticsRoute: '/settings/diagnostics',
          ),
          FullPlayerScreen(
            playerController: deps.playerController,
            themeController: deps.themeController,
            enableNetworkImages: false,
          ),
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
        ];

        for (final theme in themes) {
          for (final screen in screens) {
            await tester.pumpWidget(
              MediaQuery(
                data: const MediaQueryData(
                  size: Size(390, 844),
                  textScaler: TextScaler.linear(2),
                ),
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: theme,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  home: screen,
                ),
              ),
            );
            await tester.pumpAndSettle();
          }
        }
      },
    );
  });
}
