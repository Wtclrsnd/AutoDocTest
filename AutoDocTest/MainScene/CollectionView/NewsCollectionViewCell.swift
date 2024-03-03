//
//  NewsCollectionViewCell.swift
//  AutoDocTest
//
//  Created by Emil Shpeklord on 03.03.2024.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {

    var model: NewsContent? {
        didSet {
            setNeedsUpdateConfiguration()
        }
    }
    
    override func updateConfiguration(using _: UICellConfigurationState) {
        guard let model else {
            contentConfiguration = nil
            return
        }
        
        contentConfiguration = NewsCellContentConfiguration(image: model.titleImage, title: model.title)
    }
}
