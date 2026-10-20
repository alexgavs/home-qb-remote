# Repository Guidelines

## Project Structure

Home qB Remote is an independent Flutter application. `lib/core/` contains the qBittorrent Web API client and models; `lib/services/` provides protected storage, notifications and language settings. Screens live in `lib/ui/` and `lib/features/`. Translation catalogs and generated localization classes live in `lib/l10n/`. Native adapters are in `android/`, `ios/`, `macos/` and `windows/`; tests are in `test/`, and contributor documentation is in `docs/`.

## Build and Validation

Use the Flutter version pinned in CI. Run `flutter pub get`, `flutter gen-l10n`, `flutter analyze` and `flutter test` before submitting changes. Format Dart with `dart format lib test tool`. Build Android with `flutter build apk --release`; distribution builds require the signing environment documented in `docs/RELEASING.md`. Desktop and Apple builds require their respective native toolchains. Never describe an unsigned Apple artifact as an installable device release.

## Coding and Localization

Follow Dart formatting and the configured Flutter lints. Use `snake_case` filenames and descriptive class/member names. Keep API parameter names and internal filter identifiers stable. Use generated `AppLocalizations` messages for user-visible text, including dialogs, validation, error messages and accessibility labels. Preserve ICU placeholders and update every supported ARB catalog. Verify Hebrew/Arabic layout and mixed-direction server addresses. Do not translate torrent names, credentials, paths or server-supplied content.

## Tests and Pull Requests

Name tests `*_test.dart`. Exercise protocol behavior with loopback fixtures, especially authentication failures, cookie renewal, API-key handling and non-repeated mutations. Add meaningful localization, RTL and native-language synchronization checks when changing language behavior. Use focused commits such as `feat:`, `fix:`, `test:` and `docs:`. PRs should explain resulting behavior, validation and platform limitations; attach screenshots for visual changes.

## Privacy and Releases

Never commit credentials, signing keys, local connection settings, device captures or downloaded media. Preserve strict TLS and same-origin redirect checks. Advertising, telemetry and developer relays are outside the product scope. Keep dependency upgrades reviewable and tested; follow `docs/MAINTENANCE.md` for platform requirements and release checks.
