# Build from a fresh clone

Requirements reviewed on **2026-10-21**. The reproducible CI baseline is Flutter
**3.47.7 stable**, Dart **3.13.5**. The official Flutter stable branch resolved
to `abaf9c523780a608bd46686fd5e53740a07077f8` when checked. Versions change;
follow [MAINTENANCE.md](MAINTENANCE.md) rather than assuming this page stays current
without review. See the [official release](https://github.com/flutter/flutter/tree/3.47.7)
and [Flutter installation guide](https://docs.flutter.dev/install).

## Common setup

```sh
git clone https://github.com/alexgavs/home-qb-remote.git
cd home-qb-remote
flutter --version
flutter doctor -v
flutter pub get --enforce-lockfile
flutter gen-l10n
flutter analyze
flutter test
flutter devices
flutter run -d DEVICE_ID
```

Install the matching SDK with your preferred manager or Flutter's official
archive. Keep `pubspec.lock`; do not solve release dependencies from scratch.
Generation requires `l10n.yaml` and `lib/l10n/*.arb`. Never add local SDK paths or
credentials to Git. Tests use local HTTP fixtures and plugin mocks, not a real
server; native platform behavior requires its own device/build verification.

## Platform tools and outputs

| Target | Required host/tooling | Build command/output |
|---|---|---|
| Android | Supported Windows/Linux/macOS, Android SDK and accepted licenses, JDK 17 | `flutter build apk --release`: `build/app/outputs/flutter-apk/app-release.apk` |
| Play submission | Same Android tools and release signing | `flutter build appbundle --release`: `build/app/outputs/bundle/release/app-release.aab` |
| Windows x64 | Windows, Visual Studio with Desktop development with C++, Windows SDK | `flutter build windows --release`: package the complete `build/windows/x64/runner/Release/` directory |
| macOS | Mac, current Xcode and command-line tools, plugin dependency tools requested by Flutter doctor | `flutter build macos --release`: `build/macos/Build/Products/Release/*.app` |
| iOS Simulator | Mac and Xcode, downloaded iOS Simulator runtime | `flutter build ios --simulator --debug`: `build/ios/iphonesimulator/*.app` |
| iPhone/iPad | Mac, Xcode, Apple signing identity and provisioning profile | Configure Runner signing in Xcode, then `flutter build ipa --release` |

Android compile/target/minimum SDK values follow the checked-in Gradle files and
Flutter defaults. Install the SDK/NDK versions requested by the build rather
than lowering them to bypass a plugin requirement. CI debug builds require no
private key; distribution signing is described in [RELEASING.md](RELEASING.md).

CI uses `macos-26` and rejects Xcode older than 26. Its currently documented
default is Xcode 26.6; runner images can change. The CI Xcode check verifies the
actual selected version. A simulator build is **not** an installable iOS device
package. A macOS unsigned archive is not notarized and may be blocked by
Gatekeeper. Compilation alone does not verify keychain entitlements, Wi-Fi
permissions, OS authentication, notification delivery or background scheduling.

## Current upstream setup references

- [Android setup](https://docs.flutter.dev/platform-integration/android/setup)
- [Windows tooling](https://docs.flutter.dev/platform-integration/windows/setup)
- [macOS tooling](https://docs.flutter.dev/platform-integration/macos/setup)
- [iOS tooling and signing](https://docs.flutter.dev/platform-integration/ios/setup)
- [GitHub macOS 26 runner inventory](https://github.com/actions/runner-images/blob/main/images/macos/macos-26-arm64-Readme.md)

The Windows secure store and macOS/iOS keychain can depend on OS account and
signing configuration. Use a disposable development profile and fake torrent
data when checking imports, deletion and notifications.
