import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_plus/app/flavor_config.dart';

void main() {
  group('FlavorConfig', () {
    test('dev preset configures dev bundle ID and verbose logging', () {
      const dev = FlavorConfig.dev();

      check(dev.flavor).equals(AppFlavor.dev);
      check(dev.appName).equals('Shelf Plus Dev');
      check(dev.applicationId).equals('com.shcworks.shelfplus.dev');
      check(dev.enableVerboseLogging).isTrue;
    });

    test('prod preset configures prod bundle ID and concise logging', () {
      const prod = FlavorConfig.prod();

      check(prod.flavor).equals(AppFlavor.prod);
      check(prod.appName).equals('Shelf Plus');
      check(prod.applicationId).equals('com.shcworks.shelfplus');
      check(prod.enableVerboseLogging).isFalse;
    });
  });
}
