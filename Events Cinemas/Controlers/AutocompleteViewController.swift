//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

class AutocompleteViewController: UITableViewController, AutocompleteViewModelDelegate {
    
    var viewModel = AutocompleteViewModel()
    weak var eventsCinemasDelegate: EventsCinemasSelectedDelegate?
    var currentSearchText: String = "" { didSet { viewModel.updateSearchText(currentSearchText) } }
    
    func autocompleteResultsUpdated() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.delegate = self
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfResults
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let result = viewModel.result(at: indexPath.row) {
            cell.textLabel?.text = result.title
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let threshold = 20
        let numberOfItems = viewModel.numberOfResults
        
        if indexPath.row >= numberOfItems - threshold && !viewModel.isLoadingMore {
            viewModel.fetchNextPage()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedMovie = viewModel.result(at: indexPath.row) {
            self.eventsCinemasDelegate?.didSelectCategory(selectedMovie)
        }
    }
    
    private func setupView() {
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .purple
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        if let navigationBarHeight = navigationController?.navigationBar.bounds.height {
            tableView.contentInset = UIEdgeInsets(top: navigationBarHeight, left: 0, bottom: 0, right: 0)
        }
    }
}
