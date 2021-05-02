//
//  PlistService.swift
//  MyMovieApp
//
//  Created by Taylan Bostanci on 5.04.2021.
//

import Foundation

enum PlistKey {
    case apiKey
}

class PropertyListConfig {
    
    static func getPlistKey(key: PlistKey) -> String {
        guard let path = Bundle.main.path(forResource: "key-info", ofType: "plist"),
              let xml = FileManager.default.contents(atPath: path)
        else { return "" }
        
        switch key {
        case .apiKey:
            guard let apiKey = try? PropertyListDecoder().decode(APIKey.self, from: xml) else { return "" }
            return apiKey.api_key
        }
    }
}
