# Safari

This fork packages the linkding extension for Safari on macOS, iOS, and iPadOS.

Differences from upstream:

- Address bar search is unavailable because Safari has no omnibox API.
- The "Save to linkding" context menu works on macOS only.
- Settings open inside the popup, because Safari opens options pages in a new tab, which dismisses the popup on iOS.
- Saving settings asks Safari for access to the linkding server. Enabling "Pre-load page information while browsing" also asks for access to all websites.
- Touch devices get larger text and controls, tag suggestions as chips, and a pinned Save button.
- The popup closes after saving by default.

## Build

Requires bun and Xcode.

```sh
safari/build.sh
open "safari/xcode/Linkding Extension/Linkding Extension.xcodeproj"
```

`safari/build.sh` assembles the extension in `dist/safari`, which the Xcode project references. Run it before each Xcode build.

Run the `Linkding Extension (iOS)` or `Linkding Extension (macOS)` scheme, then enable the extension:

- iOS: Settings › Apps › Safari › Extensions › Linkding Extension.
- macOS: Safari › Settings › Extensions. Builds signed to run locally also need Safari › Settings › Developer › Allow unsigned extensions.

## Release

1. Bump `version` in `safari/manifest.json` and commit.
2. Tag and push: `git tag v<version> && git push origin v<version>`.
3. When the Release workflow finishes, submit the iOS and macOS builds for review in App Store Connect.

The workflow runs `safari/release.sh`. It sets the app version from `safari/manifest.json` and the build number from the current UTC time. It uploads both platforms to App Store Connect and attaches a notarized Developer ID build of the macOS app to the GitHub release.

Repository secrets:

| Secret | Value |
|---|---|
| `ASC_KEY_ID`, `ASC_ISSUER_ID` | App Store Connect Team API key with the Admin role |
| `ASC_KEY_P8` | Contents of that key's `.p8` file |
| `DEVELOPER_ID_P12` | Base64 of the exported Developer ID Application certificate and private key |
| `DEVELOPER_ID_P12_PASSWORD` | The `.p12` export password |

Privacy policy for App Store Connect: [PRIVACY.md](PRIVACY.md).

## Syncing upstream

`master` mirrors [sissbruecker/linkding-extension](https://github.com/sissbruecker/linkding-extension). `safari` holds the Safari changes on top.

```sh
git fetch upstream
git switch master && git merge --ff-only upstream/master
git switch safari && git merge master
bun install            # refresh bun.lock if upstream changed dependencies
safari/build.sh
```

Compare upstream's `manifest.json` changes with `safari/manifest.json`, then test in the iOS Simulator and Safari on macOS before committing. If upstream adds a new top-level directory to the extension, add it to `safari/build.sh` and as a folder reference in the Xcode extension targets.
