//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import Foundation

enum Endpoint {
    
    static let baseURL: String  = "https://api.themoviedb.org/3/"

    case nowPlaying, popular, topRated, upcoming, searchMovie, movieDetails(movieId: Int)
    
    func path() -> String {
        switch self {
        case .nowPlaying:
            return "movie/now_playing"
        case .popular:
            return "movie/popular"
        case .topRated:
            return "movie/top_rated"
        case .upcoming:
            return "movie/upcoming"
        case .searchMovie:
            return "search/movie"
        case .movieDetails(movieId: let movieId):
            return "movie/\(movieId)"
        }
    }
    
    var absoluteURL: URL {
        URL(string: Endpoint.baseURL + self.path())!
    }
}
