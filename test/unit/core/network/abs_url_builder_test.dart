import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_plus/core/network/abs_url_builder.dart';

void main() {
  group('AbsUrlBuilder', () {
    test('normalizes valid http/https URLs and strips trailing slashes', () {
      check(AbsUrlBuilder.normalizeBaseUrl('  https://books.example.com///  '))
          .equals('https://books.example.com');

      check(
        AbsUrlBuilder.normalizeBaseUrl(
          'HTTP://localhost:13378/audiobookshelf/?foo=bar#frag',
        ),
      ).equals('http://localhost:13378/audiobookshelf');
    });

    test('throws FormatException for invalid or non-http URLs', () {
      check(() => AbsUrlBuilder.normalizeBaseUrl('')).throws<FormatException>();
      check(() => AbsUrlBuilder.normalizeBaseUrl('books.example.com'))
          .throws<FormatException>();
      check(() => AbsUrlBuilder.normalizeBaseUrl('ftp://books.example.com'))
          .throws<FormatException>();
    });

    test('resolves endpoints while preserving subpath prefixes', () {
      check(
        AbsUrlBuilder.resolve('https://example.com/audiobookshelf/', '/login'),
      ).equals('https://example.com/audiobookshelf/login');

      check(
        AbsUrlBuilder.resolve(
          'http://127.0.0.1:8080/media/abs',
          'api/authorize',
        ),
      ).equals('http://127.0.0.1:8080/media/abs/api/authorize');
    });

    test('displayHost formats host with optional port', () {
      check(AbsUrlBuilder.displayHost('https://books.example.com/abs'))
          .equals('books.example.com');
      check(AbsUrlBuilder.displayHost('http://127.0.0.1:13378/abs'))
          .equals('127.0.0.1:13378');
    });
  });
}
