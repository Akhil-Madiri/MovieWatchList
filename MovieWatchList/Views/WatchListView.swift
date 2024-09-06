import SwiftUI

struct WatchlistView: View {
    @StateObject private var viewModel = WatchlistViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.watchlist.isEmpty {
                    Text("No movies in watchlist")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(viewModel.watchlist) { movie in
                        HStack {
                            if let posterPath = movie.posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 150)
                                } placeholder: {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 150)
                                }
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 150)
                            }
                            
                            // Movie Information
                            VStack(alignment: .leading) {
                                Text(movie.title)
                                    .font(.headline)
                                Text("Rating: \(String(format: "%.1f", movie.rating))")
                                    .font(.subheadline)
                                Text(movie.overview)
                                    .font(.body)
                                    .lineLimit(3)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Watchlist")
            .onAppear {
                viewModel.loadWatchlist() 
            }
        }
    }
}
