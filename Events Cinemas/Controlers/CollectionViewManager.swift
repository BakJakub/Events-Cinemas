//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

class CollectionViewManager: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var eventsCinemasDelegate: EventsCinemasSelectedDelegate?
    weak var navigationController: UINavigationController?
    private var viewModel: EventsCinemasViewModel
    private let cellIdentifier = "CategoryCell"
    private let cellHeight: CGFloat = 100
    private let cellInsets: CGFloat = 20
    private var collectionView: UICollectionView? // Referencja do kolekcji
    
    init(viewModel: EventsCinemasViewModel, navigationController: UINavigationController? = nil) {
        self.viewModel = viewModel
        self.navigationController = navigationController
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? EventsCollectionViewCell else {
            fatalError("Unable to dequeue cell with identifier: \(cellIdentifier)")
        }
        
        let category = viewModel.categories[indexPath.item]
        let favoritesManager = FavoritesManager()
        let cellViewModel = EventsCellViewModel(category: category, favoritesManager: favoritesManager)
        cell.viewModel = cellViewModel
        cell.favoriteButton.tag = indexPath.item
        cell.favoriteButton.isSelected = cellViewModel.isFavorite
        
        cell.favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)
        
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
    
    @objc func favoriteButtonTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? EventsCollectionViewCell,
              let indexPath = collectionView?.indexPath(for: cell),
              let viewModel = cell.viewModel else { return }

        viewModel.toggleFavorite()
        sender.isSelected = viewModel.isFavorite
    }
}
