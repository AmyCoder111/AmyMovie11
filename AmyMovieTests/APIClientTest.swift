//
//  APIClientTest.swift
//  AmyMovieTests
//
//  Created by Xiaofen Liu on 5/24/21.
//

import XCTest
@testable import AmyMovie

class APIClientTest: XCTestCase {
    
    var apiClientOne: APIClient!
    var apiClientTwo: APIClient!
    
    override func setUp() {
        apiClientOne = APIClient(baseURL: "https://api.themoviedb.org")
        apiClientTwo = APIClient(baseURL: "https://image.tmdb.org/t/p/")
    }
    
    func testFetchSearchResultValid() {
        let expectation = self.expectation(description: "Search Result")
        _ = apiClientOne.load(path: "/3/search/movie", method: .get, params: ["api_key": "2a61185ef6a27f400fd92820ad9e8537", "query": "mom", "page": String(1)], completion: { result in
            switch result {
                case .success(_):
                    expectation.fulfill()
                case .failure(_):
                    assertionFailure("Bad Response")
            }
        })
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchImageValid() {
        let expectation = self.expectation(description: "Downloaded Image")
        _ = apiClientTwo.load(path: "w600_and_h900_bestv2/4dmWp12lQua3Bpqu8CwsaGKNVUE.jpg", method: .get, params: [:], completion: { result in
            switch result {
                case .success(_):
                    expectation.fulfill()
                case .failure(_):
                    assertionFailure("Bad Response")
            }
        })
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchImageCache() {
        testFetchImageValid()
        
        let expectation = self.expectation(description: "Got cached image")
        _ = apiClientTwo.load(path: "w600_and_h900_bestv2/4dmWp12lQua3Bpqu8CwsaGKNVUE.jpg", method: .get, params: [:], completion: { result in
            switch result {
                case .success(_):
                    expectation.fulfill()
                case .failure(_):
                    assertionFailure("Bad Response")
            }
        })
        self.waitForExpectations(timeout: 10, handler: nil)
    }

}
