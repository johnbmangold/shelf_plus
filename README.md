# Shelf Plus

A native-grade Flutter audiobook client for Android and iOS that connects to [Audiobookshelf](https://www.audiobookshelf.org/) servers.

## Flavors

| Flavor | App Name | Application / Bundle ID | Entrypoint |
|---|---|---|---|
| `dev` | Shelf Plus Dev | `com.shcworks.shelfplus.dev` | `lib/main_dev.dart` |
| `prod` | Shelf Plus | `com.shcworks.shelfplus` | `lib/main_prod.dart` |

## Common Commands

```sh
# Generate localizations
flutter gen-l10n

# Run dev flavor
flutter run --flavor dev -t lib/main_dev.dart

# Format, analyze, and run tests with coverage
dart format --output=none --set-exit-if-changed lib test
flutter analyze --fatal-infos --fatal-warnings
flutter test --coverage
```
