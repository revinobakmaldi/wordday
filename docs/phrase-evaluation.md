# Phrase list evaluation for an intermediate learner

29 Oct 2026. Covers all 365 phrases in `Shared/phrases.json`, rated for one learner at CEFR B1–B2 who wants to sound casual but well-read.

## Answer

The list mostly fits. 242 phrases (66%) are worth learning now, 90 (25%) are a stretch but fine with the example, and 33 (9%) are not worth your time. The weak spot is the **Allusion** label: 13 of its 23 phrases should be swapped.

## How it was rated

- Two AI reviewers (Sonnet 5.5, ESL-teacher brief) each rated half of the list, one pass per phrase. For each phrase they gave a CEFR level, whether you could guess the meaning, how often Americans say it, how easily it is misused, and a verdict.
- A word-frequency score (`wordfreq` Zipf scale) checked the rarest word in each phrase.
- I changed four reviewer verdicts (see "Overrides") and removed two wrong entry notes (324, 356: the entries already warn about the shaky attribution).
- **Limits:** one rater per phrase and no native speaker checked it. Read the verdicts as a strong opinion, not a test score. All ratings are in `docs/phrase-ratings.json`.

## Summary

| Verdict | Count | Meaning |
|---|---|---|
| core | 242 | Useful and within reach |
| stretch | 90 | Useful, a level above you |
| swap | 33 | Rare, dated, niche or risky |

| Level | Count |
|---|---|
| B1 | 21 |
| B2 | 219 |
| C1 | 115 |
| C2 | 10 |

So 240 phrases (66%) are at or below your level and 125 (34%) are above it. That is a good mix for growth.

| Label | Core | Stretch | Swap |
|---|---|---|---|
| Phrase | 111 | 30 | 11 |
| Idiom | 101 | 24 | 5 |
| Logic | 28 | 28 | 4 |
| Allusion | 2 | 8 | 13 |

Other findings:

- **Guessing the meaning:** 118 phrases can be guessed from the words, 192 partly, and 55 not at all. The 55 opaque ones are mostly idioms such as "The jury's still out." The meaning line on the widget covers them.
- **How often Americans say them:** 168 often, 167 sometimes, 30 rarely. Most of the rare ones are in the swap list.
- **Misuse risk:** 280 low, 70 medium, 15 high. Two high-risk phrases are worth keeping with care:
  - 94 "According to whom?" usually sounds like a challenge, not a polite question.
  - 142 "Let's table that for now." means postpone in the US and discuss now in the UK. The entry already says so.

## Recommended swaps (33)

| # | Phrase | Level | Why | |
|---|---|---|---|---|
| 12 | Never mind the cost. | B2 | Sounds British and odd; "cost aside" is natural. | swap-row |
| 13 | That's rather quixotic. | C1 | Pompous in speech; "unrealistic" does the job. | swap-row |
| 21 | It's a fait accompli. | C1 | French, formal; "done deal" is natural. | swap-row |
| 30 | We've crossed the Rubicon. | C2 | Needs history; "no turning back" says the same. | swap-row |
| 77 | That's a Pyrrhic victory. | C2 | Needs history; "a win that cost too much". | swap-row |
| 81 | That's a Sisyphean task. | C2 | Myth reference; rare in speech. | swap-row |
| 88 | It's a watershed moment. | C1 | Mostly news writing; "turning point" is spoken. | swap-row |
| 97 | That's the long and short of it. | C1 | Dated, a bit British; "that's the gist". | swap-row |
| 99 | Ostensibly, it's about cost. | C1 | Pompous; "supposedly" or "on paper". | swap-row |
| 105 | It's all a bit Kafkaesque. | C2 | Needs literature; "bureaucratic nightmare". | swap-row |
| 112 | It's a Faustian bargain. | C2 | "A deal with the devil" is more common. | swap-row |
| 138 | Conceivably, yes. | C1 | Stiff as a reply; "possibly". | swap-row |
| 162 | Let's make an informed decision. | B2 | Sounds like a brochure. | swap-row |
| 171 | Let me offer a counterpoint. | C1 | Stiff; "let me push back a little". | swap-row |
| 172 | That's a tautology. | C1 | Pedantic; "that's circular". | swap-row |
| 176 | First, do no harm. | C1 | Preachy outside medicine; clumsy example. | swap-row |
| 214 | By the same token, it's risky. | C1 | Mostly written; "same goes for". | swap-row |
| 215 | Unequivocally, yes. | C1 | Pompous; "absolutely". | swap-row |
| 221 | It's a known unknown. | C1 | Rumsfeld jargon; confuses listeners. | swap-row |
| 224 | Let's cut the Gordian knot. | C2 | Classical allusion; rare in speech. | swap-row |
| 231 | That's a category error. | C2 | Philosophy jargon. | swap-row |
| 242 | As it happens, I agree. | C1 | Easy to misuse; "actually, I agree". | swap-row |
| 247 | Let me steelman their view. | C2 | Online jargon; most people won't know it. | swap-row |
| 251 | You've given me pause. | C1 | Theatrical; "that makes me think twice". | swap-row |
| 268 | The map is not the territory. | C2 | Philosophy quote; sounds showy. | swap-row |
| 270 | Penny wise, pound foolish. | C1 | Dated proverb. | swap-row |
| 294 | Tellingly, no one asked why. | C1 | Mostly written. | swap-row |
| 323 | Color me skeptical. | C1 | Dated, mock-casual; "I have my doubts". | swap-row |
| 329 | To use an analogy... | B2 | Stiff; "it's kind of like...". | swap-row |
| 338 | I'll take that under advisement. | C1 | Often heard as a brush-off or sarcasm. | swap-row |
| 349 | That's a Herculean effort. | C1 | Bookish; "huge effort". | swap-row |
| 356 | History tends to rhyme. | C1 | Cliché quote; sounds like performing wisdom. | swap-row |
| 362 | That opened Pandora's box. | C1 | Overlaps "can of worms" (351). | swap-row |

## Overrides

The reviewers marked these as swaps. I kept them:

- 170 "That's Goodhart's law in action.", 198 "That's an empirical question." and 299 "What's the base rate?": niche in general, but common in analytics work, which is your job. Now stretch.
- 191 "That's spot on.": common in American speech too. Now core.

## Entry fixes (small, keep the phrase)

| # | Phrase | Fix |
|---|---|---|
| 11 | It's a vicious circle. | Americans more often say "vicious cycle". |
| 25 | That's a self-fulfilling prophecy. | Example is loose. |
| 74 | Put another way, it's a tax. | Example is too abstract. |
| 94 | According to whom? | Meaning says "politely"; it usually sounds challenging. |
| 116 | That's the status quo. | Example is circular. |
| 163 | What are we optimizing for? | "Views" in the example is unclear; "scenery". |
| 190 | There's a selection bias here. | Drop "a": "There's selection bias here." |
| 344 | That's just herd behavior. | "Herd mentality" is more common. |

Check this file against the data with `python3 scripts/check_ratings.py`.
