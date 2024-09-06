import SwiftUI

class PopularMoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let movieService = MovieService()

    func fetchPopularMovies() {
        guard movies.isEmpty else {
            print("Movies already loaded, skipping fetch.")
            return
        }

        print("fetchPopularMovies called.")
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedMovies = try await movieService.fetchPopularMovies()
                DispatchQueue.main.async {
                    self.movies = fetchedMovies
                    self.isLoading = false
                }
            } catch let error as NetworkError {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "An unexpected error occurred."
                    self.isLoading = false
                }
            }
        }
    }
}

