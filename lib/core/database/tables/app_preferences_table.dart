import 'package:drift/drift.dart';

/// Simple key-value storage for persistent device/app settings.
class AppPreferences extends Table {
  /// Preference key.
  TextColumn get key => text()();

  /// Preference string value.
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{key};
}
