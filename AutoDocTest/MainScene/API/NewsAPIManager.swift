//
//  NewsAPIManager.swift
//  AutoDocTest
//
//  Created by Emil Shpeklord on 03.03.2024.
//

import Foundation

final class NewsAPIManager {
    
    static func getNews() async throws -> NewsDTO? {
        guard let url = URL(string: "https://webapi.autodoc.ru/api/news/1/15") else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(NewsDTO.self, from: data)
        } catch let error {
            throw error
        }
    }
}
