#!/usr/bin/env python3
"""Check a phrase list against the limits the app and widgets can display.

Usage:
    python3 scripts/check_phrases.py                  # checks Shared/phrases.json, expects 365
    python3 scripts/check_phrases.py file.json --partial  # skips the count check
"""
import json
import platform
import shutil
import subprocess
import sys
from pathlib import Path

EXPECTED_COUNT = 365
LABELS = {"Idiom", "Logic", "Allusion", "Phrase"}
INTENTS = {
    "Doubt", "Disagree", "Nuance", "Agree", "Clarify", "Reason", "Judge", "Opinion",
    "Caution", "Summarize", "Admit", "Connect", "Observe", "Decide", "Recall",
}
# Longest values the widgets were tuned for (see WordDayWidget.swift).
MAX_LEN = {
    "phrase": 35,
    "meaning": 110,
    "example": 100,
    "tone": 45,
    "avoidWhen": 100,
}
MAX_VARIANT = 45
MAX_USAGE = 100

# Rendered fit, measured with scripts/measure_text.swift in the widget fonts.
# Widths assume a 6.1-6.3" iPhone with 16pt widget margins. Limits match what the
# original phrase list already showed: meaning in 2 lines on the medium widget,
# example in 3 lines on the large widget, phrase within 99pt on the small widget.
CONTENT_WIDTH = 306
SMALL_WIDTH = 126
MAX_MEANING_LINES = 2
MAX_EXAMPLE_LINES = 3
MAX_SMALL_PHRASE_HEIGHT = 99


def core(phrase):
    return phrase.rstrip(".?!…").rstrip(".").lower()


def small_phrase_size(phrase):
    # Mirrors smallWidgetPhraseSize in WordDayWidget.swift.
    n = len(phrase)
    return 28 if n <= 19 else 24 if n <= 25 else 20


def check_fit(items):
    """Measure wrapping in the real fonts. Needs macOS with Swift."""
    if platform.system() != "Darwin" or not shutil.which("swift"):
        print("note: skipped rendered-fit checks (needs macOS with Swift)")
        return []
    jobs = []
    for i, item in enumerate(items):
        where = f"[{i}] {item.get('phrase')!r}"
        jobs += [
            (where, "meaning (New York)", MAX_MEANING_LINES, 0, f"newyork\t14\t{CONTENT_WIDTH}\t{item['meaning']}"),
            (where, "meaning (system)", MAX_MEANING_LINES, 0, f"system\t14\t{CONTENT_WIDTH}\t{item['meaning']}"),
            (where, "example", MAX_EXAMPLE_LINES, 0, f"newyork-italic\t12\t{CONTENT_WIDTH}\t\"{item['example']}\""),
            (where, "small widget phrase", 0, MAX_SMALL_PHRASE_HEIGHT,
             f"AvenirNextCondensed-DemiBold\t{small_phrase_size(item['phrase'])}\t{SMALL_WIDTH}\t{item['phrase']}"),
        ]
    script = Path(__file__).resolve().parent / "measure_text.swift"
    result = subprocess.run(
        ["swift", str(script)], input="\n".join(j[-1] for j in jobs) + "\n",
        capture_output=True, text=True, check=True,
    ).stdout.split("\n")
    errors = []
    for (where, what, max_lines, max_height, _), row in zip(jobs, result):
        lines, height = (int(v) for v in row.split("\t"))
        if max_lines and lines > max_lines:
            errors.append(f"{where}: {what} wraps to {lines} lines (max {max_lines})")
        if max_height and height > max_height:
            errors.append(f"{where}: {what} needs {height}pt (max {max_height})")
    return errors


def check(items, partial):
    errors = []
    if not isinstance(items, list):
        return ["top level is not a list"]
    if not partial and len(items) != EXPECTED_COUNT:
        errors.append(f"expected {EXPECTED_COUNT} phrases, found {len(items)}")

    seen = {}
    for i, item in enumerate(items):
        name = item.get("phrase", f"#{i}")
        where = f"[{i}] {name!r}"
        for key in ["phrase", "label", "intent", "meaning", "example", "tone", "avoidWhen"]:
            if not isinstance(item.get(key), str) or not item[key].strip():
                errors.append(f"{where}: missing {key}")
        for key in ["usageExamples", "variants"]:
            value = item.get(key)
            if not isinstance(value, list) or len(value) < 2:
                errors.append(f"{where}: {key} needs at least 2 entries")
        if errors and errors[-1].startswith(where + ": missing"):
            continue

        for key, limit in MAX_LEN.items():
            if len(item[key]) > limit:
                errors.append(f"{where}: {key} is {len(item[key])} chars (max {limit})")
        if item["label"] not in LABELS:
            errors.append(f"{where}: unknown label {item['label']!r}")
        if item["intent"] not in INTENTS:
            errors.append(f"{where}: unknown intent {item['intent']!r}")
        if core(item["phrase"]) not in item["example"].lower():
            errors.append(f"{where}: example does not contain the phrase")
        if len(item["variants"]) != 3:
            errors.append(f"{where}: needs exactly 3 variants")
        for v in item["variants"]:
            if len(v) > MAX_VARIANT:
                errors.append(f"{where}: variant too long: {v!r}")
            if v.strip().lower() == item["phrase"].lower():
                errors.append(f"{where}: variant repeats the phrase")
        for u in item["usageExamples"]:
            if len(u) > MAX_USAGE:
                errors.append(f"{where}: usage example too long: {u!r}")
        if not item["avoidWhen"].startswith("Avoid"):
            errors.append(f"{where}: avoidWhen should start with 'Avoid'")
        if "flag" in item:
            errors.append(f"{where}: flagged: {item['flag']}")

        key = item["phrase"].strip().lower()
        if key in seen:
            errors.append(f"{where}: duplicate of [{seen[key]}]")
        seen[key] = i

    # The list order is the calendar order (WordLibrary.index), wrapping around.
    if not partial:
        for i, item in enumerate(items):
            prev = items[i - 1]
            if item.get("intent") and item.get("intent") == prev.get("intent"):
                errors.append(f"[{i}] {item.get('phrase')!r}: same intent as the day before ({item['intent']})")
    return errors


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    partial = "--partial" in sys.argv
    path = Path(args[0]) if args else Path(__file__).resolve().parent.parent / "Shared" / "phrases.json"
    items = json.loads(path.read_text(encoding="utf-8"))
    errors = check(items, partial)
    if not errors:
        errors = check_fit(items)
    for e in errors:
        print(e)
    print(f"{path.name}: {len(items)} phrases, {len(errors)} problems")
    sys.exit(1 if errors else 0)


if __name__ == "__main__":
    main()
