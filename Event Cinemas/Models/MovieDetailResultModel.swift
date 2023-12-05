//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import Foundation

struct MovieDetailResultModel: Codable {
    
    let id: Int
    let title: String
    let releaseDate: String?
    let voteAverage: Double?
    let overview: String?
    let backdropPath: String?
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.releaseDate = try? container.decode(String.self, forKey: .releaseDate)
        self.voteAverage = try? container.decode(Double.self, forKey: .voteAverage)
        self.overview = try? container.decode(String.self, forKey: .overview)
        self.backdropPath = try? container.decode(String.self, forKey: .backdropPath)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, releaseDate = "release_date", backdropPath = "backdrop_path", voteAverage = "vote_average", overview
    }
}
