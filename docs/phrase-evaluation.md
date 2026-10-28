# Phrase list evaluation for an intermediate learner

29 Oct 2026. Covers all 365 phrases in `Shared/phrases.json`, rated for one learner at CEFR B1–B2 who wants to sound casual but well-read.

## Answer

After the update, every phrase is worth learning: 267 are core and 98 are a stretch. 36 phrases changed: 33 weak ones were replaced and 3 were reworded. Five more entries got better examples or meanings.

## Before and after

| | Before | After |
|---|---|---|
| Core | 242 | 267 |
| Stretch | 90 | 98 |
| Swap | 33 | 0 |
| Rarely said by Americans | 30 | 3 |
| C2 level | 10 | 1 |

## Summary

| Verdict | Count | Meaning |
|---|---|---|
| core | 267 | Useful and within reach |
| stretch | 98 | Useful, a level above you |
| swap | 0 | Rare, dated, niche or risky |

| Level | Count |
|---|---|
| B1 | 23 |
| B2 | 242 |
| C1 | 99 |
| C2 | 1 |

So 265 phrases (73%) are at or below your level and 100 (27%) are above it.

| Label | Core | Stretch |
|---|---|---|
| Phrase | 128 | 33 |
| Idiom | 106 | 29 |
| Logic | 31 | 28 |
| Allusion | 2 | 8 |

Two phrases need care:

- 94 "According to whom?" can sound confrontational. Use it with equals, and smile.
- 142 "Let's table that for now." means postpone in the US and discuss now in the UK.

## What changed

Each new phrase keeps the intent of the one it replaced, so no two days in a row share an intent.

| # | Before | After | |
|---|---|---|---|
| 11 | It's a vicious circle. | It's a vicious cycle. | change-row |
| 12 | Never mind the cost. | Setting cost aside, would it work? | change-row |
| 13 | That's rather quixotic. | That's a pipe dream. | change-row |
| 21 | It's a fait accompli. | It's a done deal. | change-row |
| 30 | We've crossed the Rubicon. | That's a hard pill to swallow. | change-row |
| 77 | That's a Pyrrhic victory. | It's a hollow victory. | change-row |
| 81 | That's a Sisyphean task. | That's an uphill battle. | change-row |
| 88 | It's a watershed moment. | It's a turning point. | change-row |
| 97 | That's the long and short of it. | All in all, it went well. | change-row |
| 99 | Ostensibly, it's about cost. | On paper, it's about cost. | change-row |
| 105 | It's all a bit Kafkaesque. | It's a bureaucratic nightmare. | change-row |
| 112 | It's a Faustian bargain. | It's a deal with the devil. | change-row |
| 138 | Conceivably, yes. | Even so, it's worth a try. | change-row |
| 162 | Let's make an informed decision. | Let's look at the numbers first. | change-row |
| 171 | Let me offer a counterpoint. | For my money, it's the best option. | change-row |
| 172 | That's a tautology. | That's true by definition. | change-row |
| 176 | First, do no harm. | Let's tread carefully here. | change-row |
| 190 | There's a selection bias here. | There's selection bias here. | change-row |
| 214 | By the same token, it's risky. | The same goes for the budget. | change-row |
| 215 | Unequivocally, yes. | No doubt about it. | change-row |
| 221 | It's a known unknown. | We don't know what we don't know. | change-row |
| 224 | Let's cut the Gordian knot. | That's overkill. | change-row |
| 231 | That's a category error. | That doesn't match my experience. | change-row |
| 242 | As it happens, I agree. | As a matter of fact, it's done. | change-row |
| 247 | Let me steelman their view. | If it were up to me, I'd wait. | change-row |
| 251 | You've given me pause. | That makes me think twice. | change-row |
| 268 | The map is not the territory. | In theory, yes. In practice, no. | change-row |
| 270 | Penny wise, pound foolish. | That's short-sighted. | change-row |
| 294 | Tellingly, no one asked why. | Interestingly, no one asked why. | change-row |
| 323 | Color me skeptical. | I have my doubts. | change-row |
| 329 | To use an analogy... | Think of it as a filter. | change-row |
| 338 | I'll take that under advisement. | I'll be the first to admit it. | change-row |
| 344 | That's just herd behavior. | That's just herd mentality. | change-row |
| 349 | That's a Herculean effort. | That's a no-brainer. | change-row |
| 356 | History tends to rhyme. | We've seen this movie before. | change-row |
| 362 | That opened Pandora's box. | A step in the right direction. | change-row |

Rows 11, 190 and 344 are rewordings. The other 33 are replacements.

Five more entries kept their phrase but got a better example or meaning: 25, 74, 94, 116 and 163.

## Kept on purpose

- 170 "That's Goodhart's law in action.", 198 "That's an empirical question." and 299 "What's the base rate?": niche in general, but common in analytics work, which is your job.
- 191 "That's spot on.": common in American speech too.

## How it was rated

- Two AI reviewers (Sonnet 5.5, ESL-teacher brief) each rated half of the original list, one pass per phrase. They gave each phrase a CEFR level, whether you could guess the meaning, how often Americans say it, how easily it is misused, and a verdict.
- A third reviewer checked all 41 changed entries, including whether any new phrase repeats another one. It flagged one new phrase ("That's a heavy lift.") and three near-duplicates. I replaced those four and fixed its notes on examples and variants. Then it re-checked them and found no problems.
- A word-frequency score (`wordfreq` Zipf scale) checked the rarest word in each phrase.
- **Limits:** one rater per phrase and no native speaker checked it. Read the verdicts as a strong opinion, not a test score.

## Files

- `docs/phrase-ratings.md`: the full list of 365, readable on a phone. Rebuild it with `python3 scripts/build_ratings_list.py`.
- `docs/phrase-ratings.json`: all ratings.
- `python3 scripts/check_ratings.py` checks both files against the phrase list and this report.
- `python3 scripts/check_phrases.py` checks the phrase list itself, including widget fit.
