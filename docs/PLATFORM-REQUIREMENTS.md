# Platform requirements

Checked against official documentation on 2026-10-21.

## Application identity and existing installations

The public application uses `io.github.alexgavs.homeqb` on Android, iOS, and macOS. It is a separate application from the private prototype (`org.homeqb.home_qb_remote` on Android). Both Android apps can coexist: installing the public application does not update, uninstall, or erase the prototype and its saved profiles. Profiles are not migrated automatically; configure the public application explicitly. Public releases require their own stable signing key. Existing internal channel/background-task names remain stable and do not determine the application identity.

## Android

Use Flutter stable with JDK 17 and Android SDK 36. The current project uses Flutter SDK defaults for compile/target SDK, Android Gradle Plugin, and NDK. Google Play requires API 36 for new apps and updates from August 31, 2026: [official target API requirements](https://developer.android.com/google/play/requirements/target-sdk). Do not raise individual plugins to SDK 37 without upgrading and validating the complete toolchain. `permission_handler` is deliberately pinned in `pubspec.yaml`.

Android 13+ exposes English, Russian, Ukrainian, Hebrew, Arabic, German, French, and Spanish in the system app-language settings. Earlier Android versions persist the in-app choice in SharedPreferences and Flutter applies it to the UI, without attaching an AppCompat delegate to the Flutter activity. On upgrade to Android 13, a saved choice migrates once to LocaleManager unless a system app-language choice already exists. RTL is enabled. The Flutter channel `org.homeqb/locales` provides `getLocale` (String), `setLocale` with `{languageCode: String}`, and `onLocaleChanged` (String). Empty String follows the system; other supported values are `en`, `ru`, `uk`, `he`, `ar`, `de`, `fr`, `es`. Configuration changes and activity resume emit events; Dart must also call `getLocale` on startup. [Android language APIs](https://developer.android.com/guide/topics/resources/app-languages).

Release CI must supply `ANDROID_KEYSTORE_PATH`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, and `ANDROID_KEY_PASSWORD`. Missing signing variables fail release tasks when `CI` is set. Store the key and passwords outside Git and preserve the key for future updates. Local release builds without signing variables use the development debug key and are not distribution releases.

## Apple

App Store uploads require Xcode 26 or newer with iOS/iPadOS 26 SDK or newer since April 28, 2026: [Apple SDK requirements](https://developer.apple.com/news/upcoming-requirements/?id=04282026a). This SDK requirement does not require raising the minimum supported device OS to 26. Build and sign on macOS with the appropriate Apple provisioning profile. Native Apple changes require a real Xcode build before claiming compilation or App Store readiness.

Both Apple targets declare eight bundle languages and localized permission descriptions. Optional Wi-Fi address switching requires location permission and, on iOS, the access-wifi-info entitlement with a compatible provisioning team. No coordinate updates are requested. iOS broadcast Wake-on-LAN requires Apple's multicast entitlement approval; the project does not include that restricted entitlement. Background refresh is scheduled opportunistically by the OS.

## Windows

Install Visual Studio with Desktop development with C++, the Windows SDK, and Flutter's required CMake tooling. Enable symlink support for plugin builds. Windows and Apple binaries must be built and tested on their respective supported hosts.

### Windows standard coroutines

`local_auth_windows` 2.0.2 and `permission_handler_windows` 0.2.2 request C++20 but also add `/await`. Current MSVC rejects the resulting experimental coroutine path (STL1011). The project removes `/await` from those two targets only, requires C++20, and force-includes `<coroutine>` so their C++/WinRT versions select standard `std::coroutine` types. No compiler downgrade or deprecation suppression is used. See [Microsoft's /await documentation](https://learn.microsoft.com/en-us/cpp/build/reference/await-enable-coroutine-support) and the upstream [C++/WinRT 2022](https://github.com/microsoft/cppwinrt/blob/2.0.220418.1/strings/base_includes.h) / [2021](https://github.com/microsoft/cppwinrt/blob/2.0.210806.1/strings/base_includes.h) header conditions. A Windows CI build validates actual compilation; local source checks alone do not.
