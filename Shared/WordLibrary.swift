import Foundation

/// A word paired with the day it belongs to.
struct DayWord: Identifiable, Hashable {
    let date: Date
    let word: Word

    var id: Date { date }
}

/// Loads the bundled word list and maps calendar days onto it.
///
/// The mapping is deterministic: the same day always resolves to the same word,
/// in the app and in the widget, without any shared state or network call.
enum WordLibrary {
    static let all: [Word] = load()

    /// The word for a given day.
    static func word(for date: Date, calendar: Calendar = .current) -> Word {
        guard !all.isEmpty else { return .placeholder }
        return all[index(for: date, calendar: calendar)]
    }

    /// How far into the list a given day falls — used for "day 12 of 60" style labels.
    static func index(for date: Date, calendar: Calendar = .current) -> Int {
        guard !all.isEmpty else { return 0 }
        let startOfDay = calendar.startOfDay(for: date)
        let dayNumber = Int(floor(startOfDay.timeIntervalSince1970 / 86_400))
        return ((dayNumber % all.count) + all.count) % all.count
    }

    /// The next `count` days, starting today. The widget builds its timeline from this.
    static func upcoming(from date: Date = Date(), count: Int, calendar: Calendar = .current) -> [DayWord] {
        let startOfDay = calendar.startOfDay(for: date)
        return (0..<count).compactMap { offset in
            guard let day = calendar.date(byAdding: .day, value: offset, to: startOfDay) else { return nil }
            return DayWord(date: day, word: word(for: day, calendar: calendar))
        }
    }

    private static func load() -> [Word] {
        guard let url = Bundle.main.url(forResource: "words", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let words = try? JSONDecoder().decode([Word].self, from: data),
              !words.isEmpty
        else {
            return [.placeholder]
        }
        return words
    }
}
