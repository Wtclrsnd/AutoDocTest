//
//  DetailViewController.swift
//  AutoDocTest
//
//  Created by Emil Shpeklord on 03.03.2024.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private let contentInset: CGFloat = 20
    private let news: NewsModel
    
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        return panGesture
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(news: NewsModel) {
        self.news = news
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        imageView.image = news.titleImage
        titleLabel.text = news.title
        let date = parseDate(string: news.publishedDate)
        dateLabel.text = "Опубликовано: " + formatDate(date: date) + "\n" + news.categoryType.rawValue
        descriptionLabel.text = news.description
    }
}

extension DetailViewController {
    
    @objc private func handlePan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        switch sender.state {
        case .changed:
            if translation.y > 0 {
                view.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        case .ended:
            if translation.y > 100 {
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.transform = .identity
                }
            }
        default:
            break
        }
    }
    
    private func parseDate(string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.date(from: string) ?? Date()
    }
    
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    private func setupUI() {
        view.addGestureRecognizer(panGestureRecognizer)
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.systemPink.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 20
        
        setupImageView()
        setuptitleLabel()
        setupDateLabel()
        setupDescriptionLabel()
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9/16).isActive = true
    }
    
    private func setuptitleLabel() {
        view.addSubview(titleLabel)
        
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: contentInset).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: contentInset).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -contentInset).isActive = true
    }
    
    private func setupDateLabel() {
        view.addSubview(dateLabel)
        
        dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: contentInset).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: contentInset).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -contentInset).isActive = true
    }
    
    private func setupDescriptionLabel() {
        view.addSubview(descriptionLabel)
        
        descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: contentInset).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: contentInset).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -contentInset).isActive = true
    }
}

