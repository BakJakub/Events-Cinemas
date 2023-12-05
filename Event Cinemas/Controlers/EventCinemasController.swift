//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

class EventCinemasController: UIViewController {
    
    private var isFetching = false
    private var viewModel = EventCinemasViewModel()
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
        setupCollectionViewPagination()
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
    
    private func setupCollectionViewPagination() {
        let collectionViewFlowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        collectionViewFlowLayout?.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        collectionView.prefetchDataSource = self
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

extension EventCinemasController: EventCinemasDelegate {
    
    func filteredCategoriesUpdated(categories: [MovieDetailResultModel]) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func categoriesFetched() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension EventCinemasController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        let threshold = 5
        let numberOfItems = viewModel.isFiltering ? viewModel.filteredCategories.count : viewModel.categories.count
        
        guard numberOfItems > 0 else { return }

        if let lastIndexPath = indexPaths.last, lastIndexPath.item >= numberOfItems - threshold && !viewModel.isFetching {
            viewModel.fetchNextPage()
        }
    }
}


