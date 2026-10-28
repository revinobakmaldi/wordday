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
# Every phrase changed since the original rating is in the report's change table.
changed = {r["i"]: (r["replaced"], r["phrase"]) for r in ratings if "replaced" in r}
rows = {int(n): (old, new) for n, old, new in
        re.findall(r"^\| (\d+) \| (.+?) \| (.+?) \| change-row \|", report, re.M)}
if rows != changed:
    problems.append(f"change table differs: {sorted(set(rows.items()) ^ set(changed.items()))}")
# The phone-readable list shows every phrase once, under its final verdict.
section, seen = None, {}
for line in (ROOT / "docs/phrase-ratings.md").read_text().splitlines():
    if m := re.match(r"## (Core|Stretch|Swap)\b", line):
        section = m.group(1).lower()
    elif m := re.match(r"- (\d+) · (.+) · (B1|B2|C1|C2)$", line.rstrip()):
        seen.setdefault(int(m.group(1)), []).append((section, m.group(2)))
for r in ratings:
    if seen.get(r["i"]) != [(r["final"], r["phrase"])]:
        problems.append(f"#{r['i']}: phrase-ratings.md shows {seen.get(r['i'])}, expected {r['final']}")
print("\n".join(problems) or f"OK: {len(ratings)} ratings, {len(swaps)} swaps")
sys.exit(1 if problems else 0)
