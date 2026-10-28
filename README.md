# WordDay

An iPhone widget that gives you one useful English chunk every day.

A short phrase appears on your Home Screen or Lock Screen each morning. Open
the app to see what it means, when to use it, examples, natural variants, and whether
the tone fits the conversation.

## Features

| Feature | Description |
| --- | --- |
| **Home Screen widget** | Small, medium, and large sizes. The small widget stays focused: tiny context label plus the usable phrase. Medium and large widgets add meaning and examples. |
| **Lock Screen widget** | Inline, circular, and rectangular accessory families for quick daily recall. |
| **App** | Today's chunk in full, a browsable/searchable phrase bank, and a saved-chunks filter. |
| **Phrase bank** | 365 phrases that sound casual but well-read (idioms, reasoning terms, allusions, everyday connectors) in `Shared/phrases.json`, so nothing repeats within a year. |

The phrase for a given day is derived from the date itself, so the app and
widget always agree without syncing. The widget builds a seven-day timeline
ahead of time and refreshes after the last entry.

## Requirements

- Xcode 15 or later
- iOS 17 or later
- An Apple Developer team for signing on device

## Running

Open the generated project:

```sh
open WordDay.xcodeproj
```

If you regenerate the project from `project.yml`, use XcodeGen:

```sh
xcodegen generate
```

## Adding Phrases

Append to `Shared/phrases.json`:

```json
{
  "phrase": "Take that with a grain of salt.",
  "label": "Idiom",
  "intent": "Doubt",
  "meaning": "Don't fully trust it. Use it to signal doubt about a claim without calling it false.",
  "example": "The survey had forty replies, so take that with a grain of salt.",
  "usageExamples": [
    "He's selling the product, so take that with a grain of salt.",
    "It's one study. I'd take that with a grain of salt for now."
  ],
  "variants": [
    "I wouldn't read too much into it.",
    "I'd be a little skeptical of that.",
    "That needs a caveat."
  ],
  "tone": "Measured, skeptical, relaxed",
  "avoidWhen": "Avoid it when the source is solid; it can sound dismissive of good evidence."
}
```

Short phrases work best because the widget treats the chunk itself as the hero.
The label and intent should stay tiny and contextual.

`label` is one of `Idiom`, `Logic`, `Allusion`, `Phrase`; `intent` is a single word
such as `Doubt`, `Nuance` or `Reason`. After editing the list, check it against the
widget limits:

```sh
python3 scripts/check_phrases.py
```

## Structure

```text
Shared/            model + phrase bank, compiled into both targets
  Word.swift       phrase model with compatibility aliases
  WordLibrary.swift
  WordDayStyle.swift
  LearnedStore.swift
  phrases.json
WordDay/           SwiftUI app
WordDayWidget/     WidgetKit extension
scripts/           check_phrases.py validates the phrase bank
```
