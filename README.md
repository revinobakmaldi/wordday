# WordDay

An iPhone widget that teaches you one new word every day.

A word appears on your Home Screen (or Lock Screen) each morning — no tapping,
no streaks to maintain, no account. Open the app when you want the full
definition, an example sentence, or to mark the word as learned.

## What's in the box

| | |
|---|---|
| **Home Screen widget** | Small, medium and large sizes. Word, pronunciation, part of speech, definition — and an example sentence on the large size. |
| **Lock Screen widget** | Inline and rectangular accessory families. |
| **App** | Today's word in full, a browsable/searchable list of every word, and a "learned" filter. |
| **After Dark design** | Deep aubergine surfaces, warm editorial type, and an acid-lime accent shared by the app and widgets. |
| **Word list** | 61 words in `Shared/words.json`. Add your own — it's plain JSON. |

The word for a given day is derived from the date itself, so the app and the
widget always agree without any syncing. The widget builds a seven-day
timeline and rolls over at midnight on its own.

## Requirements

- Xcode 15 or later
- iOS 17 or later (the widget uses `containerBackground`)
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) — the `.xcodeproj` is generated, not committed

## Getting started

```bash
brew install xcodegen
git clone https://github.com/<you>/wordday.git
cd wordday
xcodegen generate
open WordDay.xcodeproj
```

Then, before your first build:

1. **Set your team.** Select the `WordDay` and `WordDayWidgetExtension` targets →
   Signing & Capabilities → pick your Apple developer team.
2. **Use your own bundle IDs.** `com.example.wordday` won't sign. Change it in
   `project.yml` (both targets) and re-run `xcodegen generate`.
3. **Update the App Group.** It has to match in three places:
   - `Shared/LearnedStore.swift` → `appGroupID`
   - `WordDay/WordDay.entitlements`
   - `WordDayWidget/WordDayWidget.entitlements`

Build and run to the simulator or your phone, then long-press the Home Screen →
**+** → search for **WordDay** to add the widget.

## Adding your own words

Append to `Shared/words.json`:

```json
{
  "word": "petrichor",
  "pronunciation": "PET-ri-kor",
  "partOfSpeech": "noun",
  "definition": "The earthy scent produced when rain falls on dry soil.",
  "example": "The petrichor after the first storm of the season."
}
```

The list is shared by both targets, so the app and widget pick up new entries
together. Order matters only in that it sets the rotation.

## Project layout

```
Shared/            model + word list, compiled into both targets
  Word.swift
  WordLibrary.swift    date → word mapping
  LearnedStore.swift   App Group-backed "learned" set
  words.json
WordDay/           the SwiftUI app
WordDayWidget/     the WidgetKit extension
project.yml        XcodeGen project definition
```

## Ideas worth building next

- Notifications at a time you choose
- Pull words from a dictionary API instead of the bundled list
- Spaced repetition instead of a straight rotation
- A quiz that asks about words you marked as learned

## License

MIT — see [LICENSE](LICENSE).
