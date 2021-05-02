//
//  MovieService.swift
//  MyMovieApp
//
//  Created by Taylan Bostanci on 5.04.2021.
//

import Foundation
import UIKit

class Service {
    
    static let shared = Service()
    let cache = NSCache<NSString, UIImage>()
    let apiKey = PropertyListConfig.getPlistKey(key: .apiKey)
    
    func getMovies(movieType: MovieType, language: String, completion: @escaping (Result<[Movie], APIError> ) -> Void) {
        
        guard let url = URL(string: ApiURL.baseURL + movieType.value) else {
            completion(.failure(.invalidURL))
            return
        }
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
        
        var queryItem = [URLQueryItem(name: Keys.API_KEY,  value: apiKey)]
        queryItem.append(URLQueryItem(name: Keys.LANGUAGE,  value: language))
        urlComponents.queryItems = queryItem
        
        guard let finalURL = urlComponents.url else { return }
        
        URLSession.shared.dataTask(with: finalURL, completionHandler: {( data, response ,error) in
            if let _ = error {
                completion(.failure(.unknownError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { completion(.failure(.invalidResponse))
                return
            }
            
            do{
                let movieResponse = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(movieResponse.results))
            } catch {
                completion(.failure(.decodeError))
            }
        }).resume()
    }
    
    func getSelectedMovie(movieId: Int, language: String, completion: @escaping (Result< SelectedMovie, APIError> ) -> Void) {
        
        guard let url = URL(string: ApiURL.selectedMovie + "\(movieId)") else {
            completion(.failure(.invalidURL))
            return
        }
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
        
        var queryItem = [URLQueryItem(name: Keys.API_KEY,  value: apiKey)]
        queryItem.append(URLQueryItem(name: Keys.LANGUAGE,  value: language))
        urlComponents.queryItems = queryItem
        guard let finalURL = urlComponents.url else { return }
        
        URLSession.shared.dataTask(with: finalURL, completionHandler: {( data, response ,error) in
            if let _ = error {
                completion(.failure(.unknownError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { completion(.failure(.invalidResponse))
                return
            }
            
            do{
                let movieResponse = try JSONDecoder().decode(SelectedMovie.self, from: data)
                completion(.success(movieResponse))
            } catch {
                completion(.failure(.decodeError))
            }
        }).resume()
    }
    
    func getImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
    }
}
