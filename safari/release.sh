#!/usr/bin/env bash
# Uploads the iOS and macOS apps to App Store Connect and builds a notarized
# Developer ID copy of the macOS app at dist/release/Linkding-<version>-macOS.zip.
#
# Requires ASC_KEY_PATH, ASC_KEY_ID and ASC_ISSUER_ID for an App Store Connect
# API key with the Admin role, and a Developer ID Application identity in the keychain.

set -euo pipefail

cd "$(dirname "$0")/.."

: "${ASC_KEY_PATH:?}" "${ASC_KEY_ID:?}" "${ASC_ISSUER_ID:?}"

project="safari/xcode/Linkding Extension/Linkding Extension.xcodeproj"
out=dist/release
version=$(plutil -extract version raw safari/manifest.json)
build=$(date -u +%Y%m%d.%H%M)
auth=(
  -allowProvisioningUpdates
  -authenticationKeyPath "$ASC_KEY_PATH"
  -authenticationKeyID "$ASC_KEY_ID"
  -authenticationKeyIssuerID "$ASC_ISSUER_ID"
)

safari/build.sh
mkdir -p "$out"

# Archives skip development signing so CI needs no development certificate or
# registered device; export signs them for distribution. macOS is ad-hoc signed
# to keep its sandbox entitlements, which export carries over.
archive() {
  xcodebuild archive -quiet \
    -project "$project" \
    -scheme "Linkding Extension ($1)" \
    -destination "generic/platform=$1" \
    -archivePath "$out/$1.xcarchive" \
    MARKETING_VERSION="$version" \
    CURRENT_PROJECT_VERSION="$build" \
    "${@:2}"
}

export_archive() {
  xcodebuild -exportArchive \
    -archivePath "$out/$1.xcarchive" \
    -exportOptionsPlist "safari/ExportOptions-$2.plist" \
    -exportPath "$out/$1-$2" \
    "${auth[@]}"
}

archive iOS CODE_SIGNING_ALLOWED=NO
archive macOS CODE_SIGN_STYLE=Manual CODE_SIGN_IDENTITY=- PROVISIONING_PROFILE_SPECIFIER=

export_archive iOS AppStore
export_archive macOS AppStore
export_archive macOS DeveloperID

app="$out/macOS-DeveloperID/Linkding Extension.app"
zip="$out/Linkding-$version-macOS.zip"
ditto -c -k --keepParent "$app" "$zip"
xcrun notarytool submit "$zip" --wait \
  --key "$ASC_KEY_PATH" --key-id "$ASC_KEY_ID" --issuer "$ASC_ISSUER_ID"
xcrun stapler staple "$app"
ditto -c -k --keepParent "$app" "$zip"
