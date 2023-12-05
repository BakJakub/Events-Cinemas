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
