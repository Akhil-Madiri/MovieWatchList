import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar at the Top
                HStack(spacing: 10) {
                    TextField("Search Movies", text: $viewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading, 10)
                        .frame(height: 44)

                    Button(action: {
                        viewModel.performSearch()
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Divider()

                
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Searching...")
                        .padding()
                    Spacer()
                } else if let errorMessage = viewModel.errorMessage {
                    Spacer()
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                    Spacer()
                } else if viewModel.movies.isEmpty && !viewModel.searchText.isEmpty {
                    Spacer()
                    Text("No results found")
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(viewModel.movies) { movie in
                                NavigationLink(destination: MovieDetailView(movie: movie)) {
                                    HStack(alignment: .top, spacing: 15) {
                                        if let posterPath = movie.posterPath {
                                            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)")) { phase in
                                                switch phase {
                                                case .empty:
                                                    ProgressView()
                                                        .frame(width: 100, height: 150)
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 100, height: 150)
                                                        .cornerRadius(8)
                                                case .failure:
                                                    Image(systemName: "photo")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 100, height: 150)
                                                        .foregroundColor(.gray)
                                                        .cornerRadius(8)
                                                @unknown default:
                                                    Image(systemName: "photo")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 100, height: 150)
                                                        .foregroundColor(.gray)
                                                        .cornerRadius(8)
                                                }
                                            }
                                        } else {
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 150)
                                                .foregroundColor(.gray)
                                                .cornerRadius(8)
                                        }

                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(movie.title)
                                                .font(.headline)

                                            if !movie.genreNames.isEmpty {
                                                Text(movie.genreNames.joined(separator: ", "))
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                            } else {
                                                Text("Unknown genres")
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                            }

                                            Text(String(format: "Rating: %.1f", movie.rating))
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)

                                            if !movie.overview.isEmpty {
                                                Text(movie.overview)
                                                    .font(.body)
                                                    .lineLimit(3)
                                                    .foregroundColor(.secondary)
                                            } else {
                                                Text("No description available.")
                                                    .font(.body)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                    }
                                    .padding(.vertical, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.white)
                                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 3)
                                    )
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Search Movies")
            .padding(.bottom, 10) 
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
