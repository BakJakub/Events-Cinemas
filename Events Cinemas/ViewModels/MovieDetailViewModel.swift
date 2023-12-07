//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

class MovieDetailViewModel {
    
    var isLoading = false
    var isFavorite: Bool?
    private(set) var data: MovieDetailResultModel
    private let movieManager: MovieManagerApiRequest
    var favoritesManager = FavoritesManager()
    
    init(data: MovieDetailResultModel, movieManager: MovieManagerApiRequest = MovieManagerApiRequest()) {
        self.data = data
        self.movieManager = movieManager
        self.fetchMovies(movieId: data.id) {_ in}
        self.isFavorite = favoritesManager.isMovieFavorite(movieId: data.id)
    }
    
    func fetchDetailMovies(movieId: Int, completion: @escaping (Bool) -> Void) {
        guard !isLoading else { return }
        isLoading = true
        
        fetchMovies(movieId: movieId) { [weak self] result in
            defer { self?.isLoading = false }
            
            switch result {
            case .success(let movies):
                if let firstMovie = movies.first {
                    self?.data = firstMovie
                    completion(true)
                } else {
                    completion(false)
                }
                
            case .serverError(_), .networkError(_):
                completion(false)
            }
        }
    }
    
    
    func fetchMovies(movieId: Int, completion: @escaping (Result<[MovieDetailResultModel]>) -> Void) {
        movieManager.fetchDetailMovie(movieId: movieId) { response in
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
    
    func fetchMoviePoster(completion: @escaping (UIImage?) -> Void) {
        movieManager.buildLinkImage(data: data) { link in
            if let imageURL = link {
                self.movieManager.fetchImage(withURL: imageURL) { image in
                    DispatchQueue.main.async {
                        completion(image ?? UIImage(named: "placeholder_image"))
                    }
                }
            } else {
                completion(UIImage(named: "placeholder_image"))
            }
        }
    }
    
    func toggleFavorite() {
        if var currentFavorite = isFavorite {
            currentFavorite.toggle()
            isFavorite = currentFavorite
            favoritesManager.toggleFavorite(movieId: data.id, isFavourite: currentFavorite)
        }
    }
}
