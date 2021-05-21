//
//  MovieSearchViewModel.swift
//  AmyMovie
//
//  Created by Xiaofen Liu on 3/1/21.
//

import Combine
import UIKit

enum MovieSearchState {
    case results([MovieItemViewModelType])
    case error
    case noInternet
    case loading
    case selection(Int)
}

protocol MovieSearchViewModelType {
    
    var state: CurrentValueSubject<MovieSearchState, Never> { get }
    var currentPage: Int { get }
    var totalPages: Int { get }
    
    func updateSearchTerm(_ input: String)
    func executeSearch(_ text: String, page: Int)
}

protocol MovieSearchViewModelCoordinatorDelegate: AnyObject {
    func didSelectMovie(_ movieId: String)
}

class MovieSearchViewModel: MovieSearchViewModelType {
       
    var state = CurrentValueSubject<MovieSearchState, Never>(.results([])) //initialize state with empty result array
    private var searchService: MovieSearchServiceType
    private var assetService: MovieAssetServiceType
    private var currentTask: DispatchWorkItem?
    private var movieItems: [MovieItemViewModelType] = []
    private var subscription: AnyCancellable?
    weak var coodinatorDelegate: MovieSearchViewModelCoordinatorDelegate?
    var currentPage: Int = 1
    var totalPages: Int = 1
    
    init(_ searchService: MovieSearchServiceType, _ assetService: MovieAssetServiceType) {
        self.searchService = searchService
        self.assetService = assetService
        self.subscription = state.sink(receiveValue: { [weak self] state in
            var movieID: Int? = nil
            switch state {
                case .selection(let movieId):
                     movieID = movieId
                case .error: break
                case .loading: break
                case .noInternet: break
                case .results(_): break
            }
            DispatchQueue.main.async {
                if let movieId = movieID {
                    self?.coodinatorDelegate?.didSelectMovie(String(movieId))
                }
            }
        })
    }
    
    func updateSearchTerm(_ input: String) {
        
        currentTask?.cancel()
        searchService.cancelActiveSearch()
        totalPages = 1
        currentPage = 1
        movieItems = []
        
        guard !input.isEmpty else {
            state.value = .results([])
            return
        }
        
        state.value = .loading
        
        let task = DispatchWorkItem { [weak self] in
            self?.currentTask = nil
            //TODO: properly handle this
            self?.executeSearch(input, page: 1)
        }
        
        self.currentTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: task) //prevent user from searching too often
    
        return
    }
    
    func executeSearch(_ text: String, page: Int) {
        searchService.fetchMovies(text, page: page) { [weak self, assetService] (items, error) in
            guard let strongSelf = self else { return }
            //model to viewModel
            if let items = items {
                let resultItems = items.results.map ({ movie in
                    return MovieSearchItemViewModel(item: movie, assetService: assetService)
                })
                
                strongSelf.movieItems.append(contentsOf: resultItems)
                strongSelf.totalPages = items.totalPages
                strongSelf.currentPage = page + 1
                strongSelf.state.value = .results(strongSelf.movieItems)
            } else if let error = error {
                switch error {
                case .noInternetConnection:
                    strongSelf.state.value = .noInternet
                case .other:
                    strongSelf.state.value = .error
                //TODO: handle error better here
                case .custom(_):
                    strongSelf.state.value = .error
                }
            }
        }
    }
}
