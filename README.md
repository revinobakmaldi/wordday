# WordDay

An iPhone widget that gives you one useful English chunk every day.

A short phrase appears on your Home Screen or Lock Screen each morning. Open
the app to see when to use it, business examples, natural variants, and whether
the tone fits the conversation.

## Features

| Feature | Description |
| --- | --- |
| **Home Screen widget** | Small, medium, and large sizes. The small widget stays focused: tiny context label plus the usable phrase. Medium and large widgets add meaning and examples. |
| **Lock Screen widget** | Inline, circular, and rectangular accessory families for quick daily recall. |
| **App** | Today's chunk in full, a browsable/searchable phrase bank, and a saved-chunks filter. |
| **Phrase bank** | Practical business and daily conversation chunks in `Shared/phrases.json`. |

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
  "phrase": "Let me make sure I understand.",
  "label": "Business",
  "intent": "Clarify",
  "meaning": "Use this before responding, so you can confirm the point without sounding hesitant.",
  "example": "Let me make sure I understand. The main concern is the timeline, right?",
  "usageExamples": [
    "Let me make sure I understand before we decide.",
    "Let me make sure I understand the constraint first."
  ],
  "variants": [
    "Just to make sure I got this right...",
    "So what you're saying is...",
    "Let me restate that quickly."
  ],
  "tone": "Calm, professional, careful",
  "avoidWhen": "Avoid overusing it when the point is already obvious."
}
```

Short phrases work best because the widget treats the chunk itself as the hero.
The label and intent should stay tiny and contextual.

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
```
