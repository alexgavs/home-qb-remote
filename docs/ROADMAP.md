# Roadmap: optional local torrent engine

Optional Jackett search/download and read-only Jellyfin library browsing are
implemented in the current source: [setup](INTEGRATIONS.md) and
[remaining integration stages](INTEGRATIONS-PLAN.md). Playback and SMB access
remain future work; an existing read-only SMB share is the preferred planned
direct LAN file route.

The shipped architecture is **remote mode**: qBittorrent runs elsewhere, and this
app controls it through WebUI API. No built-in torrent engine is implemented.
An embedded engine is a separate potential feature, not a requirement to use
the client or a capability advertised by current release artifacts.

## Possible architecture

An optional engine could wrap [libtorrent](https://www.libtorrent.org/), expose a
small C-compatible bridge and call it through [Dart FFI](https://dart.dev/interop/c-interop).
Keep local-engine storage/session management separate from remote WebUI profiles
and place both behind a shared UI-facing interface. libtorrent's C++ API cannot
simply be passed directly to Dart FFI; native lifetime, thread, event and error
boundaries need an explicit bridge.

Prioritize Android, Windows and macOS prototypes, then evaluate iOS separately.
The prototype must establish dependency licensing/notices, supported ABIs,
16 KiB Android alignment, signing/notarization, sandboxed file access and
resource limits before integration. Downloads, disk access and listening ports
would expand runtime permissions and security responsibilities substantially.

## Platform questions to resolve first

- Android: foreground-service/user-visible notification policy, scoped storage,
  battery restrictions and lifecycle recovery.
- Windows/macOS: writable destinations, file locks, firewall/listening-port
  behavior, sleep/wake persistence and signed distribution.
- iOS: [BackgroundTasks](https://developer.apple.com/documentation/backgroundtasks)
  scheduling is OS-controlled; it does not promise an indefinitely running
  BitTorrent engine. Storage, network entitlements and distribution policy need
  separate review. Do not promise Android-like background seeding on iOS.

A proposal should include a small local-only prototype, reproducible native
builds, functional tests and a privacy review. Do not auto-start a local engine
when a user connects a remote profile, and do not add trackers/telemetry or
external registration services as part of this work.

## Planned LAN playback: prefer an existing SMB share

A separate possible player feature would keep qBittorrent API for torrent/file
metadata and read media directly from a user-configured **read-only SMB 2/3 NAS
share**. Prefer an existing share over requiring an additional media server.
Neither SMB playback nor an integrated player is implemented in the current app.

The user would explicitly map a server path such as `/downloads` to a share such
as `\\NAS\Media`. Treat these as independent credentials and trust boundaries:
store SMB credentials in the OS protected store, reject traversal outside the
selected share, and never infer filesystem access from WebUI credentials.

The player should use offset/random reads and bounded buffering instead of
copying an entire file before playback. Files of 8 GiB or more should remain
playable with bounded memory and without a mandatory full-file cache. SMB2 READ
has explicit offset and length fields; see the
[Microsoft SMB2 READ specification](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-smb2/320f04f3-1b28-45cd-aaa1-9e5aed810dca).
Actual playback still needs codec, seeking, incomplete-file and platform tests.

HTTP Range could remain an alternative for users who already expose a suitable
authenticated HTTP endpoint. qBittorrent WebUI metadata alone does not provide
arbitrary media-file streaming. Do not add an external relay, automatically
publish a NAS share, or require another server when SMB already meets the need.
