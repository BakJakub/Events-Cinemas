//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import Foundation

class FavoritesManager {
    static let shared = FavoritesManager()

    private let userDefaults = UserDefaults.standard
    private let favoritesKey = "FavoriteMovies"

    func toggleFavorite(movieId: Int) {
        var favorites = userDefaults.array(forKey: favoritesKey) as? [Int] ?? []

        if let index = favorites.firstIndex(of: movieId) {
            favorites.remove(at: index)
        } else {
            favorites.append(movieId)
        }

        userDefaults.set(favorites, forKey: favoritesKey)
        userDefaults.synchronize()
    }

    func isMovieFavorite(movieId: Int) -> Bool {
        let favorites = userDefaults.array(forKey: favoritesKey) as? [Int] ?? []
        return favorites.contains(movieId)
    }
}
