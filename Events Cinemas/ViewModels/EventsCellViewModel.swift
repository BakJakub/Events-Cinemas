//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

protocol EventsCellViewModelProtocol {
    var name: String { get }
    var isFavorite: Bool { get }
    func toggleFavorite()
}

class EventsCellViewModel: EventsCellViewModelProtocol {
    
    let id: Int
    let name: String
    var isFavorite: Bool
    var favoritesManager: FavoritesManager
    
    init(category: MovieDetailResultModel, favoritesManager: FavoritesManager) {
        self.name = category.title
        self.id = category.id
        self.isFavorite = favoritesManager.isMovieFavorite(movieId: id)
        self.favoritesManager = favoritesManager
    }
    
    func toggleFavorite() {
        isFavorite.toggle()
        favoritesManager.toggleFavorite(movieId: id, isFavourite: isFavorite)
    }
    
    func checkIfFavorite() -> Bool {
        return favoritesManager.isMovieFavorite(movieId: id)
    }
}
