//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import Foundation

protocol FavoritesManagerObserver: AnyObject {
    func favoritesDidChange()
}

struct FavoritesManager {
    private let userDefaults = UserDefaults.standard
    private let favoritesKey = "FavoriteMovies"
    private var observers = NSHashTable<AnyObject>.weakObjects()

    mutating func addObserver(_ observer: FavoritesManagerObserver) {
        observers.add(observer)
    }

    mutating func removeObserver(_ observer: FavoritesManagerObserver) {
        observers.remove(observer)
    }

    private func notifyObservers() {
        for observer in observers.allObjects {
            if let observer = observer as? FavoritesManagerObserver {
                observer.favoritesDidChange()
            }
        }
    }

    mutating func toggleFavorite(movieId: Int, isFavourite: Bool) {
        var favorites = userDefaults.array(forKey: favoritesKey) as? [Int] ?? []

        let isCurrentlyFavourite = isMovieFavorite(movieId: movieId)

        if isFavourite && !isCurrentlyFavourite {
            favorites.append(movieId)
        } else if !isFavourite && isCurrentlyFavourite {
            if let index = favorites.firstIndex(of: movieId) {
                favorites.remove(at: index)
            }
        }

        userDefaults.set(favorites, forKey: favoritesKey)
        
        if let updatedFavorites = userDefaults.array(forKey: favoritesKey) as? [Int], updatedFavorites == favorites {
            notifyObservers()
        } else {
            print("Problem save data")
        }
    }

    func isMovieFavorite(movieId: Int) -> Bool {
        let favorites = userDefaults.array(forKey: favoritesKey) as? [Int] ?? []
        return favorites.contains(movieId)
    }
}
