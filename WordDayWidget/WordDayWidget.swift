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
            Text("\(entry.word.phrase) · \(entry.word.intent)")

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
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(entry.word.contextLabel.uppercased())
                    .font(WordDayStyle.labelFont(size: 7))
                    .tracking(0.65)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Spacer()
                Circle()
                    .fill(WordDayStyle.accent)
                    .frame(width: 6, height: 6)
            }
            .foregroundStyle(WordDayStyle.accent)

            Text(entry.word.phrase)
                .font(WordDayStyle.displayFont(size: 28))
                .fontWeight(.semibold)
                .foregroundStyle(WordDayStyle.ink)
                .minimumScaleFactor(0.52)
                .lineLimit(4)
                .allowsTightening(true)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var rectangularLockScreenWidget: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 7, style: .continuous)
                .fill(.primary.opacity(colorScheme == .dark ? 0.18 : 0.10))

            RoundedRectangle(cornerRadius: 7, style: .continuous)
                .strokeBorder(.primary.opacity(0.24), lineWidth: 1)

            HStack(spacing: 7) {
                Capsule()
                    .fill(.primary.opacity(0.72))
                    .frame(width: 3)
                    .widgetAccentable()

                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.word.phrase)
                        .font(.system(size: 13.4, weight: .black, design: .serif))
                        .minimumScaleFactor(0.66)
                        .lineLimit(1)
                        .widgetAccentable()

                    Text(entry.word.contextLabel.uppercased())
                        .font(.system(size: 9.2, weight: .semibold, design: .rounded))
                        .foregroundStyle(.secondary)
                        .lineSpacing(0)
                        .minimumScaleFactor(0.82)
                        .allowsTightening(true)
                        .lineLimit(2)
                }
            }
            .padding(.horizontal, 7)
            .padding(.vertical, 4)
        }
    }

    private var circularWidget: some View {
        ZStack {
            AccessoryWidgetBackground()

            VStack(spacing: 1) {
                Text("\"")
                    .font(.system(size: 25, weight: .black, design: .serif))
                    .minimumScaleFactor(0.7)

                Text(entry.word.intent.prefix(5).uppercased())
                    .font(.system(size: 7, weight: .bold, design: .rounded))
                    .minimumScaleFactor(0.55)
                    .lineLimit(1)
            }
            .widgetAccentable()
        }
    }

    private var expandedWidget: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(entry.word.contextLabel.uppercased())
                    .font(WordDayStyle.labelFont(size: 7))
                    .tracking(0.8)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)

                Spacer()

                Text(entry.date, format: .dateTime.weekday(.abbreviated).day())
                    .font(WordDayStyle.labelFont(size: 7))
                    .monospacedDigit()
            }
            .foregroundStyle(WordDayStyle.accent)

            Rectangle()
                .fill(WordDayStyle.rule)
                .frame(height: 1)

            Text(entry.word.phrase)
                .font(WordDayStyle.displayFont(size: family == .systemLarge ? 36 : 30))
                .fontWeight(.semibold)
                .foregroundStyle(WordDayStyle.ink)
                .minimumScaleFactor(0.56)
                .lineLimit(family == .systemLarge ? 3 : 2)
                .allowsTightening(true)

            Text(entry.word.meaning)
                .font(WordDayStyle.bodyFont(size: 14))
                .foregroundStyle(WordDayStyle.ink)
                .lineLimit(family == .systemLarge ? 4 : 2)
                .lineSpacing(2)

            if family == .systemLarge {
                Text("\"\(entry.word.example)\"")
                    .font(WordDayStyle.italicFont(size: 12))
                    .foregroundStyle(WordDayStyle.mutedInk)
                    .lineLimit(3)
                    .lineSpacing(2)
                    .padding(.top, 3)
            }

            Spacer(minLength: 0)

            HStack {
                Text(family == .systemLarge ? "ONE CHUNK · PRACTICE TODAY" : "ONE CHUNK · TEN SECONDS")
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

}

struct WordDayWidget: Widget {
    let kind = "WordDayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WordProvider()) { entry in
            WordDayWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Daily English Chunk")
        .description("Practice one useful English phrase every day, right on your Home Screen.")
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
