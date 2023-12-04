//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import Foundation

enum Result<T> {
    case success(_ response: T)
    case serverError(_ err: ErrorResponse)
    case networkError(_ err: String)
}
