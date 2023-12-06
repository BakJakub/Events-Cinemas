//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

protocol EventsCellViewModelProtocol {
    var name: String { get }
    var isFavorite: Bool { get set }
    func toggleFavorite()
}

class EventsCellViewModel: EventsCellViewModelProtocol {
    
    let name: String
    var isFavorite: Bool = false

    init(category: MovieDetailResultModel) {
        self.name = category.title
    }

    func toggleFavorite() {
        isFavorite.toggle()
    }
}
