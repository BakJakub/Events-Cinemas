//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import Foundation

protocol EventsCinemasDelegate: AnyObject {
    func categoriesFetched()
}

class EventsCinemasViewModel {
    
    var categories: [MovieDetailResultModel] = []
    weak var delegate: EventsCinemasDelegate?
    private let movieManager: MovieManagerApiRequest
//    private let favoriteKey = "FavoriteMovies"
  
    private var currentPage = 0
    var isFetching = false
    
    init(movieManager: MovieManagerApiRequest = MovieManagerApiRequest()) {
        self.movieManager = movieManager
    }
    
    func fetchCategories() {
        fetchNextPage()
    }
    
    func getFilteredCategory(at index: Int) -> MovieDetailResultModel? {
        categories.indices.contains(index) ? categories[index] : nil
    }
    
    func toggleFavoriteStatus(at index: Int) {
        guard var category = getFilteredCategory(at: index) else { return }
        category.toggleFavorite() // Wywołuje funkcję toggleFavorite na wybranej kategorii
        categories[index] = category // Zapisuje zaktualizowaną kategorię z powrotem do tablicy
        delegate?.categoriesFetched()
    }
    
    func isFavorite(at index: Int) -> Bool {
        let category = getFilteredCategory(at: index)
        return category?.isFavorite ?? false // Zwraca stan ulubionego, jeśli istnieje, w przeciwnym razie zwraca false
    }
    
    func fetchNextPage() {
        guard !isFetching else { return }
        isFetching = true
        
        currentPage += 1
        fetchMovies(page: currentPage) { [weak self] result in
            self?.isFetching = false
            switch result {
            case .success(let movies):
                self?.categories.append(contentsOf: movies)
                self?.delegate?.categoriesFetched()
            case .serverError(_), .networkError(_):
                break
            }
        }
    }
    
    func fetchMovies(page: Int, completion: @escaping (Result<[MovieDetailResultModel]>) -> Void) {
        movieManager.fetchNowPlayingMovies(page: page) { response in
            switch response {
            case .success(let data):
                completion(.success(data.results))
            case .serverError(let serverError):
                completion(.serverError(serverError))
            case .networkError(let networkErrorMessage):
                completion(.networkError(networkErrorMessage))
            }
        }
    }
}
