import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/theme/app_theme.dart';
import 'package:shelf_plus/core/theme/shelf_theme_tokens.dart';

void main() {
  testWidgets('Theme gallery golden across Light, Dark, and AMOLED', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(440, 780));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _ThemeGalleryCanvas(),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(_ThemeGalleryCanvas),
      matchesGoldenFile('goldens/theme_gallery.png'),
    );
  });
}

class _ThemeGalleryCanvas extends StatelessWidget {
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
            _ThemeSpecimenCard(
              label: 'Editorial Light',
              theme: AppTheme.light(useGoogleFonts: false),
            ),
            _ThemeSpecimenCard(
              label: 'Editorial Dark',
              theme: AppTheme.dark(useGoogleFonts: false),
            ),
            _ThemeSpecimenCard(
              label: 'True-Black AMOLED',
              theme: AppTheme.amoled(useGoogleFonts: false),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeSpecimenCard extends StatelessWidget {
  const new({required this.label, required this.theme});

  final String label;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final tokens = theme.extension<ShelfThemeTokens>()!;
    return Theme(
      data: theme,
      child: Builder(
        builder: (themedContext) {
          final t = Theme.of(themedContext);
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: t.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: tokens.hairlineBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(label, style: t.textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(
                  'Piranesi • Susanna Clarke',
                  style: t.textTheme.bodyMedium?.copyWith(
                    color: tokens.subtleMetaText,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: tokens.miniPlayerSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: tokens.hairlineBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Chapter 4', style: t.textTheme.titleSmall),
                          Text(
                            '01:24:05',
                            style: AppTheme.tabularFigureStyle(
                              t.textTheme.labelMedium!,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: 0.62,
                          minHeight: 6,
                          backgroundColor: tokens.progressTrack,
                          color: tokens.progressFill,
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
