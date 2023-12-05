//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import Foundation

protocol EventCinemasDelegate: AnyObject {
    func categoriesFetched()
    func filteredCategoriesUpdated(categories: [MovieDetailResultModel])
}

class EventCinemasViewModel {
    
    weak var delegate: EventCinemasDelegate?
    private let movieManager: MovieManager
    private let favoriteKey = "FavoriteMovies"
    
    //var categories: [EventsCinemaModel] = []
    var categories: [MovieDetailResultModel] = []

    var filteredCategories: [MovieDetailResultModel] = []
    
    
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
//        categories = [
//            EventsCinemaModel(id: 1, name: "Apartments", background: "apartments-category"),
//            EventsCinemaModel(id: 2, name: "Houses", background: "home-category"),
//            EventsCinemaModel(id: 3, name: "Houses2", background: "home-category2"),
//        ]
        
        fetchNowPlayingMovies(page: 1) { res in
            
        }
        //fetchMovies()
        delegate?.categoriesFetched()
    }
    
    func getFilteredCategory(at index: Int) -> MovieDetailResultModel? {
        if isFiltering {
            return filteredCategories.indices.contains(index) ? filteredCategories[index] : nil
        } else {
            return categories.indices.contains(index) ? categories[index] : nil
        }
    }
    
    func updateSearchText(_ text: String) {
        currentSearchText = text
    }
    
    func searchCategories(for query: String) -> [MovieDetailResultModel] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        return categories.filter { $0.title.range(of: trimmedQuery, options: .caseInsensitive) != nil }
    }
    
    func searchCategoriesAndUpdate() {
        let filtered = searchCategories(for: currentSearchText)
        filteredCategories = filtered
        delegate?.filteredCategoriesUpdated(categories: filteredCategories)
    }
    
    func toggleFavoriteStatus(at index: Int) {
        guard let category = getFilteredCategory(at: index) else { return }
        var favoriteMovies = UserDefaults.standard.array(forKey: favoriteKey) as? [String] ?? []
        
        if let index = favoriteMovies.firstIndex(of: category.title) {
            favoriteMovies.remove(at: index)
        } else {
            favoriteMovies.append(category.title)
        }
        
        UserDefaults.standard.set(favoriteMovies, forKey: favoriteKey)
        delegate?.categoriesFetched()
    }
    
    func isFavorite(at index: Int) -> Bool {
        guard let category = getFilteredCategory(at: index) else { return false }
        let favoriteMovies = UserDefaults.standard.array(forKey: favoriteKey) as? [String] ?? []
        return favoriteMovies.contains(category.title)
    }
    

    func fetchNowPlayingMovies(page: Int, completion: @escaping (Result<[MovieResultModel]>) -> Void) {
        movieManager.fetchNowPlayingMovies(page: page) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.categories = movies.results
                self?.delegate?.categoriesFetched()
                //completion(.success(movies))
          
            case .serverError(_): break
                
                
            case .networkError(_): break
                
            }
        }
    }
}
