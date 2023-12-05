//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import Foundation

struct APIClient {
    
    func fetchData<T: Decodable>(
        from endpoint: Endpoint,
        decodingType: T.Type,
        page: Int = 1,
        additionalParams: [String: String] = [:], // Dodatkowe parametry
        completion: @escaping (Result<T>) -> Void
    ) {
        var urlComponents = URLComponents(url: endpoint.absoluteURL, resolvingAgainstBaseURL: true)
        
        var queryItems = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        guard let url = urlComponents?.url else {
            completion(.networkError("Invalid URL"))
            return
        }
        
        for (key, value) in additionalParams {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            completion(.networkError("Invalid URL"))
            return
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2YmM3NDc2ZThmZjk5ZjA1OTRhOGU3ZGEyOWUzZWU3ZSIsInN1YiI6IjY1NmRhZWE0ODg2MzQ4MDBjOWUyMjA2NyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.V29W4RvpwbJ0UZh2d2OBshXzRsSJ70q22KDwXP7PLv4", forHTTPHeaderField: "Authorization")
        print(request)
        print(request.allHTTPHeaderFields)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                completion(.networkError(error?.localizedDescription ?? "Unknown error"))
                return
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                print(httpResponse.statusCode)
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
    
    func fetchNowPlayingMovies(page: Int, completion: @escaping (Result<MovieResultModel>) -> Void) {
        apiClient.fetchData(from: .nowPlaying, decodingType: MovieResultModel.self, page: page) { result in
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
    
}

