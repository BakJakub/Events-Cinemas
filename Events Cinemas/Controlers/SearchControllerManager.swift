//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

protocol SearchControllerManagerDelegate: AnyObject {
    func didChangeSearchText(_ searchText: String)
}

protocol SearchBarTextDelegate: AnyObject {
    func didChangeActiveStatus(_ active: Bool)
}

class SearchControllerManager: NSObject, UISearchBarDelegate {
    
    weak var delegate: SearchControllerManagerDelegate?
    weak var delegateSearchBarText: SearchBarTextDelegate?

    func setupSearchController(with searchBar: UISearchBar) {
        searchBar.delegate = self
        searchBar.placeholder = "Search Movies"
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         delegate?.didChangeSearchText(searchText)
     }
     
     func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
         delegateSearchBarText?.didChangeActiveStatus(true)
         return true
     }
     
     func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
         searchBar.resignFirstResponder()
         delegateSearchBarText?.didChangeActiveStatus(false)
     }
}
