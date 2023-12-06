//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import Foundation

struct APIClient {
    
    private let urlCache: URLCache = {
        let memoryCapacity = 4 * 1024 * 1024
        let diskCapacity = 20 * 1024 * 1024
        let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "myCache")
        return cache
    }()
    
    init() {
        URLCache.shared = urlCache
    }
    
    func fetchData<T: Decodable>(
        from endpoint: Endpoint,
        decodingType: T.Type,
        page: Int = 1,
        additionalParams: [String: String] = [:],
        completion: @escaping (Result<T>) -> Void
    ) {
        var urlComponents = URLComponents(url: endpoint.absoluteURL, resolvingAgainstBaseURL: true)
        
        var queryItems = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "\(page)")
        ]

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
        
        if let cachedResponse = urlCache.cachedResponse(for: request), let httpResponse = cachedResponse.response as? HTTPURLResponse {
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
            if let dateStr = httpResponse.allHeaderFields["Date"] as? String, let responseDate = dateFormatter.date(from: dateStr) {
                let dataAge = currentDate.timeIntervalSince(responseDate)
                let cacheValidity = 60 * 60 * 24
                
                if Int(dataAge) < cacheValidity {
                    if let decodedData = try? JSONDecoder().decode(T.self, from: cachedResponse.data) {
                        completion(.success(decodedData))
                        return
                    }
                }
            }
        }

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
                let cachedData = CachedURLResponse(response: httpResponse, data: data)
                self.urlCache.storeCachedResponse(cachedData, for: request)
                completion(.success(decodedData))
            } catch {
                completion(.networkError("Failed to decode data"))
            }
        }.resume()
    }
}
