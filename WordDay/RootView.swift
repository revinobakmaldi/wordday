import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem { Label("Today", systemImage: "circle.inset.filled") }

            BrowseView()
                .tabItem { Label("Archive", systemImage: "rectangle.stack.fill") }
        }
        .tint(WordDayStyle.accent)
        .toolbarBackground(WordDayStyle.surface, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}

#Preview {
    RootView().environmentObject(LearnedStore.shared)
}
