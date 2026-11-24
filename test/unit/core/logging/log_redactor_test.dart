import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_plus/core/logging/log_redactor.dart';

void main() {
  group('LogRedactor', () {
    test('returns empty string unchanged', () {
      check(LogRedactor.redact('')).equals('');
    });

    test('leaves non-sensitive text untouched', () {
      const text = 'Synced 42 audiobooks in 120ms for library main';
      check(LogRedactor.redact(text)).equals(text);
    });

    test('redacts Bearer tokens case-insensitively', () {
      const input = 'Authorization: bearer eyJhbGciOiJIUzI1NiJ9.abc.def';
      final output = LogRedactor.redact(input);
      check(output.contains('eyJhbGciOiJIUzI1NiJ9')).isFalse;
      check(output).contains('bearer $redactedPlaceholder');
    });

    test('redacts JSON credential fields', () {
      const json =
          '{"username":"reader","password":"my-secret-password",'
          '"accessToken":"tok_123","refresh_token":"ref_456"}';
      final output = LogRedactor.redact(json);
      check(output).contains('"username":"reader"');
      check(output.contains('my-secret-password')).isFalse;
      check(output.contains('tok_123')).isFalse;
      check(output.contains('ref_456')).isFalse;
      check(output).contains('"password":"$redactedPlaceholder"');
      check(output).contains('"accessToken":"$redactedPlaceholder"');
      check(output).contains('"refresh_token":"$redactedPlaceholder"');
    });

    test('redacts header and query key-value secrets', () {
      const input =
          'x-refresh-token: r_secret_99\n'
          'CF-Access-Client-Secret: cf_secret_88\n'
          'GET /ping?token=url_tok_77';
      final output = LogRedactor.redact(input);
      check(output.contains('r_secret_99')).isFalse;
      check(output.contains('cf_secret_88')).isFalse;
      check(output.contains('url_tok_77')).isFalse;
      check(output).contains('x-refresh-token: $redactedPlaceholder');
      check(output).contains('CF-Access-Client-Secret: $redactedPlaceholder');
      check(output).contains('token=$redactedPlaceholder');
    });

    test('redactMap recursively redacts nested maps and string values', () {
      final redacted = LogRedactor.redactMap(<String, Object?>{
        'server': 'https://books.example.com',
        'Authorization': 'Bearer secret-jwt',
        'headers': <String, Object?>{
          'CF-Access-Client-Secret': 'cf-123',
          'X-Custom': 'ok',
        },
        'nestedString': 'password=hunter2',
        'count': 5,
      });

      check(redacted['server']).equals('https://books.example.com');
      check(redacted['Authorization']).equals(redactedPlaceholder);
      check(redacted['nestedString']).equals('password=$redactedPlaceholder');
      check(redacted['count']).equals(5);
      final headers = redacted['headers']! as Map<String, Object?>;
      check(headers['CF-Access-Client-Secret']).equals(redactedPlaceholder);
      check(headers['X-Custom']).equals('ok');
    });
  });
}
