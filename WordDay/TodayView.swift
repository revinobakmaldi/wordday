import SwiftUI

struct TodayView: View {
    @EnvironmentObject private var learned: LearnedStore

    private let today = Date()

    private var word: Word { WordLibrary.word(for: today) }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    WordCard(word: word)
                    learnedButton
                    upcomingPreview
                }
                .padding(20)
            }
            .navigationTitle("Word of the Day")
            .background(Color(.systemGroupedBackground))
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(today, format: .dateTime.weekday(.wide).day().month(.wide))
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text("\(learned.learned.count) of \(WordLibrary.all.count) learned")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
    }

    private var learnedButton: some View {
        Button {
            withAnimation { learned.toggle(word) }
        } label: {
            Label(
                learned.isLearned(word) ? "Learned" : "Mark as learned",
                systemImage: learned.isLearned(word) ? "checkmark.circle.fill" : "circle"
            )
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
        }
        .buttonStyle(.borderedProminent)
        .tint(learned.isLearned(word) ? .green : .accentColor)
    }

    private var upcomingPreview: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Coming up")
                .font(.headline)

            ForEach(Array(WordLibrary.upcoming(from: today, count: 4).dropFirst())) { entry in
                HStack {
                    Text(entry.date, format: .dateTime.weekday(.abbreviated).day())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(width: 60, alignment: .leading)
                    Text(entry.word.word)
                        .font(.body)
                        .redacted(reason: .placeholder)
                    Spacer()
                }
            }
            Text("No peeking — one word a day.")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
    }
}

/// The main card: word, pronunciation, definition, example.
struct WordCard: View {
    let word: Word

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(word.word)
                .font(.system(.largeTitle, design: .serif, weight: .bold))

            HStack(spacing: 8) {
                Text(word.pronunciation)
                Text("·")
                Text(word.partOfSpeech).italic()
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)

            Divider()

            Text(word.definition)
                .font(.body)

            Text("\u{201C}\(word.example)\u{201D}")
                .font(.callout)
                .italic()
                .foregroundStyle(.secondary)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    TodayView().environmentObject(LearnedStore.shared)
}
