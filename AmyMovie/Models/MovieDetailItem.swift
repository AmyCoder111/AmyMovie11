//
//  MovieDetailItem.swift
//  AmyMovie
//
//  Created by Xiaofen Liu on 5/8/21.
//

import Foundation

struct Genre: Codable {
    var id: Int?
    var name: String?
}

struct ProductionCompany: Codable {
    let name: String?
    let logoPath: String?
}

struct SpokenLanguage: Codable {
    let englishName: String?
}

struct MovieDetailItem: Codable {
    let title: String?
    let overview: String?
    let backdropPath: String?
    var genres: [Genre]
    let voteAverage: Float?
    var productionCompanies: [ProductionCompany]
    var spokenLanguages: [SpokenLanguage]
}
