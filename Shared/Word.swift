import Foundation

/// A single vocabulary entry, decoded from `words.json`.
struct Word: Codable, Identifiable, Hashable {
    let word: String
    let pronunciation: String
    let partOfSpeech: String
    let definition: String
    let example: String

    var id: String { word }

    /// Shown when the bundled word list is missing or unreadable.
    static let placeholder = Word(
        word: "lexicon",
        pronunciation: "LEK-si-kon",
        partOfSpeech: "noun",
        definition: "The vocabulary of a person, language, or branch of knowledge.",
        example: "Every day the widget adds one more entry to your lexicon."
    )
}
