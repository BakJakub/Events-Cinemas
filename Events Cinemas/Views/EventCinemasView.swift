//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

struct EventCinemasViewBuilder {
    static func buildCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(EventsCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCell")
        collectionView.backgroundColor = .clear

        return collectionView
    }
}
