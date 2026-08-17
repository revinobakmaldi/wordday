import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem { Label("Today", systemImage: "sun.max") }

            BrowseView()
                .tabItem { Label("Browse", systemImage: "list.bullet") }
        }
    }
}

#Preview {
    RootView().environmentObject(LearnedStore.shared)
}
