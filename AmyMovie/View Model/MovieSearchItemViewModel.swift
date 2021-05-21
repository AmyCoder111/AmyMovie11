//
//  MovieSearchItemViewModel.swift
//  AmyMovie
//
//  Created by Xiaofen Liu on 4/27/21.
//

import UIKit
import Combine

protocol MovieItemViewModelType {
    var title: CurrentValueSubject<String, Never> { get }
    var releaseDate: CurrentValueSubject<String, Never> { get }
    var overview: CurrentValueSubject<String, Never> { get }
    var posterImage: PassthroughSubject<UIImage, ServiceError> { get }
    var movieId: Int? { get }
    
    //let the model know it will be subscribed to
    func willBeSubscribedTo()
    
    //let the model know it has already been subscribed to
    func hasSubscribedTo()
}

class MovieSearchItemViewModel: MovieItemViewModelType {
    
    let title: CurrentValueSubject<String, Never>
    let releaseDate: CurrentValueSubject<String, Never>
    let overview: CurrentValueSubject<String, Never>
    var posterImage = PassthroughSubject<UIImage, ServiceError>()
    let movieId: Int?
    
    private let assetService: MovieAssetServiceType
    private let posterPath: String?
    private var posterFetchID: Int?
    
    init(item: MovieItem, assetService: MovieAssetServiceType) {
        self.title = .init(item.title ?? "")
        self.releaseDate = .init(item.releaseDate ?? "")
        self.overview = .init(item.overview ?? "")
        self.movieId = item.id
        self.posterPath = item.posterPath
        self.assetService = assetService
    }
    
    func willBeSubscribedTo() {
        //we can't reuse the PassthroughSubject after we already sent a completion to it
        posterImage = PassthroughSubject<UIImage, ServiceError>()
    }
    
    func hasSubscribedTo() {
        guard let posterPath = posterPath else {
            posterImage.send(completion: .failure(.custom("Lack of poster image path")))
            return
        }
        
        assetService.fetchPosterImage(posterPath) { [weak self] result in
            switch result {
                case .success(let image):
                    self?.posterImage.send(image)
                    self?.posterImage.send(completion: .finished)
                case .failure(let error):
                    self?.posterImage.send(completion: .failure(error))
            }
        }
    }
}
