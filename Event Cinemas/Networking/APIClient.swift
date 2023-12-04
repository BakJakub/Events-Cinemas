//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import Foundation

struct APIClient {

    func fetchData<T: Decodable>(
        from endpoint: Endpoint,
        decodingType: T.Type,
        page: Int = 1,
        completion: @escaping (Result<T>) -> Void
    ) {
        var urlComponents = URLComponents(url: endpoint.absoluteURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        guard let url = urlComponents?.url else {
            completion(.networkError("Invalid URL"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer 6bc7476e8ff99f0594a8e7da29e3ee7e", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                completion(.networkError(error?.localizedDescription ?? "Unknown error"))
                return
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    completion(.serverError(errorResponse))
                } catch {
                    completion(.networkError("Failed to decode error response"))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.networkError("Failed to decode data"))
            }
        }.resume()
    }
}


struct MovieManager {

    private let apiClient: APIClient
    
    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }
    
    func fetchNowPlayingMovies(page: Int, completion: @escaping (Result<[MovieModel]>) -> Void) {
        apiClient.fetchData(from: .nowPlaying, decodingType: [MovieModel].self, page: page) { result in
            completion(result)
        }
    }
    
    func fetchMovieDetails(movieId: Int, completion: @escaping (Result<MovieModel.MovieDetail>) -> Void) {
        apiClient.fetchData(from: .movieDetails(movieId: movieId), decodingType: MovieModel.MovieDetail.self) { result in
            completion(result)
        }
    }
}

