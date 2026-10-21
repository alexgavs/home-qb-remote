# Changelog

## 0.3.2 (unreleased)

- Show recently added torrents first in every status filter.
- Offer an explicit return to downloads after search submission, clearing local
  filters for that action and scrolling to the newest entries.
- Describe successful submission as a server acknowledgement rather than proof
  that metadata retrieval or downloading has completed.

## 0.3.1 (unreleased)

- Make server-side search plugins easier to discover from the search interface.
- Improve keyboard handling and result-list scrolling on small screens.

Validated on a physical Android 16 phone: filter reset, search navigation,
empty-plugin setup, Jackett results and scrolling with keyboard dismissal, and
protected-profile persistence after restart. No downloads were started.

## 0.3.0

- Add independent, protected Jackett and Jellyfin integration profiles.
- Search Jackett directly and explicitly confirm the target and add options
  before handing a magnet or validated torrent file to qBittorrent.
- Browse and search a user-scoped Jellyfin catalog with read-only item details.
  Playback and transcoding are not included.
- Keep integration credentials separate, restrict redirects and bound responses;
  detect duplicate torrent identities without automatically replaying mutations.

## 0.2.0

- First public, independently implemented Home qB Remote release.
- English, Russian, Ukrainian, Hebrew, Arabic, German, French and Spanish UI,
  with RTL layouts, in-app selection and Android 13+ system language settings.
- Localized completion notifications and device authentication prompts.
- Multi-server qBittorrent controls, file priorities, trackers, web seeds,
  RSS rules, search plugins, server preferences and torrent export.
- Protected credential storage, verified TLS, optional client certificates,
  API-key authentication and an application lock with private notifications.
- Cross-platform build workflows, dependency maintenance checks and contributor,
  privacy, build and release documentation.

The public Android identity is `io.github.alexgavs.homeqb` and uses a dedicated
release signing key. It installs alongside previous development prototypes;
profiles and credentials are not imported automatically.

Embedded torrent downloading and SMB media playback are future features, as
described in [the roadmap](docs/ROADMAP.md).
