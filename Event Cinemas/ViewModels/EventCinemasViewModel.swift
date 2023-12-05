//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import Foundation

protocol EventCinemasDelegate: AnyObject {
    func categoriesFetched()
    func filteredCategoriesUpdated(categories: [MovieDetailResultModel])
}

class EventCinemasViewModel {
    
    var categories: [MovieDetailResultModel] = []
    weak var delegate: EventCinemasDelegate?
    private let movieManager: MovieManager
    private let favoriteKey = "FavoriteMovies"
    private var currentPage = 0
    var isFetching = false
    
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
        fetchNextPage()
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
    
    func fetchNextPage() {
        guard !isFetching else { return }
        isFetching = true
        
        currentPage += 1
        fetchMovies(page: currentPage) { [weak self] result in
            self?.isFetching = false
            switch result {
            case .success(let movies):
                if let movieResults = movies.first?.results {
                    self?.categories.append(contentsOf: movieResults)
                    self?.delegate?.categoriesFetched()
                }
                self?.delegate?.categoriesFetched()
            case .serverError(_), .networkError(_):
                break
            }
        }
    }
    
    func fetchMovies(page: Int, completion: @escaping (Result<[MovieResultModel]>) -> Void) {
        movieManager.fetchNowPlayingMovies(page: page) { [weak self]  response in
            switch response {
            case .success(let data):
                completion(.success([data]))
            case .serverError(let serverError):
                completion(.serverError(serverError))
            case .networkError(let networkErrorMessage):
                completion(.networkError(networkErrorMessage))
            }
        }
    }
}
