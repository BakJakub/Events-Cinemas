//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

protocol SearchControllerManagerDelegate: AnyObject {
    func didChangeSearchText(_ searchText: String)
}

class SearchControllerManager: NSObject, UISearchBarDelegate {

    weak var delegate: SearchControllerManagerDelegate?

    func setupSearchController(with searchBar: UISearchBar) {
        searchBar.delegate = self
        searchBar.placeholder = "Search Movies"
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.didChangeSearchText(searchText)
    }
}
