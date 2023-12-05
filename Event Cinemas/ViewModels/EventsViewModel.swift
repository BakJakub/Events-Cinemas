//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import Foundation

protocol EventsViewModelDelegate: AnyObject {
    func categoriesFetched()
    func filteredCategoriesUpdated(categories: [EventsCinemaModel])
}

class EventsViewModel {
    
    weak var delegate: EventsViewModelDelegate?
    private let movieManager: MovieManager
    private let favoriteKey = "FavoriteMovies"
    
    var categories: [EventsCinemaModel] = []
    var categories2: [MovieDetailResultModel] = []

    var filteredCategories: [EventsCinemaModel] = []
    
    
    init(movieManager: MovieManager = MovieManager()) {
        self.movieManager = movieManager
    }
    
    var currentSearchText = "" {
        didSet {
            searchCategoriesAndUpdate()
        }
    }
    
    var isFiltering: Bool {
        !currentSearchText.isEmpty
    }
    
    func fetchCategories() {
        categories = [
            EventsCinemaModel(id: 1, name: "Apartments", background: "apartments-category"),
            EventsCinemaModel(id: 2, name: "Houses", background: "home-category"),
            EventsCinemaModel(id: 3, name: "Houses2", background: "home-category2"),
        ]
        
        fetchNowPlayingMovies(page: 1) { res in
            
        }
        //fetchMovies()
        delegate?.categoriesFetched()
    }
    
    func getFilteredCategory(at index: Int) -> EventsCinemaModel? {
        if isFiltering {
            return filteredCategories.indices.contains(index) ? filteredCategories[index] : nil
        } else {
            return categories.indices.contains(index) ? categories[index] : nil
        }
    }
    
    func updateSearchText(_ text: String) {
        currentSearchText = text
    }
    
    func searchCategories(for query: String) -> [EventsCinemaModel] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        return categories.filter { $0.name.range(of: trimmedQuery, options: .caseInsensitive) != nil }
    }
    
    func searchCategoriesAndUpdate() {
        let filtered = searchCategories(for: currentSearchText)
        filteredCategories = filtered
        delegate?.filteredCategoriesUpdated(categories: filteredCategories)
    }
    
    func toggleFavoriteStatus(at index: Int) {
        guard let category = getFilteredCategory(at: index) else { return }
        var favoriteMovies = UserDefaults.standard.array(forKey: favoriteKey) as? [String] ?? []
        
        if let index = favoriteMovies.firstIndex(of: category.name) {
            favoriteMovies.remove(at: index)
        } else {
            favoriteMovies.append(category.name)
        }
        
        UserDefaults.standard.set(favoriteMovies, forKey: favoriteKey)
        delegate?.categoriesFetched()
    }
    
    func isFavorite(at index: Int) -> Bool {
        guard let category = getFilteredCategory(at: index) else { return false }
        let favoriteMovies = UserDefaults.standard.array(forKey: favoriteKey) as? [String] ?? []
        return favoriteMovies.contains(category.name)
    }
    

    func fetchNowPlayingMovies(page: Int, completion: @escaping (Result<[MovieResultModel]>) -> Void) {
        movieManager.fetchNowPlayingMovies(page: page) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.categories2 = movies.results
                self?.delegate?.categoriesFetched()
                //completion(.success(movies))
          
            case .serverError(_): break
                
                
            case .networkError(_): break
                
            }
        }
    }
}
