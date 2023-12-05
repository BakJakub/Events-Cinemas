//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

class EventCinemasController: UIViewController, AutocompleteViewControllerDelegate {
    
    private var isFetching = false
    private var viewModel = EventCinemasViewModel()
    private var collectionView: UICollectionView!
    private var collectionViewManager: CollectionViewManager!
    let searchControllerManager = SearchControllerManager<AnyObject>()
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
    }
    
    func didChangeSearchText(_ searchText: String) {
        autocompleteViewController.currentSearchText = searchText
    }
    
    func didChangeSearchTextValue(_ searchText: String) {
        let navController = UINavigationController(rootViewController: autocompleteViewController)
        navController.modalPresentationStyle = .popover
        navController.preferredContentSize = CGSize(width: view.bounds.width, height: 200)

        if let popoverController = navController.popoverPresentationController {
            popoverController.sourceView = searchController.searchBar
            popoverController.sourceRect = CGRect(x: 0, y: searchController.searchBar.bounds.height, width: 0, height: 0)
            popoverController.permittedArrowDirections = .up
            popoverController.delegate = self
            popoverController.backgroundColor = .white
            popoverController.passthroughViews = [searchController.searchBar]
        }

        present(navController, animated: true) {
            self.view.isUserInteractionEnabled = false
            self.searchController.searchBar.isUserInteractionEnabled = true
        }
    }
}

extension EventCinemasController: EventCinemasDelegate {
    
    func categoriesFetched() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension EventCinemasController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        let threshold = 5
        let numberOfItems = viewModel.categories.count
        
        guard numberOfItems > 0 else { return }
        
        if let lastIndexPath = indexPaths.last, lastIndexPath.item >= numberOfItems - threshold && !viewModel.isFetching {
            viewModel.fetchNextPage()
        }
    }
}


