//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import Foundation
import UIKit

protocol AutocompleteViewControllerDelegate: AnyObject {
    func didSelectAutocompleteResult(_ result: String)
}

class AutocompleteViewController: UITableViewController {
    
    weak var delegate: AutocompleteViewControllerDelegate?
    
    var autocompleteResults: [MovieDetailResultModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompleteResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = autocompleteResults[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedResult = autocompleteResults[indexPath.row]
        //delegate?.didSelectAutocompleteResult(selectedResult)
    }
}
