//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import Foundation
import UIKit

protocol AutocompleteViewControllerDelegate: AnyObject {
    func didSelectAutocompleteResult(_ result: String)
}

class AutocompleteViewController: UITableViewController {
    
    weak var delegate: AutocompleteViewControllerDelegate?
    var autocompleteResults: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        navigationController?.isNavigationBarHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompleteResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = autocompleteResults[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedResult = autocompleteResults[indexPath.row]
        delegate?.didSelectAutocompleteResult(selectedResult)
    }
}
