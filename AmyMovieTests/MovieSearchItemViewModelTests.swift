//
//  MovieSearchItemViewModelTests.swift
//  AmyMovieTests
//
//  Created by Xiaofen Liu on 5/24/21.
//

import XCTest
import Combine
@testable import AmyMovie

class MovieSearchItemViewModelTests: XCTestCase {
    
    var viewModel: MovieSearchItemViewModel!
    var assetService: MovieAssetServiceMock!
    
    let movie = MovieItem(title: "Harry Potter and the Goblet of Fire", overview: "When Harry Potter's name emerges from the Goblet of Fire, he becomes a competitor in a grueling battle for glory among three wizarding schools", releaseDate: "2005-11-16", posterPath: "/4dmWp12lQua3Bpqu8CwsaGKNVUE.jpg", id: 46)
    let placeholderImage = UIImage(named: "default_placeholder")!
    
    override func setUp() {
        assetService = MovieAssetServiceMock()
        viewModel = MovieSearchItemViewModel(item: movie, assetService: assetService)
    }
   
    func testSubscriptionsValidImage() {
        viewModel.willBeSubscribedTo()
        
        assetService.result = .success(placeholderImage)
        
        let expectation = self.expectation(description: "Multiple binds get value")
        expectation.expectedFulfillmentCount = 5
        expectation.assertForOverFulfill = false

        var subscriptions = [AnyCancellable]()
        subscriptions.append(viewModel.title.sink(receiveValue: {[weak self] value in
            assert(value == self?.movie.title)
            expectation.fulfill()
        }))

        subscriptions.append(viewModel.releaseDate.sink(receiveValue: {[weak self] value in
            assert(value == self?.movie.releaseDate)
            expectation.fulfill()
        }))

        subscriptions.append(viewModel.overview.sink(receiveValue: {[weak self] value in
            assert(value == self?.movie.overview)
            expectation.fulfill()
        }))

        subscriptions.append(viewModel.posterImage.sink(receiveCompletion: {completion in
            assert(completion == .finished)
            expectation.fulfill()
        }, receiveValue: {value in
            expectation.fulfill()
        }))

        viewModel.hasSubscribedTo()

        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSubscriptionsInvalidImage() {
        viewModel.willBeSubscribedTo()

        let expectation = self.expectation(description: "Invalid image")

        var subscriptions = [AnyCancellable]()
        subscriptions.append(viewModel.posterImage.sink(receiveCompletion: {completion in
            expectation.fulfill()
        }, receiveValue: {value in
            assertionFailure("Should not get a value")
        }))

        viewModel.hasSubscribedTo()

        waitForExpectations(timeout: 10, handler: nil)
    }
}
