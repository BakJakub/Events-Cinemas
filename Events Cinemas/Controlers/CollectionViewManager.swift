//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

class CollectionViewManager: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var eventsCinemasDelegate: EventsCinemasSelectedDelegate?
    weak var navigationController: UINavigationController?
    private var viewModel: EventsCinemasViewModel
    var favoritesManager = FavoritesManager()
    private let cellIdentifier = "CategoryCell"
    private let cellHeight: CGFloat = 100
    private let cellInsets: CGFloat = 20
    private var collectionView: UICollectionView?
    
    init(viewModel: EventsCinemasViewModel, navigationController: UINavigationController? = nil) {
        self.viewModel = viewModel
        self.navigationController = navigationController
        super.init()
        favoritesManager.addObserver(self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? EventsCollectionViewCell else {
            fatalError("Unable to dequeue cell with identifier: \(cellIdentifier)")
        }
        
        let category = viewModel.categories[indexPath.item]
        let cellViewModel = EventsCellViewModel(category: category, favoritesManager: favoritesManager)
        cell.viewModel = cellViewModel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width - (2 * cellInsets)
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = viewModel.categories[indexPath.item]
        eventsCinemasDelegate?.didSelectCategory(selectedCategory)
    }
    
    func setCollectionViewReference(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
}

extension CollectionViewManager: FavoritesManagerObserver {
    
    func favoritesDidChange() {
        collectionView?.reloadData()
    }
}
