#!/usr/bin/env bash
# Assembles the Safari extension in dist/safari, which the Xcode project references.

set -euo pipefail

cd "$(dirname "$0")/.."

bun install --frozen-lockfile
bun run build

mkdir -p dist/safari
rsync -a --delete build icons options popup styles dist/safari/
cp safari/manifest.json dist/safari/manifest.json
