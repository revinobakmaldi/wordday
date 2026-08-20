import SwiftUI
import WidgetKit

struct WordEntry: TimelineEntry {
    let date: Date
    let word: Word
}

struct WordProvider: TimelineProvider {
    func placeholder(in context: Context) -> WordEntry {
        WordEntry(date: Date(), word: .placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (WordEntry) -> Void) {
        completion(WordEntry(date: Date(), word: WordLibrary.word(for: Date())))
    }

    /// One entry per day for the next week; the system swaps them at midnight
    /// and asks for a fresh timeline once the last one is used.
    func getTimeline(in context: Context, completion: @escaping (Timeline<WordEntry>) -> Void) {
        let entries = WordLibrary.upcoming(count: 7).map { WordEntry(date: $0.date, word: $0.word) }
        guard !entries.isEmpty else {
            completion(Timeline(entries: [placeholder(in: context)], policy: .atEnd))
            return
        }
        let refresh = entries.last?.date ?? Date().addingTimeInterval(86_400)
        completion(Timeline(entries: entries, policy: .after(refresh)))
    }
}

struct WordDayWidgetEntryView: View {
    @Environment(\.widgetFamily) private var family
    @Environment(\.colorScheme) private var colorScheme
    var entry: WordEntry

    var body: some View {
        widgetContent
            .containerBackground(for: .widget) { widgetBackground }
    }

    @ViewBuilder
    private var widgetContent: some View {
        switch family {
        case .accessoryInline:
            Text("\(entry.word.word) · \(lockScreenClue)")

        case .accessoryRectangular:
            rectangularLockScreenWidget

        case .accessoryCircular:
            circularWidget

        case .systemSmall:
            smallWidget

        default:
            expandedWidget
        }
    }

    private var smallWidget: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack {
                Text(editionName)
                    .font(WordDayStyle.labelFont(size: 8))
                    .tracking(1.15)
                Spacer()
                Circle()
                    .fill(WordDayStyle.accent)
                    .frame(width: 6, height: 6)
            }
            .foregroundStyle(WordDayStyle.accent)

            Text(entry.word.word.uppercased())
                .font(WordDayStyle.displayFont(size: 26))
                .fontWeight(.semibold)
                .tracking(-0.7)
                .foregroundStyle(WordDayStyle.ink)
                .minimumScaleFactor(0.5)
                .lineLimit(2)

            Text(entry.word.definition)
                .font(WordDayStyle.bodyFont(size: 11))
                .foregroundStyle(WordDayStyle.mutedInk)
                .lineLimit(3)
                .lineSpacing(1)

            Spacer(minLength: 0)

            Capsule()
                .fill(WordDayStyle.accent)
                .frame(width: 32, height: 3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var rectangularLockScreenWidget: some View {
        ZStack(alignment: .leading) {
            AccessoryWidgetBackground()

            HStack(spacing: 8) {
                WordDayOrbit(diameter: 30, lineWidth: 4)
                    .widgetAccentable()

                VStack(alignment: .leading, spacing: 1) {
                    HStack(spacing: 5) {
                        Text(entry.word.word.uppercased())
                            .font(.system(size: 15, weight: .black, design: .serif))
                            .minimumScaleFactor(0.65)
                            .lineLimit(1)

                        Text(entry.word.partOfSpeech.uppercased())
                            .font(.system(size: 7, weight: .bold, design: .rounded))
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(.secondary.opacity(0.28), in: Capsule())
                    }
                    .widgetAccentable()

                    Text(lockScreenClue)
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .foregroundStyle(.secondary)
                        .minimumScaleFactor(0.72)
                        .lineLimit(1)

                    Capsule()
                        .fill(.secondary.opacity(0.6))
                        .frame(width: 34, height: 2)
                }
            }
            .padding(.horizontal, 6)
        }
    }

    private var circularWidget: some View {
        ZStack {
            AccessoryWidgetBackground()

            VStack(spacing: 1) {
                Text(String(entry.word.word.prefix(1)).uppercased())
                    .font(.system(size: 24, weight: .black, design: .serif))
                    .minimumScaleFactor(0.7)

                Text(entry.word.partOfSpeech.prefix(4).uppercased())
                    .font(.system(size: 8, weight: .bold, design: .rounded))
                    .minimumScaleFactor(0.55)
                    .lineLimit(1)
            }
            .widgetAccentable()
        }
    }

    private var expandedWidget: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label(editionName, systemImage: editionSymbol)
                    .font(WordDayStyle.labelFont(size: 8))
                    .tracking(1.1)

                Spacer()

                Text(entry.date, format: .dateTime.weekday(.abbreviated).day())
                    .font(WordDayStyle.labelFont(size: 8))
                    .monospacedDigit()
            }
            .foregroundStyle(WordDayStyle.accent)

            Rectangle()
                .fill(WordDayStyle.rule)
                .frame(height: 1)

            Text(entry.word.word.uppercased())
                .font(WordDayStyle.displayFont(size: 31))
                .fontWeight(.semibold)
                .tracking(-0.8)
                .foregroundStyle(WordDayStyle.ink)
                .minimumScaleFactor(0.52)
                .lineLimit(1)

            HStack(spacing: 8) {
                Text(entry.word.pronunciation)
                Rectangle()
                    .fill(WordDayStyle.accent)
                    .frame(width: 18, height: 2)
                Text(entry.word.partOfSpeech.uppercased())
            }
            .font(WordDayStyle.labelFont(size: 8))
            .foregroundStyle(WordDayStyle.mutedInk)

            Text(entry.word.definition)
                .font(WordDayStyle.bodyFont(size: 14))
                .foregroundStyle(WordDayStyle.ink)
                .lineLimit(family == .systemLarge ? 4 : 2)
                .lineSpacing(2)

            if family == .systemLarge {
                Text("“\(entry.word.example)”")
                    .font(WordDayStyle.italicFont(size: 12))
                    .foregroundStyle(WordDayStyle.mutedInk)
                    .lineLimit(3)
                    .lineSpacing(2)
                    .padding(.top, 3)
            }

            Spacer(minLength: 0)

            HStack {
                Text("ONE WORD · TEN SECONDS")
                    .font(WordDayStyle.labelFont(size: 8))
                    .tracking(0.9)
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 9, weight: .bold))
            }
            .foregroundStyle(WordDayStyle.accent)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var widgetBackground: some View {
        ZStack {
            WordDayStyle.background
            WordDayOrbit(diameter: 145, lineWidth: 18)
                .offset(x: family == .systemSmall ? 88 : 148, y: -82)
                .opacity(0.72)
        }
    }

    private var editionName: String {
        colorScheme == .dark ? "NIGHT EDITION" : "DAY EDITION"
    }

    private var editionSymbol: String {
        colorScheme == .dark ? "moonphase.waning.crescent" : "sun.max.fill"
    }

    private var lockScreenClue: String {
        compactDefinition(entry.word.definition)
    }

    private func compactDefinition(_ definition: String) -> String {
        var text = definition
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: CharacterSet(charactersIn: "."))

        for prefix in ["A ", "An ", "The "] {
            if text.hasPrefix(prefix) {
                text.removeFirst(prefix.count)
                break
            }
        }

        let lowercased = text.lowercased()
        if lowercased.hasPrefix("subtle difference") {
            return "Subtle difference"
        }
        if lowercased.hasPrefix("the quality of being ") {
            text.removeFirst("The quality of being ".count)
        } else if lowercased.hasPrefix("quality of being ") {
            text.removeFirst("Quality of being ".count)
        } else if lowercased.hasPrefix("able to ") {
            text.removeFirst("Able to ".count)
        } else if lowercased.hasPrefix("using ") {
            text.removeFirst("Using ".count)
        }

        let separators = [",", ";", " or ", " and "]
        for separator in separators {
            if let range = text.range(of: separator, options: [.caseInsensitive]) {
                text = String(text[..<range.lowerBound])
                break
            }
        }

        return text.capitalizedWordPrefix(maxLength: 24)
    }
}

private extension String {
    func capitalizedWordPrefix(maxLength: Int) -> String {
        guard count > maxLength else { return capitalizedFirst }

        let words = split(separator: " ")
        var result = ""
        for word in words {
            let candidate = result.isEmpty ? String(word) : "\(result) \(word)"
            if candidate.count > maxLength { break }
            result = candidate
        }

        return (result.isEmpty ? String(prefix(maxLength)) : result).capitalizedFirst
    }

    var capitalizedFirst: String {
        guard let first else { return self }
        return first.uppercased() + dropFirst()
    }
}

struct WordDayWidget: Widget {
    let kind = "WordDayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WordProvider()) { entry in
            WordDayWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Word of the Day")
        .description("Learn one new word every day, right on your Home Screen.")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge,
            .accessoryInline,
            .accessoryCircular,
            .accessoryRectangular
        ])
    }
}

#Preview(as: .systemMedium) {
    WordDayWidget()
} timeline: {
    WordEntry(date: Date(), word: .placeholder)
}
