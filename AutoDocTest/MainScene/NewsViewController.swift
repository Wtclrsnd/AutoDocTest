//
//  ViewController.swift
//  AutoDocTest
//
//  Created by Emil Shpeklord on 03.03.2024.
//

import UIKit

class NewsViewController: UIViewController {
    
    private enum CollectionSection: Int, Hashable {
        
        case content
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<CollectionSection, NewsContent>
    private typealias DataSnapshot = NSDiffableDataSourceSnapshot<CollectionSection, NewsContent>
    
    private typealias CellRegistration = UICollectionView.CellRegistration<NewsCollectionViewCell, NewsContent>
    
    private let viewModel: NewsViewModel
    
    private var collectionView: UICollectionView!
    
    private var dataSource: DataSource!
    
    private var news: [NewsContent] = []
    
    init(vm: NewsViewModel) {
        self.viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        
        Task {
            guard let news = await viewModel.getNews() else { return }
            self.news = news
            setupDataSource()
        }
    }
    
    
}

extension NewsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let index = indexPath.item
        guard news[index].titleImage == nil else { return }
        let url = news[index].titleImageURL
        Task {
            let image = await viewModel.getImage(url)
            news[index].titleImage = image
            
            await MainActor.run {
                updateData(index: index)
            }
        }
    }
}

extension NewsViewController {
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: getPhoneCollectionLayout())
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        collectionView.backgroundColor = .white
        collectionView.delegate = self
    }
    
    private func getPhoneCollectionLayout() -> UICollectionViewCompositionalLayout {
        let gridSpacing: CGFloat = 10
        let contentSectionInset: CGFloat = 10
        let interGroupSpacing: CGFloat = 10
        
        let contentItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let contentGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let contentItem = NSCollectionLayoutItem(layoutSize: contentItemSize)
        
        let contentGroup = NSCollectionLayoutGroup.vertical(layoutSize: contentGroupSize, subitems: [contentItem])
        contentGroup.interItemSpacing = .fixed(gridSpacing)
        
        let contentSection = NSCollectionLayoutSection(group: contentGroup)
        contentSection.contentInsets = NSDirectionalEdgeInsets(top: contentSectionInset, leading: contentSectionInset, bottom: contentSectionInset, trailing: contentSectionInset)
        contentSection.interGroupSpacing = interGroupSpacing
        
        return UICollectionViewCompositionalLayout(section: contentSection)
    }
    
    
    private func setupDataSource() {
        let cellRegistration = CellRegistration { cell, _, content in
            cell.model = content
        }
        
        dataSource = getDataSource(cellRegistration)
        
        collectionView.dataSource = dataSource
        applyData()
        
    }
    
    private func getDataSource(_ cellRegistration: CellRegistration) -> DataSource {
        DataSource(collectionView: collectionView) {
            collectionView, indexPath, model -> UICollectionViewCell in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                         for: indexPath,
                                                         item: model)
        }
    }
    
    
    private func applyData() {
        var snapshot = DataSnapshot()
        snapshot.appendSections([.content])
        snapshot.appendItems(news, toSection: .content)
        
        
        dataSource.apply(snapshot, animatingDifferences: true) { [weak self] in
            self?.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    private func updateData(index: Int) {
        var snapshot = dataSource.snapshot()
        
        snapshot.reloadItems([news[index]])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}


