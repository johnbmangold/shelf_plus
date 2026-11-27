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

## Android Internal Deployment

The `deploy_android_internal` job in [`.github/workflows/ci.yml`](.github/workflows/ci.yml) builds the signed `prod` `.aab` and uploads it to the Google Play Console `internal` testing track after `analyze_and_test` passes on pushes to `main` or via manual `workflow_dispatch`. It automatically sets `--build-number` from `github.run_number` so each run produces a monotonically increasing `versionCode`.

Configure the following GitHub Actions repository secrets before running the workflow:

| Secret | Description |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | Base64-encoded upload keystore (`.jks` / `.keystore`) |
| `ANDROID_KEYSTORE_PASSWORD` | Keystore password (`storePassword`) |
| `ANDROID_KEY_ALIAS` | Signing key alias (`keyAlias`) |
| `ANDROID_KEY_PASSWORD` | Signing key password (`keyPassword`) |
| `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` | Google Play Console service account JSON key contents |

To base64-encode your keystore on macOS:

```sh
base64 -i <keystore> | tr -d '\n' | pbcopy
```

> **Note:** Google Play requires the initial `.aab` upload for a brand-new app to be performed manually in Play Console. If your app is still in Draft state, trigger the workflow manually with `release_status: draft`.
