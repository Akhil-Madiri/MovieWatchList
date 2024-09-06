import Foundation

class MovieStorage: ObservableObject {
    @Published private(set) var watchlist: [Movie] = []
    @Published private(set) var watchedMovies: [Movie] = []

    init() {
        loadMovies()
    }

    // Save a movie to the watchlist
    func saveMovie(_ movie: Movie, toWatchlist: Bool) {
        if toWatchlist && !watchlist.contains(where: { $0.id == movie.id }) {
            watchlist.append(movie)
            saveToStorage()
        }
    }
    
    // Remove a movie from the watchlist
    func removeMovieFromWatchlist(_ movie: Movie) {
        if let index = watchlist.firstIndex(where: { $0.id == movie.id }) {
            watchlist.remove(at: index)
            saveToStorage()
        }
    }
    
    // Mark a movie as watched
    func markMovieAsWatched(_ movie: Movie) {
        if !watchedMovies.contains(where: { $0.id == movie.id }) {
            watchedMovies.append(movie)
            saveToStorage()
            
            if let index = watchlist.firstIndex(where: { $0.id == movie.id }) {
                watchlist.remove(at: index)
                saveToStorage()
            }
        }
    }

    // Check if the movie is in the watchlist
    func isInWatchlist(_ movie: Movie) -> Bool {
        return watchlist.contains(where: { $0.id == movie.id })
    }
    
    // Check if the movie is marked as watched
    func isWatched(_ movie: Movie) -> Bool {
        return watchedMovies.contains(where: { $0.id == movie.id })
    }

    private func saveToStorage() {
        if let encodedWatchlist = try? JSONEncoder().encode(watchlist) {
            UserDefaults.standard.set(encodedWatchlist, forKey: "watchlist")
        }
        if let encodedWatchedMovies = try? JSONEncoder().encode(watchedMovies) {
            UserDefaults.standard.set(encodedWatchedMovies, forKey: "watchedMovies")
        }
    }

    func loadMovies() {
        if let savedWatchlist = UserDefaults.standard.data(forKey: "watchlist"),
           let decodedWatchlist = try? JSONDecoder().decode([Movie].self, from: savedWatchlist) {
            self.watchlist = decodedWatchlist
        }
        if let savedWatchedMovies = UserDefaults.standard.data(forKey: "watchedMovies"),
           let decodedWatchedMovies = try? JSONDecoder().decode([Movie].self, from: savedWatchedMovies) {
            self.watchedMovies = decodedWatchedMovies
        }
    }
}
