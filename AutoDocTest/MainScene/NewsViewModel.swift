//
//  MainViewModel.swift
//  AutoDocTest
//
//  Created by Emil Shpeklord on 03.03.2024.
//

import Foundation

final class NewsViewModel: NSObject {
    
    func getNews() async -> NewsDTO? {
        do {
            return try await NewsAPIManager.getNews()
        } catch {
            return nil
        }
    }
}
