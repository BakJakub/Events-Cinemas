//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

protocol SearchControllerManagerDelegate: AnyObject {
    func didChangeSearchText(_ searchText: String)
}

protocol SearchBarTextDelegate: AnyObject {
    func didChangeSearchTextValue(_ searchText: String)
}

class SearchControllerManager: NSObject, UISearchBarDelegate {
    
    weak var delegate: SearchControllerManagerDelegate?
    weak var autocompleteViewController: AutocompleteViewController?
    weak var delegateSearchBarText: SearchBarTextDelegate?
    
    func setupSearchController(with searchBar: UISearchBar, autocompleteViewController: AutocompleteViewController) {
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
        searchBar.placeholder = "Search Movies"
        self.autocompleteViewController = autocompleteViewController
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.didChangeSearchText(searchText)
        
        let results = ""
        autocompleteViewController?.autocompleteResults = [results]
        autocompleteViewController?.tableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        guard let autocompleteVC = autocompleteViewController else { return false }
        return true
    }
}

extension SearchControllerManager: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let text = textField.text, text.isEmpty {
            delegateSearchBarText?.didChangeSearchTextValue(text)
        }
        return true
    }
    
}
