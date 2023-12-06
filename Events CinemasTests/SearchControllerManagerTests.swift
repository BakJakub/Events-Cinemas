//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import XCTest
@testable import Events_Cinemas

class SearchControllerManagerTests: XCTestCase {
    
    var sut: SearchControllerManager<String>!
    var searchBar: UISearchBar!
    var autocompleteViewController: AutocompleteViewController!
    
    override func setUp() {
        super.setUp()
        sut = SearchControllerManager<String>()
        searchBar = UISearchBar()
        autocompleteViewController = AutocompleteViewController()
    }

    override func tearDown() {
        sut = nil
        searchBar = nil
        autocompleteViewController = nil
        super.tearDown()
    }
    
    func testSetupSearchController() {
        sut.setupSearchController(with: searchBar, autocompleteViewController: autocompleteViewController)
        
        XCTAssertEqual(searchBar.delegate as? SearchControllerManager, sut)
        XCTAssertEqual(searchBar.placeholder, "Search Movies")
        XCTAssertNotNil(sut.autocompleteViewController)
    }
    
    func testSearchBarTextDidChange() {
        let expectation = self.expectation(description: "Search text changed")
        
        class MockDelegate: SearchControllerManagerDelegate {
            var didChangeSearchTextCalled = false
            func didChangeSearchText(_ searchText: String) {
                didChangeSearchTextCalled = true
            }
        }
        
        let mockDelegate = MockDelegate()
        sut.delegate = mockDelegate
        sut.setupSearchController(with: searchBar, autocompleteViewController: autocompleteViewController)
        
        let searchText = "TestSearchText"
        searchBar.text = searchText
        sut.searchBar(searchBar, textDidChange: searchText)
        
        XCTAssertTrue(mockDelegate.didChangeSearchTextCalled)
        
        expectation.fulfill()
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testTextFieldShouldBeginEditing() {
        class MockDelegate: SearchBarTextDelegate {
            var didChangeSearchTextValueCalled = false
            func didChangeSearchTextValue(_ searchText: String) {
                didChangeSearchTextValueCalled = true
            }
        }
        
        let mockDelegate = MockDelegate()
        sut.delegateSearchBarText = mockDelegate
        sut.setupSearchController(with: searchBar, autocompleteViewController: autocompleteViewController)
        
        let searchText = "TestSearchText"
        searchBar.searchTextField.text = searchText
        let shouldBeginEditing = sut.textFieldShouldBeginEditing(searchBar.searchTextField)
        XCTAssertTrue(shouldBeginEditing)
    }
}
