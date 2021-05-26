//
//  MovieDetailViewModelTests.swift
//  AmyMovieTests
//
//  Created by Xiaofen Liu on 5/25/21.
//

import XCTest
@testable import AmyMovie

class MovieDetailViewModelTests: XCTestCase {

    var viewModel: MovieDetailViewModel!
    var assetService: MovieAssetServiceMock!
    var detailService: MovieDetailServiceMock!
        
    let movieDetailItem = MovieDetailItem(title: "Harry Potter and the Goblet of Fire", overview: "When Harry Potter's name emerges from the Goblet of Fire, he becomes a competitor in a grueling battle for glory among three wizarding schools", backdropPath: "/4dmWp12lQua3Bpqu8CwsaGKNVUE.jpg", genres: [Genre(id: nil, name: "Adventure")], voteAverage: 7.5, productionCompanies: [ProductionCompany(name: "Warner Bros. Pictures", logoPath: nil)], spokenLanguages: [SpokenLanguage(englishName: "English")])
    
    lazy var validMovieDetailModel: MovieDetailItemViewModel = MovieDetailItemViewModel(item: movieDetailItem, assetService: assetService!)
    
    override func setUp() {
        assetService = MovieAssetServiceMock()
        detailService = MovieDetailServiceMock()
        viewModel = MovieDetailViewModel(detailService, assetService, "1")
    }
    
    func testInitialValue() {
        let expectation = self.expectation(description: "Multiple binds get value")

        _ = viewModel.state.sink(receiveValue: { value in
            switch value {
            case .result(let movieDetail):
                assert(movieDetail == nil)
                expectation.fulfill()
            case .noInternet, .loading, .error:
                assertionFailure("Wrong")
            }
        })

        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testResultsState() {
        let expectation = self.expectation(description: "Multiple binds get value")
        expectation.expectedFulfillmentCount = 3

        let sub = viewModel.state.sink(receiveValue: { value in
            switch value {
                case .result(_):
                    expectation.fulfill()
                case .loading:
                    expectation.fulfill()
                case .error, .noInternet:
                    assertionFailure("Wrong")
            }
        })

        detailService.result = .success(movieDetailItem)
        viewModel?.fetchMovieDetail()

        waitForExpectations(timeout: 10, handler: nil)
        sub.cancel()
    }
}
