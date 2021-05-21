//
//  MovieSearchCoordinator.swift
//  AmyMovie
//
//  Created by Xiaofen Liu on 4/24/21.
//

import Foundation
import UIKit

class MovieSearchCoordinator: MovieSearchCoordinatorType {
    
    let window: UIWindow?
    var navigationController: UINavigationController?
    
    init(_ window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let navController = UINavigationController()
        let searchVC = MovieSearchViewController()
        let movieSearchService = MovieSearchService()
        let movieAssetService = MovieAssetService()
        let viewModel = MovieSearchViewModel(movieSearchService, movieAssetService)
        viewModel.coodinatorDelegate = self
        searchVC.inject(viewModel: viewModel)
        self.navigationController = navController
        navController.pushViewController(searchVC, animated: false)
        
        guard let window = window else { return }
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }
}

extension MovieSearchCoordinator: MovieSearchViewModelCoordinatorDelegate {
    
    func navigateToMovieDetails(_ movieId: String) {
        let movieDetailService = MovieDetailService()
        let movieAssetService = MovieAssetService()
        let viewModel = MovieDetailViewModel(movieDetailService, movieAssetService, movieId)
        let storyboard = UIStoryboard.init(name: "MovieDetailStoryboard", bundle: nil)
        let detailViewController: MovieDetailViewController = storyboard.instantiateViewController(identifier: "detailViewController")
        detailViewController.injectViewModel(viewModel)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func didSelectMovie(_ movieId: String) {
        navigateToMovieDetails(movieId)
    }
}


