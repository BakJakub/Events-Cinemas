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

    init(category: EventsCinemaModel, isFavorite: Bool = false) {
        self.name = category.name
        self.background = category.background
        self.isFavorite = isFavorite
    }

    func toggleFavorite() {
        isFavorite.toggle()
    }
}
