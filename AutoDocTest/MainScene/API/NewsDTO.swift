//
//  NewsDTO.swift
//  AutoDocTest
//
//  Created by Emil Shpeklord on 03.03.2024.
//

import Foundation

// MARK: - NewsDTO
struct NewsDTO: Codable {
    let news: [News]?
    let totalCount: Int?
}

// MARK: - News
struct News: Codable {
    let id: Int?
    let title, description, publishedDate, url: String?
    let fullURL: String?
    let titleImageURL: String?
    let categoryType: CategoryType?

    enum CodingKeys: String, CodingKey {
        case id, title, description, publishedDate, url
        case fullURL = "fullUrl"
        case titleImageURL = "titleImageUrl"
        case categoryType
    }
}

enum CategoryType: String, Codable {
    case автомобильныеНовости = "Автомобильные новости"
    case новостиКомпании = "Новости компании"
}
