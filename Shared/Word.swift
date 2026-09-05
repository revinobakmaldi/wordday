import Foundation

/// A reusable English chunk for daily and business conversation.
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

    /// Compatibility aliases while the app shell keeps the original WordDay names.
    var word: String { phrase }
    var pronunciation: String { label }
    var partOfSpeech: String { intent }
    var definition: String { meaning }
    var commonPhrases: [String] { variants }
    var usageTip: String? { meaning }

    /// Shown when the bundled phrase list is missing or unreadable.
    static let placeholder = Phrase(
        phrase: "Let me make sure I understand.",
        label: "Business",
        intent: "Clarify",
        meaning: "Use this before responding, so you can confirm the point without sounding hesitant.",
        example: "Let me make sure I understand. The main concern is the timeline, right?",
        usageExamples: [
            "Let me make sure I understand before we decide.",
            "Let me make sure I understand the constraint first."
        ],
        variants: [
            "Just to make sure I got this right...",
            "So what you're saying is...",
            "Let me restate that quickly."
        ],
        tone: "Calm, professional, careful",
        avoidWhen: "Avoid overusing it when the point is already obvious."
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
