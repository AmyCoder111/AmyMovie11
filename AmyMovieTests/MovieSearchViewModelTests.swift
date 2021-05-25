//
//  MovieSearchViewModelTests.swift
//  AmyMovieTests
//
//  Created by Xiaofen Liu on 5/24/21.
//

import XCTest
@testable import AmyMovie

class MovieSearchViewModelTests: XCTestCase {
    
    var viewModel: MovieSearchViewModel!
    var assetService: MovieAssetServiceMock!
    var searchService: MovieSearchServiceMock!
    
    let movie1 = MovieItem(title: "Harry Potter and the Goblet of Fire", overview: "When Harry Potter's name emerges from the Goblet of Fire, he becomes a competitor in a grueling battle for glory among three wizarding schools", releaseDate: "2005-11-16", posterPath: "/4dmWp12lQua3Bpqu8CwsaGKNVUE.jpg", id: 46)
    let movie2 = MovieItem(title: "Love and Monsters", overview: "Seven years since the Monsterpocalypse began, Joel Dawson has been living underground in order to survive...", releaseDate: "2020-10-16", posterPath: "/4dmWp12lQua3Bpqu8CwsaGKNVUE.jpg", id: 57)
    
    lazy var validMovieResults = MovieItems([movie1,movie2])
    lazy var validMovieModels: [MovieSearchItemViewModel] = {
        return validMovieResults.results.map { MovieSearchItemViewModel(item: $0, assetService: assetService!) }
    }()

    override func setUp() {
        assetService = MovieAssetServiceMock()
        searchService = MovieSearchServiceMock()
        viewModel = MovieSearchViewModel(searchService, assetService)
    }
    
    func testInitialValue() {
        let expectation = self.expectation(description: "Multiple binds get value")

        _ = viewModel.state.sink(receiveValue: { value in
            switch value {
            case .results(let movies):
                assert(movies.isEmpty)
                expectation.fulfill()
            case .error(_), .noInternet, .loading, .selection(_):
                assertionFailure("Wrong")
            }
        })

        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testResultsState() {
        let expectation = self.expectation(description: "Multiple binds get value")
        expectation.expectedFulfillmentCount = 3

        //inject view model will trigger updateViews because
        //we initialize state with empty result array
        var resultQueue = [[], validMovieModels]
        let sub = viewModel.state.sink(receiveValue: { value in
            switch value {
                case .results(let movies):
                    assert(movies.count == resultQueue.removeFirst().count)
                    expectation.fulfill()
                case .loading:
                    expectation.fulfill()
                case .error, .noInternet, .selection(_):
                    assertionFailure("Wrong")
            }
        })

        searchService.result = .success(validMovieResults)
        viewModel.updateSearchTerm("Love")

        waitForExpectations(timeout: 10, handler: nil)
        sub.cancel()
    }
    
    func testTypingFastResultsState() {
        // test having 2 results but making 3 queries fast

        let expectation = self.expectation(description: "Multiple binds get value")
        expectation.expectedFulfillmentCount = 5

        var resultQueue = [[], validMovieModels]
        let sub = viewModel.state.sink(receiveValue: { value in
            switch value {
            case .results(let movies):
                assert(movies.count == resultQueue.removeFirst().count)
                expectation.fulfill()
            case .loading:
                expectation.fulfill()
            case .error, .noInternet, .selection(_):
                assertionFailure("Wrong")
            }
        })

        searchService.result = .success(validMovieResults)
        viewModel.updateSearchTerm("one")
        viewModel.updateSearchTerm("two")
        viewModel.updateSearchTerm("three")
        assert(searchService.cancelSearchCount == 3)

        waitForExpectations(timeout: 10, handler: nil)
        sub.cancel()
    }
    
    func testEmptyStateAfterResults() {
        let expectation = self.expectation(description: "Multiple binds get value")
        expectation.expectedFulfillmentCount = 4

        //we test going from initial state to searching 2 movies
        //then searching empty string
        var resultQueue = [[], validMovieModels, []]
        let sub = viewModel.state.sink(receiveValue: {[viewModel, validMovieResults] value in
            switch value {
            case .results(let movies):
                assert(movies.count == resultQueue.removeFirst().count)
                expectation.fulfill()

                if movies.count == validMovieResults.results.count {
                    viewModel!.updateSearchTerm("")
                }
            case .loading:
                expectation.fulfill()
            case .error, .noInternet, .selection(_):
                assertionFailure("Wrong")
            }
        })

        searchService.result = .success(validMovieResults)
        viewModel.updateSearchTerm("search something")

        waitForExpectations(timeout: 10, handler: nil)
        sub.cancel()
    }
}
