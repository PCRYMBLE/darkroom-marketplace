#!/usr/bin/env python3
"""Rebuilds index.json by scanning templates/<kind>/<id>/submission.json."""
import json, os, sys

root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
entries = []
tdir = os.path.join(root, "templates")
for kind in sorted(os.listdir(tdir)) if os.path.isdir(tdir) else []:
    kpath = os.path.join(tdir, kind)
    if not os.path.isdir(kpath):
        continue
    for tid in sorted(os.listdir(kpath)):
        tpath = os.path.join(kpath, tid)
        sub = os.path.join(tpath, "submission.json")
        if not os.path.isfile(sub):
            continue
        with open(sub) as f:
            meta = json.load(f)
        files = sorted(f for f in os.listdir(tpath)
                       if not f.startswith(".") and f != "submission.json")
        thumb = next((f for f in files if f.endswith(".png")), None)
        entries.append({
            "id": tid,
            "kind": kind,
            "name": meta.get("name", tid),
            "author": meta.get("username") or meta.get("author", ""),
            "description": meta.get("description", ""),
            "path": f"templates/{kind}/{tid}",
            "files": files,
            "thumb": f"templates/{kind}/{tid}/{thumb}" if thumb else None,
        })
with open(os.path.join(root, "index.json"), "w") as f:
    json.dump({"version": 1, "templates": entries}, f, indent=2, sort_keys=True)
print(f"index.json: {len(entries)} template(s)")
