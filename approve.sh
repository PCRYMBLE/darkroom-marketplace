#!/bin/bash
# Approve a marketplace submission: ./approve.sh path/to/marketplace-xxx.zip
set -euo pipefail
ZIP="$1"
ROOT="$(cd "$(dirname "$0")" && pwd)"
TMP="$(mktemp -d)"
ditto -x -k "$ZIP" "$TMP"
# the zip contains one staging folder
SRC="$(find "$TMP" -name submission.json -maxdepth 3 | head -1 | xargs dirname)"
[ -n "$SRC" ] || { echo "No submission.json in zip"; exit 1; }
KIND=$(python3 -c "import json;print(json.load(open('$SRC/submission.json'))['kind'])")
TID=$(python3 -c "import json;print(json.load(open('$SRC/submission.json'))['templateID'])")
DEST="$ROOT/templates/$KIND/$TID"
mkdir -p "$DEST"
cp "$SRC"/* "$DEST"/
python3 "$ROOT/tools/rebuild_index.py"
cd "$ROOT"
git add -A
git commit -m "Approve: $TID ($KIND)"
git push
echo "Approved and published: $KIND/$TID"
