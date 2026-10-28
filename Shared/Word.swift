import Foundation

/// A reusable English chunk that sounds relaxed but well-read, at work or in daily conversation.
struct Phrase: Decodable, Identifiable, Hashable {
    let phrase: String
    let label: String
    let intent: String
    let meaning: String
    let example: String
    let usageExamples: [String]
    let variants: [String]
    let tone: String
    let avoidWhen: String?

    var id: String { phrase }

    var contextLabel: String {
        [label, intent].filter { !$0.isEmpty }.joined(separator: " · ")
    }

    var learningExamples: [String] {
        unique([example] + usageExamples)
    }

    var learningPhrases: [String] {
        variants.isEmpty ? defaultVariants : variants
    }

    var learningTip: String {
        meaning
    }

    var aiLearningPrompt: String {
        [
            "I am learning English that sounds casual but well-read, for work and everyday conversations.",
            "",
            "Please teach me how to naturally use this English chunk:",
            "",
            "\"\(phrase)\"",
            "",
            "Context: \(contextLabel)",
            "",
            "Explain the nuance, when to use it, when not to use it, common mistakes, 5 natural examples at work, 3 in everyday conversation, and a short practice exercise.",
            "",
            "If helpful, compare the nuance with Indonesian."
        ].joined(separator: "\n")
    }

    /// Compatibility aliases while the app shell keeps the original WordDay names.
    var word: String { phrase }
    var pronunciation: String { label }
    var partOfSpeech: String { intent }
    var definition: String { meaning }
    var commonPhrases: [String] { variants }
    var usageTip: String? { meaning }

    /// Shown when the bundled phrase list is missing or unreadable.
    static let placeholder = Phrase(
        phrase: "Take that with a grain of salt.",
        label: "Idiom",
        intent: "Doubt",
        meaning: "Don't fully trust it. Use it to signal doubt about a claim without calling it false.",
        example: "The survey had forty replies, so take that with a grain of salt.",
        usageExamples: [
            "He's selling the product, so take that with a grain of salt.",
            "It's one study. I'd take that with a grain of salt for now."
        ],
        variants: [
            "I wouldn't read too much into it.",
            "I'd be a little skeptical of that.",
            "That needs a caveat."
        ],
        tone: "Measured, skeptical, relaxed",
        avoidWhen: "Avoid it when the source is solid; it can sound dismissive of good evidence."
    )

    init(
        phrase: String,
        label: String,
        intent: String,
        meaning: String,
        example: String,
        usageExamples: [String] = [],
        variants: [String] = [],
        tone: String = "Natural",
        avoidWhen: String? = nil
    ) {
        self.phrase = phrase
        self.label = label
        self.intent = intent
        self.meaning = meaning
        self.example = example
        self.usageExamples = usageExamples
        self.variants = variants
        self.tone = tone
        self.avoidWhen = avoidWhen
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        phrase = try container.decodeFallback(String.self, forKeys: [.phrase, .word])
        label = try container.decodeFallback(String.self, forKeys: [.label, .pronunciation])
        intent = try container.decodeFallback(String.self, forKeys: [.intent, .partOfSpeech])
        meaning = try container.decodeFallback(String.self, forKeys: [.meaning, .definition])
        example = try container.decode(String.self, forKey: .example)
        usageExamples = try container.decodeIfPresent([String].self, forKey: .usageExamples) ?? []
        variants = try container.decodeFallbackIfPresent([String].self, forKeys: [.variants, .commonPhrases]) ?? []
        tone = try container.decodeIfPresent(String.self, forKey: .tone) ?? "Natural"
        avoidWhen = try container.decodeIfPresent(String.self, forKey: .avoidWhen)
    }

    private enum CodingKeys: String, CodingKey {
        case phrase
        case label
        case intent
        case meaning
        case example
        case usageExamples
        case variants
        case tone
        case avoidWhen

        case word
        case pronunciation
        case partOfSpeech
        case definition
        case commonPhrases
    }

    private var defaultVariants: [String] {
        [
            phrase,
            phrase.replacingOccurrences(of: ".", with: ""),
            "I would say: \(phrase.lowercased())"
        ]
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

typealias Word = Phrase

private extension KeyedDecodingContainer {
    func decodeFallback<T: Decodable>(_ type: T.Type, forKeys keys: [Key]) throws -> T {
        for key in keys {
            if let value = try decodeIfPresent(type, forKey: key) {
                return value
            }
        }
        throw DecodingError.keyNotFound(
            keys[0],
            DecodingError.Context(
                codingPath: codingPath,
                debugDescription: "Missing one of: \(keys.map(\.stringValue).joined(separator: ", "))"
            )
        )
    }

    func decodeFallbackIfPresent<T: Decodable>(_ type: T.Type, forKeys keys: [Key]) throws -> T? {
        for key in keys {
            if let value = try decodeIfPresent(type, forKey: key) {
                return value
            }
        }
        return nil
    }
}
