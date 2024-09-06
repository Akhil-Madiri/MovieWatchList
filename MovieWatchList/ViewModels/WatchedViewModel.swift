import SwiftUI

class WatchedViewModel: ObservableObject {
    @Published var watchedMovies: [Movie] = []
    @Published var errorMessage: String?

    private let movieStorage = MovieStorage()

    func loadWatchedMovies() {
        movieStorage.loadMovies()
        watchedMovies = movieStorage.watchedMovies

        if watchedMovies.isEmpty {
            errorMessage = "No watched movies found."
        } else {
            errorMessage = nil
        }
    }
}
