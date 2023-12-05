//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

protocol EventsCellViewModelProtocol {
    var name: String { get }
    var background: String { get }
    var isFavorite: Bool { get set }
    func toggleFavorite()
}

class EventsCellViewModel: EventsCellViewModelProtocol {
    let name: String
    let background: String
    var isFavorite: Bool

    init(category: MovieDetailResultModel, isFavorite: Bool = false) {
        self.name = category.title
        self.background = category.posterPath
        self.isFavorite = category.video
    }

    func toggleFavorite() {
        isFavorite.toggle()
    }
}
