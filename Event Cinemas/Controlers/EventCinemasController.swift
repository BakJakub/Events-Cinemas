//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

class EventCinemasController: UIViewController {
    
    private var viewModel = EventsViewModel()
    private var collectionView: UICollectionView!
    private var collectionViewManager: CollectionViewManager!
    private var searchControllerManager = SearchControllerManager()
    
    private var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setupSearchController()
        setupViewModel()
        setupCollectionViewManager()
    }
    
    private func configureCollectionView() {
        collectionView = EventCinemasViewBuilder.buildCollectionView()
        setupCollectionViewConstraints()
    }
    
    private func setupCollectionViewConstraints() {
        collectionView = EventCinemasViewBuilder.buildCollectionView()
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupSearchController() {
        searchControllerManager.delegate = self
        searchControllerManager.setupSearchController(with: searchController.searchBar)
        navigationItem.searchController = searchController
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.fetchCategories()
    }
    
    private func setupCollectionViewManager() {
        collectionViewManager = CollectionViewManager(viewModel: viewModel)
        collectionViewManager.navigationController = navigationController
        setupCollectionViewDelegate()
        setupCollectionViewDataSource()
    }
    
    private func setupCollectionViewDelegate() {
        collectionView.delegate = collectionViewManager
    }
    
    private func setupCollectionViewDataSource() {
        collectionView.dataSource = collectionViewManager
    }
}

extension EventCinemasController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.endEditing(true)
    }
}

extension EventCinemasController: SearchControllerManagerDelegate {
        
    func didChangeSearchText(_ searchText: String) {
        viewModel.updateSearchText(searchText)
        viewModel.searchCategoriesAndUpdate()
        
        if !searchText.isEmpty {
            searchController.searchBar.becomeFirstResponder()
        }
    }
}

extension EventCinemasController: EventsViewModelDelegate {
    func filteredCategoriesUpdated(categories: [EventsCinemaModel]) {
        collectionView.reloadData()
    }
    
    func categoriesFetched() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}


