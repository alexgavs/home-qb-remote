# Contributing

Start with [BUILDING.md](docs/BUILDING.md), reproduce the issue using a local
fixture, and keep changes focused. Discuss substantial changes in an issue first.
Do not submit credentials, private endpoints, signing keys or real torrent data.

Source is organized into `lib/core/` (models/API), `lib/services/` (platform
services), `lib/ui/` (screens), and `test/`. Platform adapters live under
`android/`, `ios/`, `macos/` and `windows/`. Follow existing Dart formatting and
naming: `dart format lib test`, lower_snake_case files, UpperCamelCase types.

Before opening a pull request run:

```sh
flutter pub get --enforce-lockfile
flutter gen-l10n
flutter analyze
flutter test
```

Add meaningful tests for changed behavior, especially authentication, mutations,
imports and privacy boundaries. Use local fake servers and platform mocks; tests
must not depend on a contributor's real qBittorrent instance. Native behavior
still needs an actual platform build/device check.

Use short commit subjects such as `fix: handle expired session` or
`feat: add language selector`. PRs should explain the user-visible change,
verification and limitations. Include redacted screenshots for UI changes and
link the issue when available. Never claim a platform passed without evidence.

For translations, edit the ARB source files under `lib/l10n/`, preserve
placeholders/metadata, and run `flutter gen-l10n`. Check Hebrew in RTL layouts and
narrow screens. Do not translate API identifiers or torrent/user-provided names.

Dependency and toolchain updates follow [MAINTENANCE.md](docs/MAINTENANCE.md).
Contributions are provided under the repository's MIT license; dependency
licenses remain with their respective owners.
