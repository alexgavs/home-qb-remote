# Optional Jackett and Jellyfin setup

This guide describes the integration screens in the current source. Check the
release notes for availability in a downloaded binary. Protocol tests use local
fake servers; an end-to-end deployment with real Jackett/Jellyfin services has
not been verified. Both integrations are optional and independent of normal
qBittorrent operation.

Open **Integrations** from the navigation menu. Add a named Jackett or Jellyfin
profile, then open its card. Edit/remove actions affect only that integration
profile, not the remote service. Secrets use a separate OS-protected document;
a failed storage read prevents overwriting it with an empty profile list.

## Direct Jackett search

1. Configure Jackett and your indexers yourself, then obtain its API key. The app
   does not configure trackers or manage their credentials.
2. In **Add Jackett**, enter a name, URL and key. The URL must not contain
   credentials, query parameters or a fragment. Put the key in the secret field,
   not a copied `?apikey=...` URL.
3. Accepted forms include `https://jackett.example.test`, a reverse-proxy root
   such as `https://media.example.test/jackett`, or a Torznab endpoint such as
   `https://jackett.example.test/api/v2.0/indexers/INDEXER/results/torznab/api`.
   Roots use Jackett's `all` endpoint; a supplied indexer endpoint narrows it.
   A path ending in `/torznab` also works and gains `/api`.
4. Open the profile, enter text and explicitly search. Current support is basic
   Torznab text search. Capability discovery, indexer/category picker, advanced
   movie/TV parameters and pagination are absent. XML is limited to 4 MiB and
   1,000 entries; these are safety limits, not page-navigation controls.
5. Select the qBittorrent server in the main app before downloading. Use the
   result's Download action and review target, save path, category and options
   in the add dialog. Save paths are on the **qBittorrent server**, not the phone,
   SMB share or Jellyfin library.

Magnets go to the selected qBittorrent server. Torrent files are fetched by the
app from Jackett's configured origin, validated and uploaded as binary multipart;
the authenticated Jackett download URL is not passed to qBittorrent. Files are
capped at 16 MiB. Redirects and foreign-origin download URLs are rejected; no
foreign-origin allowlist exists yet. Results needing such routes may fail.

The flow checks infohash identity against the target, blocks repeated taps and
does not replay an add after an ambiguous timeout. Check the server if the result
is unknown. Changing targets during confirmation/fetch cancels the old handoff.
Private tracker passkeys inside torrent metadata still go to your chosen
qBittorrent server; the separate Jackett API key must not travel there.

## Existing qBittorrent Jackett plugin

This is a separate mode: use ordinary qBittorrent **Search** with an already
configured server-side plugin. That plugin owns its existing Jackett settings;
a direct app-side Jackett profile is neither required nor automatically linked.
The app does not edit `jackett.json` or obtain filesystem access through WebAPI.
[Official plugin setup](https://github.com/qbittorrent/search-plugins/wiki/How-to-configure-Jackett-plugin).

This particular plugin/search/download chain has not been verified end-to-end
here. Result URLs may contain secrets in either mode; never paste them into
public logs. See the [assessment and plan](INTEGRATIONS-PLAN.md).

## Jellyfin library, read-only

1. Prepare a **user-owned access token** and the UUID of that same Jellyfin user
   from your authorized session/setup. There is no password-login or Quick
   Connect wizard here. Do not use a server-wide administrator API key:
   `/Users/Me` requires a user-owned token.
   [User endpoint](https://github.com/jellyfin/jellyfin/blob/master/Jellyfin.Api/Controllers/UserController.cs),
   [official authentication guide](https://github.com/jellyfin/jellyfin-sdk-kotlin/blob/master/docs/guide/authentication.md).
2. In **Add Jellyfin**, enter a name, root/reverse-proxy URL, token and User ID.
   UUIDs can have 32 hexadecimal digits or the standard hyphenated format.
   URLs must not contain credentials, query parameters or fragments.
3. Opening the profile verifies `/Users/Me` and compares its UUID with the
   configured user before requesting the user-scoped catalog. Another user's
   token is rejected even if it grants broader access.
4. Browse or submit text in the search field. Jellyfin performs the search;
   only the **first 100** matching video-library items are requested, with no
   next-page control. Narrow the query when needed. Open an item for its title,
   year and overview. Overview is plain text, not interpreted HTML.

No playback, transcoding, download action, image fetching, provider-ID matching,
"already downloaded" badge or library-management writes are provided. Jellyfin
is a catalog, not a torrent indexer. Renamed torrents/editions cannot be reliably
matched from titles. SMB playback and a local torrent engine remain future work.

## Network and privacy limits

These clients directly contact the separately configured Jackett/Jellyfin servers.
qBittorrent plugin search and RSS still run through qBittorrent. No developer
relay, analytics, background searches or cross-service credential reuse is added.
Profile cards show names rather than potentially sensitive connection URLs.

Both clients retain default TLS verification. Integration profiles have **no
custom CA, client-certificate or HTTP Basic-auth settings** yet; qBittorrent's
certificate settings are not inherited. A self-signed service may fail unless
the platform already trusts its certificate. Do not disable TLS verification.

HTTP is supported for an explicitly trusted LAN/VPN but exposes requests, searches
and credentials to that network. Prefer HTTPS. Jackett uses its key in its own
request URLs, so review reverse-proxy/server logging. Jellyfin uses an authorization
header, not a token URL. Cross-origin redirects are blocked; Jellyfin permits only
restricted same-endpoint slash normalization while preserving user scope.

Deleting a local profile does not revoke the remote token; revoke compromised
keys/sessions on the service itself. Public reports must omit addresses, tokens,
private tracker URLs, torrent/media names and library paths. See
[PRIVACY.md](PRIVACY.md) and [SECURITY.md](../SECURITY.md).
