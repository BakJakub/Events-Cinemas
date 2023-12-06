//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import XCTest
@testable import Events_Cinemas

class APIClientTests: XCTestCase {
    
    var apiClient: APIClient!
    
    override func setUp() {
        super.setUp()
        apiClient = APIClient()
    }
    
    override func tearDown() {
        apiClient = nil
        super.tearDown()
    }
    
    func testFetchDataSuccess() {
        let expectation = XCTestExpectation(description: "Fetch data successful")
        
        let endpoint = Endpoint.movieDetails(movieId: 623911)

        apiClient.fetchData(from: endpoint, decodingType: MovieResultModel.self) { result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
            case .serverError(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            case .networkError(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchDataFailure() {
        let expectation = XCTestExpectation(description: "Fetch data failure")
        
        let endpoint = Endpoint.movieDetails(movieId: 0000)
        
        apiClient.fetchData(from: endpoint, decodingType: MovieDetailResultModel.self) { result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
            case .serverError(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            case .networkError(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
