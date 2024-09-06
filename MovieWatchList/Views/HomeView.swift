import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            PopularMoviesView()
                .tabItem {
                    Image(systemName: "film")
                    Text("Popular")
                }

            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }

            WatchlistView()
                .tabItem {
                    Image(systemName: "bookmark")
                    Text("Watchlist")
                }

            WatchedView()
                .tabItem {
                    Image(systemName: "eye")
                    Text("Watched")
                }
        }
    }
}
