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
    
    private typealias DataSource = UICollectionViewDiffableDataSource<CollectionSection, NewsModel>
    private typealias DataSnapshot = NSDiffableDataSourceSnapshot<CollectionSection, NewsModel>
    
    private typealias CellRegistration = UICollectionView.CellRegistration<NewsCollectionViewCell, NewsModel>
    
    private let viewModel: NewsViewModel
    
    private var collectionView: UICollectionView!
    
    private var dataSource: DataSource!
    
    private var news: [NewsModel] = []
    
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
        getNewsImage(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        
        let vc = DetailViewController(news: news[index])
        let delegate = DetailScreenTransitionDelegate()
        vc.transitioningDelegate = delegate
        vc.modalPresentationStyle = .custom
        present(vc, animated: true)
    }
}

extension NewsViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            getNewsImage(indexPath)
        }
    }
}

extension NewsViewController {
    
    private func setupCollectionView() {
        let layout = UIDevice.current.userInterfaceIdiom == .pad ? getPadCollectionLayout() : getPhoneCollectionLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
    }
    
    private func getPhoneCollectionLayout() -> UICollectionViewCompositionalLayout {
        let horizontalInset: CGFloat = 20
        let verticalInset: CGFloat = 10
        let estimatedWidth: CGFloat = view.frame.width - (horizontalInset * 2)
        let estimatedHeight: CGFloat = estimatedWidth * 0.75
        
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(estimatedHeight)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: verticalInset, leading: horizontalInset, bottom: verticalInset, trailing: horizontalInset)
        
        section.interGroupSpacing = 24
        return UICollectionViewCompositionalLayout(section: section)
        
    }
    
    
    
    private func getPadCollectionLayout() -> UICollectionViewCompositionalLayout {
        let horizontalInset: CGFloat = 36
        let verticalInset: CGFloat = 24
        let gridSpacing: CGFloat = 24
        let estimatedWidth: CGFloat = (view.frame.width - ((horizontalInset * 2) + gridSpacing)) / 2
        let estimatedHeight: CGFloat = estimatedWidth * 0.75
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(estimatedWidth), heightDimension: .fractionalHeight(1.0))
        
        let mainGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        group.interItemSpacing = .fixed(gridSpacing)
        
        let mainGroup = NSCollectionLayoutGroup.horizontal(layoutSize: mainGroupSize, subitem: group, count: 2)
        
        mainGroup.interItemSpacing = .fixed(gridSpacing)
        
        let section = NSCollectionLayoutSection(group: mainGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: verticalInset, leading: horizontalInset, bottom: verticalInset, trailing: horizontalInset)
        section.interGroupSpacing = gridSpacing
        return UICollectionViewCompositionalLayout(section: section)
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
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: model)
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
    
    private func getNewsImage(_ indexPath: IndexPath) {
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
    
    private func updateData(index: Int) {
        var snapshot = dataSource.snapshot()
        
        snapshot.reloadItems([news[index]])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

    
