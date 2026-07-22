# darkroom Marketplace

Community templates for the darkroom scrapbook app — polaroid frames, photo
wallets, books, music, TVs, verse cards, headlines and stickers.

## How it works
- Users submit templates from the app (Designer → Upload to Marketplace).
  Submissions arrive by email as a zip containing the template files and a
  signed `submission.json`.
- To approve one: `./approve.sh path/to/marketplace-name.zip` — it unpacks the
  submission into `templates/<kind>/<id>/`, rebuilds `index.json`, commits and
  pushes. The app picks it up immediately.
- The app reads `index.json` from this repository's raw URL.

## Layout
- `index.json` — the catalogue the app fetches.
- `templates/<kind>/<id>/` — one folder per approved template
  (`template.json`, `frame.png`, `submission.json`).
