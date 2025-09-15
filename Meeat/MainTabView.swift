import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            RankingTab()
                .tabItem {
                    Image(systemName: "flame.fill")
                    Text("Ranking")
                }
            ExploreTab()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Home")
                }
            InviteTab()
                .tabItem {
                    Image(systemName: "envelope.open.fill")
                    Text("Invites")
                }
        }
    }
}

struct RankingTab: View {
    var body: some View {
        RankingSheetView()
    }
}

struct ExploreTab: View {
    var body: some View {
        MainHomeView()
    }
}

struct InviteTab: View {
    var body: some View {
        InviteListSheetView()
    }
} 