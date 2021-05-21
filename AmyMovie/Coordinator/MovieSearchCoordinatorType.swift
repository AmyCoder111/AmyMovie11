//
//  MovieSearchCoordinatorType.swift
//  AmyMovie
//
//  Created by Xiaofen Liu on 4/24/21.
//

import UIKit

protocol MovieSearchCoordinatorType {
    func start()
    func navigateToMovieDetails(_ movieId: String)
}
