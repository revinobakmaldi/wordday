import Foundation
import SwiftUI

struct BrowseView: View {
    @EnvironmentObject private var learned: LearnedStore
    @State private var query = ""
    @State private var showLearnedOnly = false

    private var results: [Word] {
        WordLibrary.all
            .filter { !showLearnedOnly || learned.isLearned($0) }
            .filter { word in
                guard !query.isEmpty else { return true }
                return word.phrase.localizedCaseInsensitiveContains(query)
                    || word.label.localizedCaseInsensitiveContains(query)
                    || word.intent.localizedCaseInsensitiveContains(query)
                    || word.meaning.localizedCaseInsensitiveContains(query)
                    || word.example.localizedCaseInsensitiveContains(query)
                    || word.tone.localizedCaseInsensitiveContains(query)
                    || word.learningTip.localizedCaseInsensitiveContains(query)
                    || word.learningExamples.contains { $0.localizedCaseInsensitiveContains(query) }
                    || word.learningPhrases.contains { $0.localizedCaseInsensitiveContains(query) }
            }
            .sorted { $0.word < $1.word }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    if results.isEmpty {
                        emptyState
                            .listRowInsets(EdgeInsets(top: 30, leading: 20, bottom: 30, trailing: 20))
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    } else {
                        ForEach(results) { word in
                            NavigationLink(value: word) {
                                ArchiveRow(
                                    word: word,
                                    number: (WordLibrary.all.firstIndex(of: word) ?? 0) + 1,
                                    isLearned: learned.isLearned(word)
                                )
                            }
                            .buttonStyle(.plain)
                            .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 14))
                            .listRowBackground(Color.clear)
                            .listRowSeparatorTint(WordDayStyle.rule)
                        }
                    }
                } header: {
                    HStack {
                        Text(showLearnedOnly ? "SAVED" : "PHRASE BANK")
                        Spacer()
                        Text("\(results.count) CHUNKS")
                            .monospacedDigit()
                    }
                    .font(WordDayStyle.labelFont(size: 9))
                    .tracking(1.25)
                    .foregroundStyle(WordDayStyle.mutedInk)
                    .padding(.vertical, 10)
                    .textCase(nil)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background {
                ZStack(alignment: .topTrailing) {
                    WordDayStyle.background
                    WordDayOrbit(diameter: 170, lineWidth: 21)
                        .offset(x: 100, y: -90)
                        .opacity(0.55)
                }
                .ignoresSafeArea()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Word.self) { word in
                WordDetailView(word: word, isLearned: learned.isLearned(word))
            }
            .searchable(text: $query, prompt: "Find a phrase or situation")
            .toolbarBackground(WordDayStyle.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("ARCHIVE")
                        .font(WordDayStyle.labelFont(size: 13))
                        .tracking(2.3)
                        .foregroundStyle(WordDayStyle.ink)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showLearnedOnly.toggle()
                    } label: {
                        Image(systemName: showLearnedOnly ? "checkmark.circle.fill" : "circle.grid.2x2")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(showLearnedOnly ? WordDayStyle.success : WordDayStyle.accent)
                            .frame(width: 44, height: 44)
                    }
                    .accessibilityLabel(showLearnedOnly ? "Show all chunks" : "Show saved chunks only")
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 11) {
            Text(showLearnedOnly ? "YOUR BANK IS WAITING" : "NOT IN THIS EDITION")
                .font(WordDayStyle.labelFont(size: 9))
                .tracking(1.2)
                .foregroundStyle(WordDayStyle.accent)

            Text(showLearnedOnly ? "Save your first chunk." : "Try another search.")
                .font(WordDayStyle.displayFont(size: 28))
                .foregroundStyle(WordDayStyle.ink)

            Text(showLearnedOnly
                 ? "Open Today and save the phrase if it belongs in your speaking toolkit."
                 : "Search by phrase, situation, intent, or example.")
                .font(WordDayStyle.bodyFont(size: 15))
                .lineSpacing(3)
                .foregroundStyle(WordDayStyle.mutedInk)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct ArchiveRow: View {
    let word: Word
    let number: Int
    let isLearned: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Text(String(format: "%02d", number))
                .font(WordDayStyle.labelFont(size: 9))
                .monospacedDigit()
                .foregroundStyle(WordDayStyle.mutedInk)
                .padding(.top, 5)
                .frame(width: 24, alignment: .leading)

            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(word.phrase)
                        .font(WordDayStyle.displayFont(size: 20))
                        .foregroundStyle(WordDayStyle.ink)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                        .accessibilityLabel(word.phrase)

                    Text(word.contextLabel.uppercased())
                        .font(WordDayStyle.labelFont(size: 8))
                        .tracking(0.6)
                        .foregroundStyle(WordDayStyle.accent)
                        .lineLimit(1)
                }

                Text(word.meaning)
                    .font(WordDayStyle.bodyFont(size: 13))
                    .lineSpacing(2)
                    .foregroundStyle(WordDayStyle.mutedInk)
                    .lineLimit(2)
            }

            Spacer(minLength: 8)

            if isLearned {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(WordDayStyle.success)
                    .padding(.top, 5)
                    .accessibilityLabel("Collected")
            }
        }
        .padding(.vertical, 15)
    }
}

private struct WordDetailView: View {
    let word: Word
    let isLearned: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 26) {
                WordCard(word: word, trailingLabel: "BANK")
                LearningGuideView(word: word)

                if isLearned {
                    Label("SAVED TO YOUR BANK", systemImage: "checkmark.circle.fill")
                        .font(WordDayStyle.labelFont(size: 10))
                        .tracking(1.05)
                        .foregroundStyle(WordDayStyle.success)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 30)
        }
        .scrollIndicators(.hidden)
        .background {
            ZStack(alignment: .topTrailing) {
                WordDayStyle.background
                WordDayOrbit(diameter: 170, lineWidth: 21)
                    .offset(x: 96, y: -84)
                    .opacity(0.55)
            }
            .ignoresSafeArea()
        }
        .navigationTitle(word.phrase)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(WordDayStyle.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview("After Dark") {
    BrowseView()
        .environmentObject(LearnedStore.shared)
        .preferredColorScheme(.dark)
}

#Preview("After Dawn") {
    BrowseView()
        .environmentObject(LearnedStore.shared)
        .preferredColorScheme(.light)
}
