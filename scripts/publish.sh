#!/usr/bin/env bash
# Build with Rojo and publish to Roblox via Open Cloud.
# Usage: ROBLOX_API_KEY=... ./scripts/publish.sh   (key needs universe-places Write on this experience)
set -euo pipefail
UNIVERSE_ID=10772668310
PLACE_ID=95876647985129
rojo build -o build.rbxlx
curl -sS -X POST "https://apis.roblox.com/universes/v1/$UNIVERSE_ID/places/$PLACE_ID/versions?versionType=Published" \
	-H "x-api-key: $ROBLOX_API_KEY" -H "Content-Type: application/xml" --data-binary @build.rbxlx
echo
