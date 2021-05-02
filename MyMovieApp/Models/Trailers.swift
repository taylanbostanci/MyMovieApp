//
//  Trailers.swift
//  MyMovieApp
//
//  Created by Taylan Bostanci on 5.04.2021.
//

import Foundation

/**
 Entity used to represent the trailers
 */
struct Trailers: Codable {
    var results: [Trailer]
}

/**
 Entity  that represents the`results` property from the entity `Trailers`
 */
struct Trailer: Codable {
    var id: String
    var key: String
}
