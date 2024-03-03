//
//  MainViewModel.swift
//  AutoDocTest
//
//  Created by Emil Shpeklord on 03.03.2024.
//

import UIKit

final class NewsViewModel: NSObject {
    
    func getNews() async -> [NewsModel]? {
        do {
            let news = try await NewsAPIManager.getNews()
            return constructNews(news: news?.news)
        } catch {
            return nil
        }
    }
    
    func getImage(_ url: URL) async -> UIImage? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            return nil
        }
    }
    
    private func constructNews(news: [News]?) -> [NewsModel] {
        var result: [NewsModel] = []
        guard let news else { return [] }
        for new in news {
            guard let id = new.id,
                  let title = new.title,
                  let description = new.description,
                  let publishedDate = new.publishedDate,
                  let urlString = new.url,
                  let fullURLStrig = new.fullURL,
                  let url = URL(string: urlString),
                  let fullURL = URL(string: fullURLStrig),
                  let titleImageURLString = new.titleImageURL,
                  let titleImageURL = URL(string: titleImageURLString),
                  let categoryType = new.categoryType else { continue }
            let element = NewsModel(id: id, 
                                      title: title,
                                      description: description,
                                      publishedDate: publishedDate,
                                      url: url,
                                      fullURL: fullURL,
                                      titleImageURL: titleImageURL,
                                      categoryType: categoryType)
            result.append(element)
        }
        return result
    }
}
