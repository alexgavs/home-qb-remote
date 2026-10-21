# Privacy and security boundaries

Home qB Remote is a remote control client, not a torrent engine. It communicates
with server URLs explicitly saved in profiles; qBittorrent performs torrent
downloads, RSS retrieval and plugin searches. Optional direct Jackett search
and Jellyfin catalog profiles contact those separately configured servers.
Wake-on-LAN sends a UDP packet to
the address the user supplies. The app includes no advertising SDK, analytics
SDK, developer account service, remote configuration or developer notification
relay. This statement describes the application; servers, search providers,
operating systems and installed plugins have their own behavior.

## Credentials and transport

Passwords, API keys and optional certificate material use the OS protected store.
Android backup is disabled; iOS secrets use device-only keychain accessibility
after first unlock. Desktop secure-store guarantees depend on the OS account
and keychain setup. Uninstalling/resetting the app can remove local profiles.
Explicit local recovery deletes protected data; authentication failure does not
automatically erase it or unlock retained credentials.

TLS certificate verification stays enabled. For qBittorrent, custom CA/client certificates
change the trust configuration chosen by the user, not a global trust-all mode.
HTTP is supported for trusted local setups but is unencrypted. Prefer HTTPS or
a trusted VPN. Cross-origin redirects are rejected to avoid forwarding passwords,
API keys or cookies to another origin. A final authentication rejection blocks
automatic retry until an explicit profile action; operation permission failures
are distinguished from a bad API key without replaying mutations.

Direct Jackett/Jellyfin profiles have independent credentials and default TLS
trust; they do not inherit qBittorrent CA/client-certificate or Basic-auth
settings. No integration-specific custom certificate option exists yet. Jackett
searches include its key in Jackett API URLs; proxy/server logs can therefore
contain it. The app fetches same-origin torrent files with a size limit and sends
bytes to qBittorrent instead of forwarding the Jackett download URL/key. Jellyfin
uses a user-owned token in its own authorization header and verifies the user
before requesting the first 100 visible video items. It does not download media,
play/transcode, or automatically match a torrent to the library.

These opt-in requests disclose search terms/library access to the selected
services, without an added developer relay or background search. Service profiles
and their secrets use a separate protected document. Removing one locally does
not revoke its remote credentials. Existing server-side Jackett plugins are a
different mode, with their configuration retained on the qBittorrent server.
See [setup and current limits](INTEGRATIONS.md). Real-service E2E verification is
not claimed from loopback tests.

Protect the server separately: use authentication, CSRF/Host validation, firewall
rules and TLS as appropriate. A successful request from a subnet with server-side
authentication bypass does not prove the password was checked.

## Optional OS permissions

- **Notifications:** opt-in completion alerts. With the app lock enabled, names
  and torrent payloads are omitted and Android visibility is private. The first
  poll establishes a silent baseline. Background scheduling is controlled by the
  OS; force-stop and battery restrictions can prevent delivery. No push relay is used.
- **Device authentication:** OS PIN/biometric authentication hides all routes and
  dialogs. Android uses `FLAG_SECURE` while the lock is enabled. This does not
  defend against a compromised OS or an already unlocked account.
- **Wi-Fi/local routing:** reads the Wi-Fi name only for configured local routing.
  Permission requests occur through explicit user actions, not background polling.
  No location coordinates are requested by the application. An SSID is not proof
  of network identity; follow the app's transport restrictions for local URLs.
  Unsupported/denied Wi-Fi access falls back to the primary configured URL.
- **Files/local network:** system pickers/import providers and local-network
  access support torrent import/export and server connectivity. External imports
  require confirmation and validation before they are sent to qBittorrent.

Apple Wi-Fi information may require an appropriately provisioned entitlement.
iOS broadcast Wake-on-LAN can require Apple's restricted multicast entitlement;
local-network permission alone does not supply it. macOS unsigned builds may
have keychain/capability limitations. CI compilation is not device validation.

## Reports and diagnostics

Use fictional profiles and local fixtures for public issues. Redact server URLs,
cookies, passwords, API keys, certificates/private keys, personal torrent names,
paths and screenshots. GitHub Actions downloads build tools and dependencies;
that development activity is separate from the runtime app's network behavior.
See [SECURITY.md](../SECURITY.md) for private vulnerability reporting.
