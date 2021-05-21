//
//  MovieSearchService.swift
//  AmyMovie
//
//  Created by Xiaofen Liu on 2/28/21.
//

import Foundation
import UIKit

protocol MovieSearchServiceType {
    func fetchMovies(_ searchString: String?, page: Int, completion: @escaping (MovieItems?, ServiceError?) -> Void)
    func cancelActiveSearch()
}

final class MovieSearchService: MovieSearchServiceType {
    
    private var fetchMoviesTask: URLSessionDataTask?
    private let apiKey = "2a61185ef6a27f400fd92820ad9e8537"
    private var cache = NSCache<NSString, MovieItems>()
    
    private let apiClient: APIClient = APIClient(baseURL: "https://api.themoviedb.org")
    
    func fetchMovies(_ searchString: String?, page: Int, completion: @escaping (MovieItems?, ServiceError?) -> Void) {
        guard let searchStr = searchString else { return }
        
        let cacheKey = NSString(string: searchStr + "_" + "\(page)")
        if let movies = cache.object(forKey: cacheKey) {
            completion(movies, nil)
            return
        }
        
        self.fetchMoviesTask?.cancel()
        
        let params: [String : String] = ["api_key": apiKey, "query": searchStr, "page": String(page)]
        
        let task = apiClient.load(path: "/3/search/movie", method: .get, params: params) { [weak self] result in
            switch result {
                case .success(let data):
                    let jsonDecoder = JSONDecoder()
                    //A key decoding strategy that converts snake-case keys to camel-case keys. eg "big_apple" to "bigApple"
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        guard let data = data as? Data else {
                            completion(nil, .custom("wrong data type"))
                            return
                        }
                        let movieItems = try jsonDecoder.decode(MovieItems.self, from: data)
                        self?.cache.setObject(movieItems, forKey: cacheKey)
                        completion(movieItems, nil)
                    } catch {
                        completion(nil, .custom("Fail to decode search results"))
                    }
                case .failure(let error):
                    completion(nil, error)
                    
            }
        }
        
        self.fetchMoviesTask = task
    }
    
    func cancelActiveSearch() {
        self.fetchMoviesTask?.cancel()
        self.fetchMoviesTask = nil
    }
}

