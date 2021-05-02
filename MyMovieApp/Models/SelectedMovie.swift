//
//  SelectedMovie.swift
//  MyMovieApp
//
//  Created by Taylan Bostanci on 5.04.2021.
//

import Foundation

struct SelectedMovie: Codable {
    var title: String
    var runtime: Int
    var release_date: String
    var vote_average: Double
    var genres: [Genre]
    var overview: String
}

struct Genre: Codable, Equatable {
    var id: Int
    var name: String
} 
