//
//  Movies.swift
//  MyMovieApp
//
//  Created by Taylan Bostanci on 5.04.2021.
//

import Foundation

struct Movies: Codable {
    var results: [Movie]
}

struct Movie: Codable {
    var title: String
    var release_date: String
    var vote_average: Double
    var poster_path: String?
    var backdrop_path: String?
    var id: Int
    func getImageURL() -> URL {
        return URL(string: "https://image.tmdb.org/t/p/w185/\(poster_path ?? "")")!
    }
    
}

struct Moviede: Codable {
    
    var title: String
    var posterPath: String
    var overview: String
    
    var voteAverage: Double
    var voteCount: Int
    var popularity: Double
    
    func getImageURL() -> URL {
        return URL(string: "https://image.tmdb.org/t/p/w185/\(posterPath)")!
    }
    
    private enum CodingKeys: String, CodingKey {
        case title
        case posterPath = "poster_path"
        case overview
        
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case popularity
    }
    
}
