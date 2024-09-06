import SwiftUI

struct PopularMoviesView: View {
    @StateObject private var viewModel = PopularMoviesViewModel()
    
    var body: some View {
        NavigationView {
            if viewModel.isLoading {
                ProgressView("Loading movies...")
                    .padding()
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                .padding() } else {
                    List(viewModel.movies) { movie in
                        NavigationLink(destination: MovieDetailView(movie: movie)) {
                            HStack {
                                if let posterPath = movie.posterPath {
                                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)")) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(movie.title)
                                        .font(.headline)
                                    Text(movie.genreNames.joined(separator: ", "))
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text(String(format: "Rating: %.1f", movie.rating))
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text(movie.overview)
                                        .font(.body)
                                        .lineLimit(3)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 10)
                        }
                    }
                    .navigationTitle("Popular Movies")  
                    .onAppear {
                        viewModel.fetchPopularMovies()
                    }
                }
        }
    }
}
