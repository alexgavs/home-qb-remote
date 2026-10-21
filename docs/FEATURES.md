# Feature and platform matrix

This is an implementation map, not a claim that every server/OS combination has
been exercised. A successful CI compile is distinct from native runtime testing.

| Capability | Implementation and limits |
|---|---|
| Remote server profiles | Multiple servers, cookie login including modern 204/`QBT_SID_*`, optional Bearer API key, independent HTTP Basic auth |
| TLS | System roots, optional custom CA/client PEM material; Android PKCS#12 import; no trust-all switch |
| Torrent management | Lists, filters, bulk actions, add links/files with options, start/stop, delete with explicit file-deletion choice |
| Details | Properties, files/priorities, trackers, peers and server-supported operations |
| Organization | Categories, tags, queues and speed controls |
| RSS/search | Server-managed feeds/rules, search plugins/jobs/results; availability depends on server configuration |
| Direct Jackett (current source) | Optional protected profile, basic Torznab text search, same-origin bounded torrent fetch, explicit qB target/options, magnet/multipart handoff and identity checks; no capabilities/filter picker or pagination |
| Jellyfin (current source) | Optional user-token/UUID profile, first 100 user-scoped video results and read-only details; no pagination, player, images or automatic torrent/library matching |
| Web seeds | View/manage HTTP sources where supported; editing requires compatible qBittorrent 5.2+ APIs |
| Preferences/logs | WebUI API settings and logs; server permissions/version affect available operations |
| Lock/privacy | OS authentication, full-route overlay and Android screenshot protection; explicit local reset recovery |
| Notifications | Direct server polling, per-profile completion snapshots, configurable interval; no first-baseline alert |
| Language | Eight locales, system/app selection, Hebrew/Arabic RTL; Android 13+ per-app system selection |
| Local routing | Optional configured SSID/local URL with permission-aware fallback; no coordinates read |
| Wake-on-LAN | User-configured UDP magic packet; router/OS/Apple entitlements can limit delivery |
| Built-in torrent engine | **Not implemented**; see [ROADMAP.md](ROADMAP.md) |

## Platform-specific behavior

The new integrations have local HTTP-fixture and mocked UI coverage; no real
Jackett/Jellyfin end-to-end runtime is claimed. Check release notes before
assuming a binary includes the current source changes. They use separate default
TLS clients without custom CA/client-certificate/Basic-auth options. See
[integration setup](INTEGRATIONS.md) and [remaining plan](INTEGRATIONS-PLAN.md).

| Platform | Packaging and native features |
|---|---|
| Android | Universal APK/AAB, OS file import/export, protected store and authentication, scheduled polling subject to OS restrictions |
| Windows | Portable complete runtime ZIP, system save dialog and protected store; foreground notifications, no mobile periodic background worker |
| macOS | App bundle, save dialog/keychain; foreground notifications, no mobile periodic background worker; signing affects capabilities |
| iOS | Share-sheet export and scoped document import, keychain/authentication, OS-controlled background polling; signed provisioning needed for devices |

Public build automation validates Android debug, Windows, macOS and iOS Simulator
targets. Distribution artifacts are listed only when their workflow succeeds.
Unsigned macOS and simulator-only iOS artifacts must retain those labels. No
ready-to-install iOS device distribution is implied by the source tree or CI.

Android runtime and real-server authentication have been exercised during
development; those checks do not establish every listed feature or OEM behavior.
Release notes should identify the exact tested version/platform and remaining
gaps without exposing personal server details. See [BUILDING.md](BUILDING.md)
and [RELEASING.md](RELEASING.md).
