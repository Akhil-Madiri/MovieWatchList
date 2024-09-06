import SwiftUI

class WatchlistViewModel: ObservableObject {
    @Published var watchlist: [Movie] = []
    @Published var errorMessage: String?

    private let movieStorage = MovieStorage()

    func loadWatchlist() {
        movieStorage.loadMovies()
        watchlist = movieStorage.watchlist

        if watchlist.isEmpty {
            errorMessage = "No movies found in the watchlist."
        } else {
            errorMessage = nil
        }
    }

    func markMovieAsWatched(_ movie: Movie) {
        movieStorage.markMovieAsWatched(movie)
        loadWatchlist() 
    }
}
