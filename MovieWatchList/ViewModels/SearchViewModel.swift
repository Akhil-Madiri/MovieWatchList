import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let movieService = MovieService()

    func performSearch() {
        guard !searchText.isEmpty else {
            errorMessage = "Please enter a search term."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let searchedMovies = try await movieService.searchMovies(query: searchText)
                DispatchQueue.main.async {
                    self.movies = searchedMovies
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
