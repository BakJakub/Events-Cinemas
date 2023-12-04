//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import Foundation

struct EventsCinemaModel {
    let id: Int
    let name: String
    let background: String

    init(id: Int, name: String, background: String) {
        self.id = id
        self.name = name
        self.background = background
    }
}
