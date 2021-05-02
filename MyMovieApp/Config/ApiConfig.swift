//
//  Constants.swift
//  MyMovieApp
//
//  Created by Taylan Bostanci on 5.04.2021.
//
import UIKit
import Foundation
import Alamofire
import CodableAlamofire

class APIClient: NSObject {
    
    static let shared: APIClient = {
        let instance = APIClient()
        return instance
    }()
    
    private override init() {}

    let apiURL = AppConfig.API.movieAPIURL
    let apiCreds = "?api_key=\(AppConfig.Key.movieAPIKey)"
    let imageURL = AppConfig.API.movieImageBaseURL
    
    lazy var defaultDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        //decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    func getMovies(_ category: MovieDBCategory, completion: @escaping ([Moviede], Error?) -> Void) {
        let url = { () -> URL in
            switch category {
            case .NowPlaying:
                return URL(string: apiURL + "movie/now_playing" + apiCreds)!
            case .Popular:
                return URL(string: apiURL + "movie/popular" + apiCreds)!
            case .TopRated:
                return URL(string: apiURL + "movie/top_rated" + apiCreds)!
            case .Upcoming:
                return URL(string: apiURL + "movie/upcoming" + apiCreds)!
            }
        }()
        print("Fetching \(url)")
        Alamofire.request(url).responseDecodableObject(keyPath: "results", decoder: self.defaultDecoder) { (response: DataResponse<[Moviede]>) in
            let movies = response.result.value
            if let movies = movies {
                completion(movies, nil)
            }else{
                completion([Moviede](), response.result.error)
            }
        }
    }
}

struct AppConfig {
    
    struct API {
        static let movieAPIURL = "https://api.themoviedb.org/3/"
        static let movieImageBaseURL = "https://image.tmdb.org/t/p/w185/"
    }
    
    struct Key {
        static let movieAPIKey = "}e899c1350d036380fd3d25d98292be1a"
    }
}

struct APIKey: Codable {
    var api_key: String
}

struct Keys {
    static let API_KEY = "api_key"
    static let LANGUAGE = "language"
    static let ORIENTATION = "orientation"
    static let APP_LANGUAGE = "app_lang"
}

struct ApiURL {
    static let baseURL = "https://api.themoviedb.org/3/movie/"
    static let selectedMovie = baseURL
    static let image = "https://image.tmdb.org/t/p/"
}

struct Images {
    static let emptyImage = UIImage(named: "placeholder")
}

enum MovieType {
    case nowPlaying
    case topRated
    case popular
    
    var value : String {
        switch self {
        case .nowPlaying:
            return "now_playing"
        case .topRated:
            return "top_rated"
        case .popular:
            return "popular"
        }
    }
}

enum MovieDBCategory: String {
    case NowPlaying = "Now Playing"
    case Popular = "Popular"
    case TopRated = "Top Rated"
    case Upcoming = "Upcoming"
}


/// API Errors

enum APIError: Error {
    case unknownError
    case invalidURL
    case invalidResponse
    case invalidData
    case decodeError
    
    var localizedDescription : String{
        switch self {
        case .unknownError:
            return "Unknown"
        case .invalidURL:
            return "InvalidURL.Error"
        case .invalidResponse:
            return "Response.Error"
        case .invalidData:
            return "Data.Error"
        case .decodeError:
            return "Decode.Error"
        }
    }
}

struct MovieDetail: Codable {
    
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
