#!/bin/bash
# Fetch pending Marketplace submissions into inbox/, or clear a processed one.
#   ./review.sh              — download everything pending
#   ./review.sh --done NAME  — remove NAME from the server after approving
set -euo pipefail
cd "$(dirname "$0")"
source .env   # REVIEW_URL + REVIEW_SECRET

if [ "${1:-}" = "--done" ]; then
  curl -sf -X POST "$REVIEW_URL?secret=$REVIEW_SECRET" \
    -H 'Content-Type: application/json' -d "{\"remove\": \"$2\"}" > /dev/null
  echo "Removed $2 from the server."
  exit 0
fi

mkdir -p inbox
LIST=$(curl -sf "$REVIEW_URL?secret=$REVIEW_SECRET")
COUNT=$(echo "$LIST" | python3 -c "import json,sys; print(len(json.load(sys.stdin)['items']))")
echo "$COUNT pending submission(s)."
echo "$LIST" | python3 -c "
import json, sys, urllib.request
for item in json.load(sys.stdin)['items']:
    if not item['url']:
        continue
    dest = 'inbox/' + item['name']
    urllib.request.urlretrieve(item['url'], dest)
    print('  fetched', dest)
"
echo
echo "Next: ./approve.sh inbox/<file>.zip   then   ./review.sh --done <file>.zip"
