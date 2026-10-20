# Home qB Remote

An open-source Flutter client for your qBittorrent server, licensed under MIT.
No ads, analytics, developer account, or developer-operated relay is required.

[Russian](docs/README.ru.md) | [Hebrew](docs/README.he.md) | [Ukrainian](docs/README.uk.md)

## Features

Manage multiple servers, torrents and files, trackers, peers, categories, tags,
RSS, search plugins, queues and speed limits. Add links or torrent files and export
.torrent files. Optional features include OS authentication, local completion
notifications, Wi-Fi-based local routing, and Wake-on-LAN. See the
[feature and platform matrix](docs/FEATURES.md).

The interface supports English, Russian, Hebrew, Ukrainian, German, French,
Spanish and Arabic, including right-to-left Hebrew and Arabic. Choose a language in
application settings or follow the system language. Android 13+ also exposes
supported languages in the system's per-app language settings.

## Download and run

Use assets listed on [GitHub Releases](https://github.com/alexgavs/home-qb-remote/releases).
Only consider a platform available when its release contains a built artifact.
Android APKs are installable; AABs are intended for store submission. Windows
portable ZIPs must be extracted completely. macOS archives are unsigned unless
explicitly labelled otherwise. An iOS Simulator archive cannot be installed on
an iPhone; device distribution requires Apple signing and provisioning.

## Build from source

Install Flutter **3.47.7** (Dart 3.13.5), then the tools for your platform:

```sh
git clone https://github.com/alexgavs/home-qb-remote.git
cd home-qb-remote
flutter doctor -v
flutter pub get --enforce-lockfile
flutter gen-l10n
flutter analyze
flutter test
flutter run
```

[Build requirements](docs/BUILDING.md), [release/signing instructions](docs/RELEASING.md),
and the [maintenance policy](docs/MAINTENANCE.md) explain platform-specific steps.
Weekly dependency PRs and latest-stable compatibility checks help keep requirements
current; updates still require review and passing checks.

## Privacy and security

Requests go to configured qBittorrent endpoints; search/RSS run on the server.
Profiles, passwords and API keys use the OS protected store. TLS verification
stays enabled, and cross-origin redirects are rejected. Use HTTPS or a trusted
VPN for remote access. Optional notifications and Wi-Fi permissions are explained
in the [privacy and security guide](docs/PRIVACY.md).

Report vulnerabilities privately using [SECURITY.md](SECURITY.md). Contributions
and translations are welcome: [CONTRIBUTING.md](CONTRIBUTING.md).
