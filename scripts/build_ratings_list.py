#!/usr/bin/env python3
"""Write docs/phrase-ratings.md, a phone-readable list of docs/phrase-ratings.json."""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
phrases = json.loads((ROOT / "Shared/phrases.json").read_text())
ratings = json.loads((ROOT / "docs/phrase-ratings.json").read_text())
HEADS = {
    "swap": "Swap: not worth your time",
    "stretch": "Stretch: useful, a level above you",
    "core": "Core: learn these now",
}
count = {v: sum(r["final"] == v for r in ratings) for v in HEADS}
out = [
    f"# All {len(ratings)} phrases, rated", "",
    "Rated for a B1–B2 learner. Each line: number · phrase · level. Grouped by verdict, then by label. "
    "_New_ marks a phrase added in the 29 Oct update.", "",
    " · ".join(f"{v.capitalize()} {count[v]}" for v in ["core", "stretch", "swap"]), "",
]
for verdict in ["swap", "stretch", "core"]:
    rows = [r for r in ratings if r["final"] == verdict]
    if not rows:
        continue
    out += [f"## {HEADS[verdict]} ({len(rows)})", ""]
    for label in ["Phrase", "Idiom", "Logic", "Allusion"]:
        sub = [r for r in rows if phrases[r["i"]]["label"] == label]
        if not sub:
            continue
        out += [f"### {label} ({len(sub)})", ""]
        for r in sub:
            line = f"- {r['i']} · {r['phrase']} · {r['level']}"
            notes = []
            if "replaced" in r:
                notes.append(f"New, replaces “{r['replaced']}”")
            if verdict == "swap" and r["note"]:
                notes.append(r["note"])
            if r["override"]:
                notes.append(r["override"])
            if r["misuse_risk"] == "high" and r["note"]:
                notes.append(f"Careful: {r['note']}")
            if notes:
                line += "  \n  _" + " ".join(notes) + "_"
            out.append(line)
        out.append("")
(ROOT / "docs/phrase-ratings.md").write_text("\n".join(out))
print(f"wrote docs/phrase-ratings.md: {len(ratings)} phrases")
