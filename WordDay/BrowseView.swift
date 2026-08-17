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
                return word.word.localizedCaseInsensitiveContains(query)
                    || word.definition.localizedCaseInsensitiveContains(query)
            }
            .sorted { $0.word < $1.word }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(results) { word in
                    NavigationLink(value: word) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(word.word).font(.body.weight(.medium))
                                Text(word.definition)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                            Spacer()
                            if learned.isLearned(word) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            }
                        }
                    }
                }
            }
            .navigationTitle("All Words")
            .navigationDestination(for: Word.self) { word in
                ScrollView {
                    WordCard(word: word).padding(20)
                }
                .background(Color(.systemGroupedBackground))
                .navigationBarTitleDisplayMode(.inline)
            }
            .searchable(text: $query, prompt: "Search words")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showLearnedOnly.toggle()
                    } label: {
                        Image(systemName: showLearnedOnly ? "checkmark.circle.fill" : "checkmark.circle")
                    }
                    .accessibilityLabel(showLearnedOnly ? "Show all words" : "Show learned words only")
                }
            }
        }
    }
}

#Preview {
    BrowseView().environmentObject(LearnedStore.shared)
}
