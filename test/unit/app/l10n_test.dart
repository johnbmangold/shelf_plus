import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_plus/l10n/generated/app_localizations.dart';

void main() {
  group('AppLocalizations', () {
    test('supports all expected locales', () {
      const expectedCodes = <String>[
        'ar',
        'de',
        'en',
        'es',
        'fr',
        'hi',
        'hu',
        'ja',
        'ko',
        'pt',
        'zh',
      ];

      final actualCodes =
          AppLocalizations.supportedLocales
              .map((locale) => locale.languageCode)
              .toList()
            ..sort();

      check(actualCodes).deepEquals(expectedCodes);
    });

    test('resolves non-empty localized strings for every supported locale', () {
      for (final locale in AppLocalizations.supportedLocales) {
        final l10n = lookupAppLocalizations(locale);

        check(l10n.appTitle).equals('Shelf Plus');
        check(l10n.navHome).isNotEmpty;
        check(l10n.libraryBookCount(1)).isNotEmpty;
        check(l10n.libraryBookCount(5)).isNotEmpty;
        check(l10n.bookTimeLeft('1h')).contains('1h');
        check(l10n.syncConflictBannerSubtitle(2)).contains('2');
      }
    });
  });
}
