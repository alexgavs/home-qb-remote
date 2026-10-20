# Building and publishing releases

Only a maintainer publishes releases. Workflows here produce artifacts; they
do not create GitHub releases, upload to stores or grant Apple signing rights.
An unexecuted workflow is a build recipe, not evidence of a successful build.

The first public release is **v0.2.0**, application/bundle identity
`io.github.alexgavs.homeqb`. It uses a dedicated release key and installs
separately from earlier private development prototypes. There is no automatic
profile/credential migration from those prototypes; their existing installation
does not need to be removed. Internal method-channel names are implementation
details and are independent of this public identity. Never publish signing keys
or raw private certificate material with source or release artifacts.

## Android signing

For a durable install/update identity, keep a dedicated keystore outside Git and
back it up securely. Configure these secrets in the GitHub `release` environment:

| Secret | Purpose |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | Base64-encoded release keystore |
| `ANDROID_KEYSTORE_PASSWORD` | Keystore password |
| `ANDROID_KEY_ALIAS` | Signing entry alias |
| `ANDROID_KEY_PASSWORD` | Signing entry password |

The manual **Build distribution artifacts** workflow decodes the key to the
runner's temporary directory and supplies `ANDROID_KEYSTORE_PATH` plus the three
signing values to Gradle. All are required; the workflow fails instead of
publishing a debug-signed release. It removes the temporary key in an `always`
step. Never echo secrets or place them in artifacts. Protect the release
environment and run the workflow only on a reviewed commit, never untrusted PR
code. Fork PR jobs receive no signing material.

Locally, set `ANDROID_KEYSTORE_PATH`, `ANDROID_KEYSTORE_PASSWORD`,
`ANDROID_KEY_ALIAS`, and `ANDROID_KEY_PASSWORD` in your process environment, then
build APK and AAB. Without signing environment values, local release builds may
use the development key and must be labelled accordingly. Replacing a debug
identity with a release key can require uninstalling the earlier app; export or
otherwise preserve your settings securely first. Do not claim store provenance
for locally signed builds.

## Artifacts and honest platform labels

| Artifact | Distribution status |
|---|---|
| Universal Android APK | Installable if signed; document certificate identity |
| Android AAB | Store submission input, not directly installed like an APK |
| Windows x64 ZIP | Extract every file; unsigned executable may trigger OS warnings |
| macOS `.app` ZIP | Unsigned/unnotarized unless a separate signing process is completed |
| iOS Simulator `.app` ZIP | Simulator only; cannot install on an iPhone |
| Signed device IPA | Requires an appropriate Apple account, entitlements and distribution provisioning; not produced by the unsigned workflow |

Apple build runners use macOS 26/Xcode 26 or newer. Native signing/capabilities
and device testing remain necessary. Do not relabel an unsigned device archive
or simulator ZIP as a ready-to-install iOS release.

## Release checklist

1. Update `pubspec.yaml` version/build number, changelog and platform notes.
   Run localization generation; inspect all eight locales, including RTL.
2. Verify analyzer, tests and platform CI for the exact release commit. Confirm
   authentication, imports, lock privacy and a representative real-server flow
   using authorized test data. Record what was and was not exercised.
3. Run the manual artifact workflow. Verify APK signature, ABI list, ZIP CRC,
   16 KiB Android native alignment and artifact contents; scan for secrets and
   accidental machine-specific files. Keep dependencies' license notices.
4. Copy each platform's generated `SHA256SUMS.txt` with its artifacts, or combine
   them into one release checksum file. Windows packages include the whole
   runtime directory; Apple ZIPs retain bundle permissions/resources.
5. Create the release/tag manually at the verified commit. Attach only successful
   platform outputs; state signing/notarization limitations and any build gaps.

Checksums detect a mismatched download; they do not replace signature verification
or establish an independent supply-chain attestation.
