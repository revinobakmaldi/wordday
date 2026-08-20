import SwiftUI

@main
struct WordDayApp: App {
    @StateObject private var learned = LearnedStore.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(learned)
                .tint(WordDayStyle.accent)
        }
    }
}
