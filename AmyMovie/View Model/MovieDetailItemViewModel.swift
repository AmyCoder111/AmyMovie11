//
//  MovieDetailItemViewModel.swift
//  AmyMovie
//
//  Created by Xiaofen Liu on 5/14/21.
//

import Combine
import UIKit

protocol MovieDetailItemViewModelType {
    var title: CurrentValueSubject<String, Never> { get }
    var overview: CurrentValueSubject<String, Never> { get }
    var backdropImage: PassthroughSubject<UIImage, ServiceError> { get }
    var rating: CurrentValueSubject<String, Never> { get }
    var tagline: CurrentValueSubject<String, Never> { get }
    var genres: [String] { get }
    var spokenLanguages: [String] { get }
    var productionCompanies: [String] { get }
    
    //let the model know it will be subscribed to
    func willBeSubscribedTo()
    
    //let the model know it has already been subscribed to
    func hasSubscribedTo()
}

class MovieDetailItemViewModel: MovieDetailItemViewModelType {
    let title: CurrentValueSubject<String, Never>
    let overview: CurrentValueSubject<String, Never>
    let rating: CurrentValueSubject<String, Never>
    let tagline: CurrentValueSubject<String, Never>
    var backdropImage = PassthroughSubject<UIImage, ServiceError>()
    var genres: [String] = []
    var spokenLanguages: [String] = []
    var productionCompanies: [String] = []
    
    private let assetService: MovieAssetServiceType
    private let backdropPath: String?
    
    init(item: MovieDetailItem, assetService: MovieAssetServiceType) {
        self.title = .init(item.title ?? "")
        self.overview = .init(item.overview ?? "")
        self.rating = .init(String(item.voteAverage ?? 0))
        self.tagline = .init(item.tagline ?? "")
        self.backdropPath = item.backdropPath
        self.assetService = assetService
        
        let genres: [String] = item.genres.map {
            return $0.name ?? ""
        }.filter {
            return !$0.isEmpty
        }
        
        let productionCompanies: [String] = item.productionCompanies.map {
            return $0.name ?? ""
        }.filter {
            return !$0.isEmpty
        }
        
        let spokenLanguages: [String] = item.spokenLanguages.map {
            return $0.englishName ?? ""
        }.filter {
            return !$0.isEmpty
        }
        
        self.genres = genres
        self.productionCompanies = productionCompanies
        self.spokenLanguages = spokenLanguages
    }
    
    func willBeSubscribedTo() {
        return
    }
    
    func hasSubscribedTo() {
        //TODO: request backdrop image
        return
    }
}
