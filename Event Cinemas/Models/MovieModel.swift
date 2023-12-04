//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import Foundation
import UIKit

struct MovieModel: Decodable {
    let page: Int
    let results: [MovieDetail]
    let totalPages: Int
    let totalResults: Int
    var additionalData: [String: Any]?

    struct MovieDetail: Decodable {
        let adult: Bool
        let backdropPath: String?
        let genreIDs: [Int]
        let id: Int
        let originalLanguage: String
        let originalTitle: String
        let overview: String
        let popularity: Double
        let posterPath: String?
        let releaseDate: String
        let title: String
        let video: Bool
        let voteAverage: Double
        let voteCount: Int
        var additionalData: [String: Any]?

        enum CodingKeys: String, CodingKey {
            case adult
            case backdropPath = "backdrop_path"
            case genreIDs = "genre_ids"
            case id
            case originalLanguage = "original_language"
            case originalTitle = "original_title"
            case overview
            case popularity
            case posterPath = "poster_path"
            case releaseDate = "release_date"
            case title
            case video
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
        }
    }

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.page = try container.decode(Int.self, forKey: .page)
        self.totalPages = try container.decode(Int.self, forKey: .totalPages)
        self.totalResults = try container.decode(Int.self, forKey: .totalResults)
        self.results = try container.decode([MovieDetail].self, forKey: .results)

        var dynamicData = [String: Any]()
        let dynamicKeysContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        for key in dynamicKeysContainer.allKeys {
            dynamicData[key.stringValue] = try dynamicKeysContainer.decode(AnyDecodable.self, forKey: key).value
        }
        self.additionalData = dynamicData.isEmpty ? nil : dynamicData
    }
}

struct AnyDecodable: Decodable {
    let value: Any

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            value = intValue
        } else if let doubleValue = try? container.decode(Double.self) {
            value = doubleValue
        } else if let boolValue = try? container.decode(Bool.self) {
            value = boolValue
        } else if let stringValue = try? container.decode(String.self) {
            value = stringValue
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported type")
        }
    }
}

struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        return nil
    }
}
