#!/usr/bin/env bash
# Render heroes with the real game code: tools/preview/preview.sh out.png [--rarity Common,Secret] [HeroId ...]
# Env: LUAU (luau CLI binary, default `luau`), VIEWS (camera yaw degrees, default 0,35,180), COLS (heroes per row, default 3)
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
out="$(realpath -m "$1")"; shift
scene="$(mktemp --suffix .json)"
python3 "$here/dump.py" "${LUAU:-luau}" "$scene" "$@"
[ -d "$here/node_modules/three" ] || (cd "$here" && npm i --silent --no-save three@0.160.0)
node "$here/render.js" "$scene" "$out" "${VIEWS:-0,35,180}" "${COLS:-3}" "${STYLE:-ink}"
echo "wrote $out"
