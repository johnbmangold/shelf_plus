import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/theme/app_theme.dart';
import 'package:shelf_plus/core/theme/shelf_theme_tokens.dart';
import 'package:shelf_plus/core/widgets/book_cover_image.dart';
import 'package:shelf_plus/features/library/domain/library_models.dart';

import '../fixtures/abs_library_fixtures.dart';

void main() {
  testWidgets('Book cards golden across Light, Dark, and AMOLED', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(440, 680));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _BookCardsGoldenCanvas(),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(_BookCardsGoldenCanvas),
      matchesGoldenFile('goldens/book_cards.png'),
    );
  });
}

class _BookCardsGoldenCanvas extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF888888),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _BookSpecimenCard(
              theme: AppTheme.light(useGoogleFonts: false),
              book: AbsLibraryFixtures.bookOne,
            ),
            _BookSpecimenCard(
              theme: AppTheme.dark(useGoogleFonts: false),
              book: AbsLibraryFixtures.bookTwo,
            ),
            _BookSpecimenCard(
              theme: AppTheme.amoled(useGoogleFonts: false),
              book: AbsLibraryFixtures.bookThree,
            ),
          ],
        ),
      ),
    );
  }
}

class _BookSpecimenCard extends StatelessWidget {
  const new({required this.theme, required this.book});

  final ThemeData theme;
  final BookSummary book;

  @override
  Widget build(BuildContext context) {
    final tokens = theme.extension<ShelfThemeTokens>()!;
    return Theme(
      data: theme,
      child: Builder(
        builder: (themedContext) {
          final t = Theme.of(themedContext);
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: t.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: tokens.hairlineBorder),
            ),
            child: Row(
              children: <Widget>[
                BookCoverImage(
                  title: book.title,
                  size: 76,
                  enableNetworkImage: false,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        book.title,
                        style: t.textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        book.authorsDisplay,
                        style: t.textTheme.bodySmall?.copyWith(
                          color: tokens.subtleMetaText,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: book.completionRatio,
                          minHeight: 6,
                          backgroundColor: tokens.progressTrack,
                          color: tokens.progressFill,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DurationFormatter.formatShort(book.remainingSec),
                        style: AppTheme.tabularFigureStyle(
                          t.textTheme.labelSmall!.copyWith(
                            color: tokens.subtleMetaText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
