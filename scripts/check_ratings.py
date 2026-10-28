#!/usr/bin/env python3
"""Check docs/phrase-ratings.json covers every phrase and matches docs/phrase-evaluation.md."""
import json, re, sys
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
phrases = json.loads((ROOT / "Shared/phrases.json").read_text())
ratings = json.loads((ROOT / "docs/phrase-ratings.json").read_text())
report = (ROOT / "docs/phrase-evaluation.md").read_text()
ALLOWED = {
    "level": {"B1", "B2", "C1", "C2"},
    "guessable": {"yes", "partly", "no"},
    "native_use": {"often", "sometimes", "rare"},
    "misuse_risk": {"low", "med", "high"},
    "verdict": {"core", "stretch", "swap"},
    "final": {"core", "stretch", "swap"},
}
problems = []
if [r["i"] for r in ratings] != list(range(len(phrases))):
    problems.append(f"ratings cover {len(ratings)} rows, phrases.json has {len(phrases)}")
for r in ratings:
    if r["i"] < len(phrases) and r["phrase"] != phrases[r["i"]]["phrase"]:
        problems.append(f"#{r['i']}: rating is for '{r['phrase']}', phrase is now '{phrases[r['i']]['phrase']}'")
    for key, allowed in ALLOWED.items():
        if r.get(key) not in allowed:
            problems.append(f"#{r['i']}: {key}={r.get(key)!r}")
# Every count in the report's summary table must match the data.
counts = Counter(r["final"] for r in ratings) + Counter(r["level"] for r in ratings)
for name, value in re.findall(r"^\| (core|stretch|swap|B1|B2|C1|C2) \| (\d+) \|", report, re.M):
    if counts[name] != int(value):
        problems.append(f"report says {name}={value}, data says {counts[name]}")
# Every final swap is listed in the report, and nothing else is.
listed = {int(n) for n in re.findall(r"^\| (\d+) \| .+ \| swap-row \|", report, re.M)}
swaps = {r["i"] for r in ratings if r["final"] == "swap"}
if listed != swaps:
    problems.append(f"swap list differs: missing {sorted(swaps - listed)}, extra {sorted(listed - swaps)}")
print("\n".join(problems) or f"OK: {len(ratings)} ratings, {len(swaps)} swaps")
sys.exit(1 if problems else 0)
