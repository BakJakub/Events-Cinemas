//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

class CollectionViewManager: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var navigationController: UINavigationController?
    private var viewModel: EventCinemasViewModel
    
    init(viewModel: EventCinemasViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? EventsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let category = viewModel.categories[indexPath.item]
        cell.viewModel = EventsCellViewModel(category: category)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width - 20
        let cellHeight: CGFloat = 100
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = viewModel.categories[indexPath.item]
        let detailsVC = MovieDetailViewController(data: selectedCategory)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

