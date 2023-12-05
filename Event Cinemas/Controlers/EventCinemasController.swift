//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

class EventCinemasController: UIViewController, AutocompleteViewControllerDelegate {
    
    private var isFetching = false
    private var viewModel = EventCinemasViewModel()
    private var collectionView: UICollectionView!
    private var collectionViewManager: CollectionViewManager!
    private var searchControllerManager = SearchControllerManager()
    private var autocompleteViewController = AutocompleteViewController()
    
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
        let autocompleteVC = AutocompleteViewController()
        autocompleteViewController = autocompleteVC
        autocompleteViewController.delegate = self
        searchControllerManager.delegateSearchBarText = self
        searchControllerManager.delegate = self
        searchControllerManager.setupSearchController(with: searchController.searchBar, autocompleteViewController: autocompleteVC)
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

extension EventCinemasController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        view.isUserInteractionEnabled = true
    }
}


extension EventCinemasController: SearchControllerManagerDelegate, SearchBarTextDelegate {
    
    func didSelectAutocompleteResult(_ result: String) {
        searchController.searchBar.text = result
        //viewModel.updateSearchText(result)
        //viewModel.searchCategoriesAndUpdate()
    }
    
    
    func didChangeSearchText(_ searchText: String) {
        if searchText.count > 2 {
            viewModel.updateSearchText(searchText)
            viewModel.searchCategoriesAndUpdate()
        }
    }
    
    
    func didChangeSearchTextValue(_ searchText: String) {
        autocompleteViewController.autocompleteResults = ["Result 1", "Result 2", "Result 3"]
        
        let navController = UINavigationController(rootViewController: autocompleteViewController)
        navController.modalPresentationStyle = .popover
        navController.preferredContentSize = CGSize(width: view.bounds.width, height: 200)
        
        if let popoverController = navController.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.sourceRect = CGRect(x: view.bounds.midX, y: searchController.searchBar.bounds.height + 100, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
            popoverController.delegate = self
            popoverController.backgroundColor = .white
            popoverController.permittedArrowDirections = .up
            popoverController.passthroughViews = [searchController.searchBar]
        }
        
        present(navController, animated: true) {
            self.view.isUserInteractionEnabled = false
            self.searchController.searchBar.isUserInteractionEnabled = true
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
        
        if viewModel.isFiltering {
            if let lastIndexPath = indexPaths.last, lastIndexPath.item >= numberOfItems - threshold && !viewModel.isFetching {
                viewModel.searchCategoriesAndUpdate()
            }
        } else {
            if let lastIndexPath = indexPaths.last, lastIndexPath.item >= numberOfItems - threshold && !viewModel.isFetching {
                viewModel.fetchNextPage()
            }
        }
    }
}


