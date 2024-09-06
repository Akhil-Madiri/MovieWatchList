import SwiftUI

struct MovieDetailView: View {
    @StateObject private var viewModel = MovieDetailViewModel()
    let movie: Movie
    
    var body: some View {
        VStack {
            // Movie Poster
            if let posterPath = movie.posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 300)
                } placeholder: {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 300)
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 300)
            }
            
            // Movie Title
            Text(movie.title)
                .font(.title)
                .padding(.top)
            
            // Movie Overview
            Text(movie.overview)
                .font(.body)
                .padding(.top)
            
            HStack(spacing: 20) {
                if viewModel.isInWatchlist {
                    // Remove from Watchlist Button
                    Button(action: {
                        viewModel.removeFromWatchlist(movie)
                    }) {
                        Text("Remove from Watchlist")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                } else {
                    // Add to Watchlist Button
                    Button(action: {
                        viewModel.addToWatchlist(movie)
                    }) {
                        Text("Add to Watchlist")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }

                // Mark as Watched Button
                Button(action: {
                    viewModel.markAsWatched(movie)
                }) {
                    Text(viewModel.isWatched ? "Marked as Watched" : "Mark as Watched")
                        .padding()
                        .background(viewModel.isWatched ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(viewModel.isWatched) // Disable if already marked
            }
            .padding(.top)
        }
        .onAppear {
            viewModel.loadMovieStatus(for: movie) // Reload movie status on every view appearance
        }
    }
}
