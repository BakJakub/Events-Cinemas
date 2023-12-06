//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

protocol EventsCellViewModelProtocol {
    var name: String { get }
    var isFavorite: Bool { get set }
    func toggleFavorite()
    func checkIfFavorite() -> Bool
}

class EventsCellViewModel: EventsCellViewModelProtocol {
    
    let id: Int
    let name: String
    var isFavorite: Bool = false
    
    init(category: MovieDetailResultModel) {
        self.name = category.title
        self.id = category.id
    }
    
    func toggleFavorite() {
        isFavorite.toggle()
        FavoritesManager.shared.toggleFavorite(movieId: id)
    }
    
    func checkIfFavorite() -> Bool {
        return FavoritesManager.shared.isMovieFavorite(movieId: id)
    }
}
