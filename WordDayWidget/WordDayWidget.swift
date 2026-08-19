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
        switch family {
        case .accessoryInline:
            Text("\(entry.word.word) · \(entry.word.partOfSpeech)")

        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.word.word.uppercased())
                    .font(.headline)
                    .widgetAccentable()
                Text(entry.word.definition)
                    .font(.caption2)
                    .lineLimit(2)
            }

        case .systemSmall:
            smallWidget
                .containerBackground(for: .widget) { widgetBackground }

        default:
            expandedWidget
                .containerBackground(for: .widget) { widgetBackground }
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
