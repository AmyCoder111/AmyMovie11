//
//  MovieDetailViewModel.swift
//  AmyMovie
//
//  Created by Xiaofen Liu on 5/8/21.
//

import Foundation
import Combine

enum MovieDetailState {
    case result(MovieDetailItemViewModelType?)
    case error
    case noInternet
    case loading
}

protocol MovieDetailViewModelType {
    var state: CurrentValueSubject<MovieDetailState, Never> { get }
    
    func fetchMovieDetail()
}

class MovieDetailViewModel: MovieDetailViewModelType {
    var state = CurrentValueSubject<MovieDetailState, Never>(.result(nil))
    private var detailService: MovieDetailServiceType
    private var assetService: MovieAssetServiceType
    private let movieId: String
    
    init(_ movieDetailService: MovieDetailServiceType, _ movieAssetService: MovieAssetServiceType, _ movieId: String) {
        self.detailService = movieDetailService
        self.assetService = movieAssetService
        self.movieId = movieId
    }
    
    func fetchMovieDetail() {
        state.value = .loading
        self.detailService.fetchMovieDetail(self.movieId) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
                case .success(let movieDetail):
                    let movieDetailItemViewModel = MovieDetailItemViewModel(item: movieDetail, assetService: strongSelf.assetService)
                    strongSelf.state.value = .result(movieDetailItemViewModel)
                case .failure(let error):
                    print(error)
            }
        }
    }
}
