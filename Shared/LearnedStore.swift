import Foundation
import WidgetKit

/// Tracks which words you've marked as learned.
///
/// Backed by the shared App Group container so the app and the widget extension
/// read and write the same data.
final class LearnedStore: ObservableObject {
    /// Must match the App Group in both `.entitlements` files.
    static let appGroupID = "group.com.revinobakmaldi.wordday"

    static let shared = LearnedStore()

    private let defaults: UserDefaults
    private let key = "learnedWords"

    @Published private(set) var learned: Set<String>

    init(defaults: UserDefaults? = nil) {
        let store = defaults ?? UserDefaults(suiteName: Self.appGroupID) ?? .standard
        self.defaults = store
        self.learned = Set(store.stringArray(forKey: key) ?? [])
    }

    func isLearned(_ word: Word) -> Bool {
        learned.contains(word.id)
    }

    func toggle(_ word: Word) {
        if learned.contains(word.id) {
            learned.remove(word.id)
        } else {
            learned.insert(word.id)
        }
        persist()
    }

    private func persist() {
        defaults.set(Array(learned), forKey: key)
        WidgetCenter.shared.reloadAllTimelines()
    }
}
