import SwiftUI

class MovieDetailViewModel: ObservableObject {
    @Published var isInWatchlist: Bool = false
    @Published var isWatched: Bool = false
    private let movieStorage = MovieStorage()
    
    // Load the movie status from storage (watchlist/watched)
    func loadMovieStatus(for movie: Movie) {
        self.isInWatchlist = movieStorage.isInWatchlist(movie)
        self.isWatched = movieStorage.isWatched(movie)
    }
    
    // Add the movie to the watchlist
    func addToWatchlist(_ movie: Movie) {
        guard !isInWatchlist else { return }
        movieStorage.saveMovie(movie, toWatchlist: true)
        isInWatchlist = true
    }

    // Remove the movie from the watchlist
    func removeFromWatchlist(_ movie: Movie) {
        guard isInWatchlist else { return }
        movieStorage.removeMovieFromWatchlist(movie)
        isInWatchlist = false
    }
    
    // Mark the movie as watched and remove it from the watchlist
    func markAsWatched(_ movie: Movie) {
        guard !isWatched else { return }
        movieStorage.markMovieAsWatched(movie)
        isWatched = true
        isInWatchlist = false 
    }
}
