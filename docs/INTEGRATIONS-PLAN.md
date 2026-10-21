# Optional Jackett and Jellyfin integrations

**Status: partially implemented in current source; advanced work remains planned.**
Independent protected profiles, direct Jackett basic search/download and Jellyfin
read-only catalog screens now exist. Tests use local fixtures and mocked UI,
not real Jackett/Jellyfin end-to-end deployments. Check release notes for binary
availability; this does not change the historical v0.2.0 scope. See
[practical setup](INTEGRATIONS.md). Primary sources were reviewed on 2026-10-21;
actual supported service versions still need verification.

## Implemented versus unverified

| Area | Current source | Missing or unverified |
|---|---|---|
| Profiles | Independent protected storage and add/edit/remove UI | Native real-service onboarding not verified |
| Jackett | Root/Torznab URL, basic text search, bounded XML, same-origin file fetch and qB multipart/magnet handoff | No capabilities, advanced filters/indexer picker, pagination or foreign-origin allowlist; no real E2E proof |
| Handoff | Explicit target/options, identity checks and no mutation replay | Real private-tracker/network edge cases unverified |
| Jellyfin | User-token/UUID validation, first 100 user-scoped items and read-only details | No admin API-key mode, pagination, login wizard, images, player or library matching |
| Transport | Independent clients, default TLS, bounded responses/timeouts and restricted redirects | No integration-specific custom CA/client certificate/Basic-auth options |
| Server plugin | Ordinary qB search screens can select server plugins | Jackett plugin E2E still an assessment; no configuration/filesystem writes |
| LAN media | SMB remains the preferred future direct-file approach | SMB playback and local torrent engine absent |

The sections below retain the target architecture, including work not yet built.
The status table above and [setup guide](INTEGRATIONS.md) describe today's limits;
in particular capability discovery, external-origin allowlists and matching are
still proposals rather than implemented behavior.

## Roles and user flow

| Component | Responsibility | Explicitly outside its role |
|---|---|---|
| Jackett | Search the user's configured torrent indexers through Torznab | Media playback, downloading content on behalf of qBittorrent |
| qBittorrent | Add/manage torrents; optionally run its already configured server-side Jackett search plugin | Receive app-managed Jackett/Jellyfin credentials in the direct-client flow, or discover arbitrary NAS paths |
| Jellyfin | Browse an existing media library, indicate possible matches, negotiate playback | Act as a torrent indexer or prove that a torrent is already downloaded |
| SMB | Preferred direct LAN access to files on an existing read-only NAS share | Require installation of Jellyfin or another media server |

Proposed flow: **Search → inspect result → Download → confirm target server,
save path and category → submit once → show the qBittorrent job.** Selecting a
search result never automatically downloads it. Jellyfin's optional "In library"
badge and "Play" action are separate from "Download"; availability there must
not silently suppress a user-requested download.

## Stage 0: assess reuse of an existing server-side plugin

Before building a direct Jackett client, evaluate an earlier MVP through the
app's existing qBittorrent WebAPI search screens and endpoints. qBittorrent's
official wiki documents a Jackett search plugin with a server-side configuration
file containing its Jackett address and API key.
[Official Jackett plugin configuration](https://github.com/qbittorrent/search-plugins/wiki/How-to-configure-Jackett-plugin).

When the user has already installed and configured that plugin on their
qBittorrent server, the app may be able to select it, start a search and display
results without connecting directly to Jackett or storing another key. This is
an assessment, **not a currently verified end-to-end Jackett workflow**. Do not
install/configure the plugin on a user's server, edit its configuration, or
claim arbitrary filesystem access through WebAPI. Server-side setup remains
the user's responsibility and is separate from app-side integration profiles.

The server plugin's existing key is already under the user's server-side
configuration; it is not the direct app profile key described below. Keep both
modes visibly distinct. Plugin result download URLs may themselves contain
secrets: redact them, require an explicit target/download action, and separately
test magnet/file handoff, download-origin handling and deduplication. Do not
assume that displaying a search result proves its download route works safely.
Confirm exactly which URL/metadata reaches the chosen qBittorrent server before
enabling that handoff. Direct Torznab remains an optional advanced path if the
existing server-side flow is insufficient.

## Separate optional profiles and transport boundaries

For direct integration, add independent `JackettProfile` and `JellyfinProfile` records with explicit URL,
display name and service-specific authentication. Keep secrets in the protected
store, with independent disconnect/delete actions. Do not reuse qBittorrent
passwords, API keys, cookies, Basic auth or custom certificate settings implicitly.
Integrations are off until configured; no analytics, discovery broadcasts,
developer relay or background searching is added.

Use the existing strict TLS, timeout, cancellation and bounded-response design.
Each service owns its HTTP client and origin policy. Jackett URLs can contain
secrets in query/path components: redact the **whole sensitive URL**, including
exceptions, redirects, logs, clipboard and notification payloads. Never forward
the app-managed Jackett key to qBittorrent as a download URL, argument or header.
This direct-client rule does not reconfigure a user's existing server plugin.
Third-party
artwork and media hosts are also separate origins; do not forward Jellyfin auth
to them automatically.

## Jackett search and controlled handoff

Jackett documents Torznab routes under
`api/v2.0/indexers/{indexer}/results/torznab/api`, including `t=caps`, free-text
`t=search&q=...`, specialized movie/TV queries and category filters. It also
offers `t=indexers&configured=true` for configured indexers and capabilities.
Use capabilities to enable supported fields and selectable indexers rather
than assuming all trackers accept the same identifiers or pagination.
[Jackett API examples](https://github.com/Jackett/Jackett#jackett-torznab-query-syntax),
[Torznab specification](https://torznab.github.io/spec-1.3-draft/torznab/Specification-v1.3.html).

MVP search exposes text, configured indexer and supported categories; show title,
size, seed/leech counts, age and source where returned. Treat absent fields as
unknown. Parse XML with external entities/DTDs disabled and limits on bytes,
entries and nesting. Bound parallel queries, respect cancellation/rate limits,
and retain usable results alongside individual-indexer failures. Jackett's result
controller applies API-key/configured-indexer/query filters; a tracker requiring
configuration is not fixed by repeatedly retrying the app's credentials.
[Jackett ResultsController](https://github.com/Jackett/Jackett/blob/master/src/Jackett.Server/Controllers/ResultsController.cs).

Two handoff paths:

1. **Magnet:** validate the URI and normalize recognized infohash forms. Submit
   only the magnet, approved add options and selected target to qBittorrent.
2. **Torrent file:** fetch on the client through the configured Jackett origin,
   with a proposed 16 MiB cap and short total timeout. Validate torrent bencode,
   then send bytes using qBittorrent multipart upload. Never ask qBittorrent to
   fetch the authenticated Jackett link. Torznab results may expose a torrent
   enclosure or magnet; the transport must handle both.
   [Torznab torrent support](https://torznab.github.io/spec-1.3-draft/revisions/1.0-Torznab-Torrent-Support.html).

Default to same-origin downloads and a small redirect limit. If an indexer needs
another download origin, require an explicitly reviewed profile allowlist; even
an allowed foreign origin receives **no Jackett key/cookie/header**. Block
downgrades, embedded URL credentials and unknown redirect destinations. Tracker
passkeys inside an authorized torrent/magnet are a distinct concern: the user
must understand that the torrent metadata itself is sent to their qBittorrent
server. Never log those bytes or tracker URLs.

Deduplicate by normalized infohash against the selected server and in-flight
submissions, not title text. Parse supported v1 hexadecimal/base32 magnets;
design v2/hybrid matching explicitly rather than treating every hash as v1.
For files, compute from the exact encoded `info` bytes using the appropriate
torrent version. If identity cannot be established, show that uncertainty.
Disable duplicate taps; never automatically replay an add after an ambiguous
network timeout. Offer a read-only server check before the user retries.

## Jellyfin catalog and playback

Use user-scoped authentication and library access, preferably a normal user
session rather than an administrator key. Jellyfin documents password and Quick
Connect flows yielding access tokens. Store only what the chosen session needs;
revocation/expiry should show reconnect UI without retry storms.
[Official SDK authentication guide](https://github.com/jellyfin/jellyfin-sdk-kotlin/blob/master/docs/guide/authentication.md).

MVP library integration is read-only: browse/search visible items, show details,
and allow the user to confirm a match. The server's Items controller supports
search and user-access filtering; do not fetch an administrator's full library
and filter locally. [ItemsController](https://github.com/jellyfin/jellyfin/blob/master/Jellyfin.Api/Controllers/ItemsController.cs).

Match media using supplied provider IDs, media type, year and episode identifiers
where available. A renamed torrent, release-group label, season pack or different
edition does not reliably identify a Jellyfin item. Keep confidence and provenance
visible; ambiguous matches require user selection. An API item ID belongs to its
Jellyfin server and is not a torrent hash. Jellyfin's naming/metadata guidance
describes provider identifiers; it does not establish a torrent-to-library join.
[Jellyfin media identification](https://jellyfin.org/docs/general/server/media/movies/).

Playback is a later opt-in stage. Ask the server for playback information and
provide an accurate device capability profile. Prefer Direct Play; only allow
transcoding after an explicit user preference/confirmation and subject to server
policy. Direct Stream/remux and transcoding are distinct outcomes, with different
bandwidth/CPU costs. Show the selected mode and handle unsupported codecs,
subtitles, revoked access and seek failures honestly.
[PlaybackInfo controller](https://github.com/jellyfin/jellyfin/blob/master/Jellyfin.Api/Controllers/MediaInfoController.cs),
[Jellyfin codec/playback guidance](https://jellyfin.org/docs/general/clients/codec-support/).

Keep [SMB LAN playback](ROADMAP.md#planned-lan-playback-prefer-an-existing-smb-share)
the preferred direct-file route when a share already exists. Jellyfin is an
optional existing library/playback service, not a mandatory replacement. Never
guess a NAS path from a torrent name or assume identical filesystem roots across
qBittorrent, SMB and Jellyfin. Explicit mappings need canonicalization, traversal
protection and user confirmation. No automatic rename, move, rescan or library
management writes are included in this proposal.

## Delivery tickets and acceptance gates

| Ticket/stage | Scope | Acceptance gate |
|---|---|---|
| INT-00: plugin assessment | Reuse an already configured server-side Jackett plugin through existing qB search UI/API | Authorized test proves plugin selection/search and separately validates download handoff, redaction, explicit target and dedup; no plugin/config/filesystem changes |
| INT-01: profiles | Optional protected credentials, independent clients/origins, disabled-state UI | Disconnect/delete removes only that service; secrets absent from errors/logs; base qB client works with both off |
| INT-02: search MVP | Jackett capabilities, configured indexers, bounded Torznab parser, text/category search | Fake-server tests cover missing fields, malformed/oversized XML, cancellation, timeout, partial failures and unsupported filters |
| INT-03: download MVP | Magnet/file handoff, target/path/category confirmation, infohash dedup | Exactly one add per confirmed click; binary multipart preserved; duplicate taps blocked; no Jackett secret reaches qB server; no mutation replay |
| INT-04: security gate | Redirect/auth isolation and redaction | Same/foreign-origin tests, downgrade denial, invalid TLS, malicious URLs and redirect loops; private-tracker metadata not logged |
| INT-05: library MVP | Jellyfin login, read-only browse, provider-ID/manual matching | User-access boundaries respected; ambiguous/renamed/duplicate editions stay unresolved until confirmed; disconnect/revocation tested |
| INT-06: playback prototype | Optional Jellyfin Direct Play, explicit transcode choice, SMB coexistence | Test codecs/subtitles/seeks, server policy denial, cleanup and OS lifecycle on actual target platforms; no claim from mocks alone |
| INT-07: release gate | Documentation, eight locales and accessibility | en/ru/uk/he/ar/de/fr/es complete, ICU/plural tests and Hebrew/Arabic RTL layouts; platform results and limits recorded |

INT-00 remains an unverified alternative through an existing server plugin.
Direct profiles/basic handoff and the read-only part of INT-05 now exist; the
advanced capability/filter, library-matching and real-service acceptance gates
remain open. INT-06 playback is not part of the current implementation.
All network tests use local fake services and invented data. Real-server tests
need explicit authorization and must not publish keys, search histories, media
titles, library paths or personal endpoints. Maintainers review added dependency
licenses and platform requirements before selecting XML, SMB or player packages.

No implementation dates or finished integration are promised by this plan.
