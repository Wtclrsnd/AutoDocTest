//
//  NewsContentView.swift
//  AutoDocTest
//
//  Created by Emil Shpeklord on 03.03.2024.
//

import UIKit

final class NewsContentView: UIView, UIContentView {
    
    private let inset: CGFloat = 10
    
    private var newsImageView: UIImageView!
    private var label: UILabel!

    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        set {
            guard let newConfiguration = newValue as? NewsCellContentConfiguration else { return }
            apply(newConfiguration)
        }
    }
    
    private var currentConfiguration: NewsCellContentConfiguration!

    init(configuration: NewsCellContentConfiguration!) {
        super.init(frame: .zero)
        setup()
        apply(configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func apply(_ configuration: NewsCellContentConfiguration) {
        guard currentConfiguration != configuration else { return }
        
        currentConfiguration = configuration
        
        newsImageView.image = configuration.image
        label.text = configuration.title
    }
}

extension NewsContentView {
    
    private func setup() {
        layer.cornerRadius = 10
        clipsToBounds = true
        layer.borderColor = UIColor.systemPink.cgColor
        layer.borderWidth = 2
        
        setupImageView()
        setupLabel()
    }
    
    private func setupImageView() {
        newsImageView = UIImageView()
        addSubview(newsImageView)
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        newsImageView.clipsToBounds = true
        newsImageView.backgroundColor = .systemPink
        newsImageView.contentMode = .scaleAspectFill
        
        newsImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        newsImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        newsImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        newsImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 9/16).isActive = true
    }
    
    private func setupLabel() {
        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.numberOfLines = 0
        addSubview(label)
        
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset).isActive = true
        let topConstraint = label.topAnchor.constraint(equalTo: newsImageView.bottomAnchor)
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset).isActive = true
        
        topConstraint.priority = .defaultLow
        topConstraint.isActive = true
    }
}

