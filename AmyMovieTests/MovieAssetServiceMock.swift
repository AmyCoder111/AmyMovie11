//
//  MovieAssetServiceMock.swift
//  AmyMovieTests
//
//  Created by Xiaofen Liu on 5/24/21.
//

import XCTest
import Combine
@testable import AmyMovie

class MovieAssetServiceMock: MovieAssetServiceType {

    var result: Result<UIImage, ServiceError> = .failure(.custom("invalid response"))
    
    func fetchPosterImage(_ path: String?, completionHandler: @escaping (Result<UIImage, ServiceError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {[result] in
            completionHandler(result)
        }
    }
    
    func cancelDownloadImage() {
        return
    }
}

class MovieSearchServiceMock: MovieSearchServiceType {

    var result: Result<MovieItems, ServiceError> = .failure(.custom("invalid response"))
    var cancelSearchCount = 0

    func fetchMovies(_ searchString: String?, page: Int, completion: @escaping (Result<MovieItems, ServiceError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { [result] in
            completion(result)
        }
    }

    func cancelActiveSearch() {
        cancelSearchCount += 1
    }
}


