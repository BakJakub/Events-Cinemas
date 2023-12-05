//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

struct MovieManagerApiRequest {
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }
    
    func fetchNowPlayingMovies(page: Int, completion: @escaping (Result<MovieResultModel>) -> Void) {
        apiClient.fetchData(
            from: .nowPlaying,
            decodingType: MovieResultModel.self,
            page: page) { result in
                completion(result)
            }
    }
    
    func fetchSearchMovies(page: Int, searchText: String, completion: @escaping (Result<MovieResultModel>) -> Void) {
        let additionalParams = ["query": searchText]
        apiClient.fetchData(
            from: .searchMovie,
            decodingType: MovieResultModel.self,
            page: page,
            additionalParams: additionalParams) { result in
                completion(result)
            }
    }
    
    func fetchDetailMovie(movieId: Int, completion: @escaping (Result<MovieDetailResultModel>) -> Void) {
        apiClient.fetchData(
            from: .movieDetails(movieId: movieId),
            decodingType: MovieDetailResultModel.self) { result in
                completion(result)
            }
    }
    
    func buildLinkImage(data: MovieDetailResultModel, completion: @escaping (URL?) -> Void) {
        guard let backdropPath = data.backdropPath else {
            completion(nil)
            return
        }
        
        let baseURLString = "https://image.tmdb.org/t/p/"
        let fileSize = "w300"
        
        let fullImageURLString = baseURLString + fileSize + "/" + backdropPath
        
        guard let imageURL = URL(string: fullImageURLString) else {
            completion(nil)
            return
        }
        
        completion(imageURL)
    }
    
    func fetchImage(withURL imageURL: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            if let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
}
