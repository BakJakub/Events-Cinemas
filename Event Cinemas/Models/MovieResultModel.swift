//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import Foundation
import UIKit

struct MovieResultModel: Codable {
    
    let page: Int
    let results: [MovieDetailResultModel]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.page = try container.decode(Int.self, forKey: .page)
        
        if let resultsArray = try? container.decode([MovieDetailResultModel].self, forKey: .results) {
            self.results = resultsArray
        } else {
            self.results = []
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case page, results
    }
}

struct Dates: Codable {
    let maximum, minimum: String
}

struct MovieDetailResultModel: Codable {
    let id: Int
    let title: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title
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
