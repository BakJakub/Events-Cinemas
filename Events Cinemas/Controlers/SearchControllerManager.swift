//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

protocol SearchControllerManagerDelegate: AnyObject {
    func didChangeSearchText(_ searchText: String)
}

protocol SearchBarTextDelegate: AnyObject {
    func didChangeActiveStatus(_ active: Bool)
}

class SearchControllerManager<T>: NSObject, UISearchBarDelegate, UITextFieldDelegate {
    
    weak var delegate: SearchControllerManagerDelegate?
    weak var autocompleteViewController: AutocompleteViewController?
    weak var delegateSearchBarText: SearchBarTextDelegate?
    
    func setupSearchController(with searchBar: UISearchBar, autocompleteViewController: AutocompleteViewController) {
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
        searchBar.placeholder = "Search Movies"

        self.autocompleteViewController = autocompleteViewController
        
        if let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black] as [NSAttributedString.Key: Any]? {
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(cancelButtonAttributes, for: .normal)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.didChangeSearchText(searchText)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        guard autocompleteViewController != nil else { return false }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let text = textField.text, text.isEmpty {
            delegateSearchBarText?.didChangeActiveStatus(true)
        }
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        delegateSearchBarText?.didChangeActiveStatus(false)
    }
}
