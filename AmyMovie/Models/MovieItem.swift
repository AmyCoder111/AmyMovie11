//
//  MovieItem.swift
//  AmyMovie
//
//  Created by Xiaofen Liu on 2/28/21.
//

import Foundation

struct MovieItem: Codable {
    let title: String?
    let overview: String?
    let releaseDate: String?
    let posterPath: String?
    let id: Int?
}

//NSCache requires the MovieItems be a class type
class MovieItems: Codable {
    let results: [MovieItem]
    let totalPages: Int
    let totalResults: Int
    let page: Int
    //no need to customize keys since we use set .convertFromSnakeCase on the decoder
}
