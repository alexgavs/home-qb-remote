# Dependency and platform maintenance

"Current requirements" means regularly checking supported upstream releases,
testing upgrades and updating this documentation together. It is not a promise
that untested major versions are automatically merged or that every platform
works immediately after an upstream release.

## Automated checks

- `ci.yml` validates the pinned Flutter SDK, analyzes/tests code and compiles
  Android debug, Windows, macOS and iOS Simulator targets.
- `maintenance.yml` runs weekly and manually against the latest stable Flutter
  with the committed dependency lockfile, reports `flutter pub outdated`, runs
  analysis/tests and compiles Android debug. It does not modify the repository.
- Dependabot opens weekly PRs for pub, Gradle and GitHub Actions. Actions are
  pinned by full commit SHA with version comments; Dependabot can update pins.
  No auto-merge or automatic major-version approval is configured.

Scheduled checks need GitHub Actions enabled on the default branch; inactive
public repositories can have schedules disabled by GitHub. Maintainers must
monitor failed runs and Dependabot PRs. These mechanisms do not guarantee an
immediate fix, and they do not run before the repository is published/enabled.

## Upgrade checklist

1. Check Flutter's official stable branch/release notes, plugin constraints,
   Android Gradle Plugin/Gradle/JDK compatibility and the current Xcode runner.
2. Create a focused branch. Update SDK pins, package constraints and lockfiles
   together. Read migration notes; inspect any new permissions or network SDKs.
3. Run generation, analyzer, tests and all affected native builds. Exercise
   cookie/API-key authentication, TLS, imports, notifications, lock and RTL UI.
4. Update `BUILDING.md`, the feature matrix and release notes with the date,
   actual tooling and remaining platform gaps. Review generated dependency
   licenses, signing requirements and release checksums.
5. Merge only after review. Publish artifacts only from the verified commit.

## Baseline and deliberate pins

Reviewed 2026-10-21: Flutter 3.47.7/Dart 3.13.5 matches the official stable branch.
`permission_handler` remains exactly 12.0.3: its newer 13.x Android dependency
requires SDK 37, which the present AGP/Flutter SDK metadata combination has not
validated. Do not remove this pin merely to silence `pub outdated`; upgrade the
toolchain and verify the permissions first. SDK-constrained transitive packages
also need coordinated Flutter updates.

Official references: [Flutter releases](https://github.com/flutter/flutter/releases),
[Flutter breaking changes](https://docs.flutter.dev/release/breaking-changes),
[Dependabot configuration](https://docs.github.com/en/code-security/dependabot/working-with-dependabot/dependabot-options-reference),
[Android Gradle Plugin compatibility](https://developer.android.com/build/releases/gradle-plugin),
[Xcode support](https://developer.apple.com/support/xcode/).
