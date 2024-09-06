//
//  Movie.swift
//  MovieWatchList
//
//  Created by Akhil Madiri on 8/29/24.
//

import Foundation

struct Movie: Identifiable, Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let genreIDs: [Int]
    let rating: Double
    var isWatched: Bool = false
    
    var genreNames: [String] {
        genreIDs.compactMap { genreID in
            Movie.genres[genreID]
        }
    }
    
    static let genres: [Int: String] = [
        28: "Action",
        12: "Adventure",
        16: "Animation",
        35: "Comedy",
        80: "Crime",
        99: "Documentary",
        18: "Drama",
        10751: "Family",
        14: "Fantasy",
        36: "History",
        27: "Horror",
        10402: "Music",
        9648: "Mystery",
        10749: "Romance",
        878: "Science Fiction",
        10770: "TV Movie",
        53: "Thriller",
        10752: "War",
        37: "Western"
    ]
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case genreIDs = "genre_ids"
        case rating = "vote_average"
    }
}
