//
//  NewsModel.swift
//  AutoDocTest
//
//  Created by Emil Shpeklord on 03.03.2024.
//

import UIKit

final class NewsModel: Hashable {
    
    let id: Int
    let title, description, publishedDate: String
    let url, fullURL: URL
    let titleImageURL: URL
    var titleImage: UIImage?
    let categoryType: CategoryType
    
    init(id: Int, title: String, description: String, publishedDate: String, url: URL, fullURL: URL, titleImageURL: URL, categoryType: CategoryType) {
        self.id = id
        self.title = title
        self.description = description
        self.publishedDate = publishedDate
        self.url = url
        self.fullURL = fullURL
        self.titleImageURL = titleImageURL
        self.categoryType = categoryType
    }
    
    static func == (lhs: NewsModel, rhs: NewsModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

