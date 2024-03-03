//
//  NewsContentConfiguration.swift
//  AutoDocTest
//
//  Created by Emil Shpeklord on 03.03.2024.
//

import UIKit

struct NewsCellContentConfiguration: UIContentConfiguration, Hashable {
    
    var image: UIImage?
    var title: String?
    
    func makeContentView() -> UIView & UIContentView {
        NewsContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> NewsCellContentConfiguration {
        self
    }
}
