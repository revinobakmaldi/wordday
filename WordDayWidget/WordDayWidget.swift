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
    var entry: WordEntry

    var body: some View {
        switch family {
        case .accessoryInline:
            Text("\(entry.word.word) · \(entry.word.partOfSpeech)")

        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.word.word).font(.headline)
                Text(entry.word.definition)
                    .font(.caption2)
                    .lineLimit(2)
            }

        case .systemSmall:
            VStack(alignment: .leading, spacing: 6) {
                Text("WORD OF THE DAY")
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundStyle(.secondary)
                Text(entry.word.word)
                    .font(.system(.title3, design: .serif, weight: .bold))
                    .minimumScaleFactor(0.6)
                    .lineLimit(2)
                Text(entry.word.definition)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .containerBackground(for: .widget) { background }

        default:
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("WORD OF THE DAY")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(entry.date, format: .dateTime.weekday(.abbreviated).day())
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                Text(entry.word.word)
                    .font(.system(.title, design: .serif, weight: .bold))
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)

                Text("\(entry.word.pronunciation) · \(entry.word.partOfSpeech)")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(entry.word.definition)
                    .font(.callout)
                    .lineLimit(family == .systemLarge ? 4 : 2)

                if family == .systemLarge {
                    Text("\u{201C}\(entry.word.example)\u{201D}")
                        .font(.caption)
                        .italic()
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                }
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .containerBackground(for: .widget) { background }
        }
    }

    private var background: some View {
        LinearGradient(
            colors: [Color(.systemBackground), Color.accentColor.opacity(0.18)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
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
            .accessoryRectangular
        ])
    }
}

#Preview(as: .systemMedium) {
    WordDayWidget()
} timeline: {
    WordEntry(date: Date(), word: .placeholder)
}
