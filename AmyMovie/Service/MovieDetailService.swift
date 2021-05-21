//
//  MovieDetailService.swift
//  AmyMovie
//
//  Created by Xiaofen Liu on 5/8/21.
//

import Foundation

protocol MovieDetailServiceType {
    func fetchMovieDetail(_ movieId: String?, completionHandler: @escaping (Result<MovieDetailItem, ServiceError>) -> Void)
    func cancelFetchMovieDetail()
}

class MovieDetailService: MovieDetailServiceType {
    
    private let apiKey = "2a61185ef6a27f400fd92820ad9e8537"
    private let apiClient: APIClient = APIClient(baseURL: "https://api.themoviedb.org")
    private var fetchMovieDetailTask: URLSessionDataTask?
    
    func fetchMovieDetail(_ movieId: String?, completionHandler: @escaping (Result<MovieDetailItem, ServiceError>) -> Void) {
        guard let movieId = movieId else {
            completionHandler(.failure(.custom("no movie id found")))
            return 
        }
        
        self.fetchMovieDetailTask?.cancel()
        
        let parameters: [String : String] = ["api_key": apiKey]
        let task = apiClient.load(path: "/3/movie/" + movieId, method: .get, params: parameters) { result in
            switch result {
                case .success(let data):
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    do {
                        guard let data = data as? Data else {
                            completionHandler(.failure(.custom("Wrong data type")))
                            return
                        }
                        
                        let movieDetail = try jsonDecoder.decode(MovieDetailItem.self, from: data)
                        completionHandler(.success(movieDetail))
                    } catch {
                        print(error)
                        completionHandler(.failure(.custom("Fail to decode movie detail item")))
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
            }
        }
        
        fetchMovieDetailTask = task
    }
    
    func cancelFetchMovieDetail() {
        fetchMovieDetailTask?.cancel()
        fetchMovieDetailTask = nil
    }
}
