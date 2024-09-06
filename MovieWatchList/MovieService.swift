import Foundation

enum NetworkError: LocalizedError {
    case badURL
    case noInternetConnection
    case timeout
    case serverError(statusCode: Int)
    case decodingError
    case unknownError

    var errorDescription: String? {
        switch self {
        case .badURL:
            return "The URL is invalid."
        case .noInternetConnection:
            return "Please check your internet connection."
        case .timeout:
            return "The request timed out. Please try again."
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)."
        case .decodingError:
            return "Failed to decode the data from the server."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}

class MovieService {
    private let baseURL = "https://api.themoviedb.org/3"
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // Fetch Popular Movies
    func fetchPopularMovies() async throws -> [Movie] {
        guard let url = URL(string: "\(baseURL)/movie/popular?api_key=\(APIConfig.apiKey)&language=en-US&page=1") else {
            throw NetworkError.badURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            // Check the response status code
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
            
            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                return response.results
            } catch {
                throw NetworkError.decodingError
            }
        } catch {
            if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                throw NetworkError.noInternetConnection
            } else if (error as NSError).code == NSURLErrorTimedOut {
                throw NetworkError.timeout
            } else {
                throw NetworkError.unknownError
            }
        }
    }

    func searchMovies(query: String) async throws -> [Movie] {
        guard let url = URL(string: "\(baseURL)/search/movie?api_key=\(APIConfig.apiKey)&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&language=en-US&page=1&include_adult=false") else {
            throw NetworkError.badURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
            
            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                return response.results
            } catch {
                throw NetworkError.decodingError
            }
        } catch {
            if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                throw NetworkError.noInternetConnection
            } else if (error as NSError).code == NSURLErrorTimedOut {
                throw NetworkError.timeout
            } else {
                throw NetworkError.unknownError
            }
        }
    }
}
    
    // Decoding Struct for TMDB API Response
    private struct MovieResponse: Codable {
        let results: [Movie]
    }
    
    struct APIConfig {
        static var apiKey: String {
            guard let url = Bundle.main.url(forResource: "tmdbapi", withExtension: "plist"),
                  let data = try? Data(contentsOf: url),
                  let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
                  let key = plist["API_KEY"] as? String else {
                fatalError("API Key not found in tmdbapi.plist")
            }
            return key
        }
    }
