import Foundation

/// A single vocabulary entry, decoded from `words.json`.
struct Word: Codable, Identifiable, Hashable {
    let word: String
    let pronunciation: String
    let partOfSpeech: String
    let definition: String
    let example: String
    let usageExamples: [String]
    let commonPhrases: [String]
    let usageTip: String?

    var id: String { word }

    var learningExamples: [String] {
        unique([example] + usageExamples)
    }

    var learningPhrases: [String] {
        commonPhrases.isEmpty ? defaultCommonPhrases : commonPhrases
    }

    var learningTip: String {
        usageTip ?? defaultUsageTip
    }

    /// Shown when the bundled word list is missing or unreadable.
    static let placeholder = Word(
        word: "lexicon",
        pronunciation: "LEK-si-kon",
        partOfSpeech: "noun",
        definition: "The vocabulary of a person, language, or branch of knowledge.",
        example: "Every day the widget adds one more entry to your lexicon.",
        usageExamples: [
            "Her technical lexicon grew every time she shipped a new feature.",
            "The team's shared lexicon made the strategy easier to discuss."
        ],
        commonPhrases: ["personal lexicon", "shared lexicon", "technical lexicon"],
        usageTip: "Use it when talking about the set of words a person, field, or group commonly uses."
    )

    init(
        word: String,
        pronunciation: String,
        partOfSpeech: String,
        definition: String,
        example: String,
        usageExamples: [String] = [],
        commonPhrases: [String] = [],
        usageTip: String? = nil
    ) {
        self.word = word
        self.pronunciation = pronunciation
        self.partOfSpeech = partOfSpeech
        self.definition = definition
        self.example = example
        self.usageExamples = usageExamples
        self.commonPhrases = commonPhrases
        self.usageTip = usageTip
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        word = try container.decode(String.self, forKey: .word)
        pronunciation = try container.decode(String.self, forKey: .pronunciation)
        partOfSpeech = try container.decode(String.self, forKey: .partOfSpeech)
        definition = try container.decode(String.self, forKey: .definition)
        example = try container.decode(String.self, forKey: .example)
        usageExamples = try container.decodeIfPresent([String].self, forKey: .usageExamples) ?? []
        commonPhrases = try container.decodeIfPresent([String].self, forKey: .commonPhrases) ?? []
        usageTip = try container.decodeIfPresent(String.self, forKey: .usageTip)
    }

    private enum CodingKeys: String, CodingKey {
        case word
        case pronunciation
        case partOfSpeech
        case definition
        case example
        case usageExamples
        case commonPhrases
        case usageTip
    }

    private var defaultCommonPhrases: [String] {
        switch partOfSpeech.lowercased() {
        case "verb":
            return ["to \(word)", "\(word) the issue", "help \(word)"]
        case "noun":
            return ["a sense of \(word)", "the \(word) of", "\(word) in practice"]
        case "adverb":
            return ["act \(word)", "speak \(word)", "move \(word)"]
        default:
            return ["\(word) approach", "\(word) tone", "remain \(word)"]
        }
    }

    private var defaultUsageTip: String {
        switch partOfSpeech.lowercased() {
        case "verb":
            return "Use it as an action word; it usually works best near the person or thing receiving the action."
        case "noun":
            return "Use it to name a concept, condition, event, or quality; it often pairs well with 'of' or 'in'."
        case "adverb":
            return "Use it to describe how an action happens; place it near the verb it modifies."
        default:
            return "Use it before a noun or after linking verbs like 'seems', 'feels', or 'remains'."
        }
    }

    private func unique(_ values: [String]) -> [String] {
        var seen: Set<String> = []
        return values.filter { value in
            let normalized = value.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !normalized.isEmpty, !seen.contains(normalized) else { return false }
            seen.insert(normalized)
            return true
        }
    }
}
