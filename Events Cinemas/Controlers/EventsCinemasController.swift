//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

protocol EventsCinemasSelectedDelegate: AnyObject {
    func didSelectCategory(_ moviewModel: MovieDetailResultModel)
}

class EventsCinemasController: UIViewController {
    
    var coordinator: Coordinator?
    private var isFetching = false
    private var viewModel = EventsCinemasViewModel()
    private lazy var collectionView = EventsCinemasViewBuilder.buildCollectionView()
    private var collectionViewManager: CollectionViewManager!
    private var autocompleteViewController = AutocompleteViewController()
    private var searchControllerManager = SearchControllerManager<AnyObject>()

    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.obscuresBackgroundDuringPresentation = false
        controller.definesPresentationContext = true
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
    }
    
    private func setupUI() {
        configureCollectionView()
        setupCollectionViewPagination()
        setupSearchController()
        setupCollectionViewManager()
    }
    
    private func configureCollectionView() {
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
        searchControllerManager.delegateSearchBarText = self
        searchControllerManager.delegate = self
        searchControllerManager.setupSearchController(with: searchController.searchBar, autocompleteViewController: autocompleteViewController)
        autocompleteViewController.eventsCinemasDelegate = self
        navigationItem.searchController = searchController
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.fetchCategories()
    }
    
    private func setupCollectionViewManager() {
        collectionViewManager = CollectionViewManager(viewModel: viewModel)
        collectionViewManager.navigationController = navigationController
        collectionViewManager.eventsCinemasDelegate = self
        setupCollectionViewDelegate()
        setupCollectionViewDataSource()
    }
    
    private func setupCollectionViewPagination() {
        let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        collectionView.prefetchDataSource = self
    }
    
    private func setupCollectionViewDelegate() {
        collectionView.delegate = collectionViewManager
    }
    
    private func setupCollectionViewDataSource() {
        collectionView.dataSource = collectionViewManager
    }
}

extension EventsCinemasController: EventsCinemasSelectedDelegate {
    
    func didSelectCategory(_ moviewModel: MovieDetailResultModel) {
        if let presentedViewController = presentedViewController {
            presentedViewController.dismiss(animated: true) {
                self.coordinator?.pushMovieDetail(data: moviewModel)
            }
        } else if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
            self.coordinator?.pushMovieDetail(data: moviewModel)
        } else {
            self.coordinator?.pushMovieDetail(data: moviewModel)
        }
    }
    
}

extension EventsCinemasController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.endEditing(true)
    }
}

extension EventsCinemasController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        view.isUserInteractionEnabled = true
    }
}

extension EventsCinemasController: SearchControllerManagerDelegate, SearchBarTextDelegate, PopoverDelegate {
    
    func didChangeSearchText(_ searchText: String) {
        autocompleteViewController.currentSearchText = searchText
    }
    
    func didChangeSearchTextValue(_ searchText: String) {
//          let navController = UINavigationController(rootViewController: autocompleteViewController)
//          configurePopover(for: navController, sourceView: searchController.searchBar, sourceRect: CGRect(x: 0, y: searchController.searchBar.bounds.height, width: 0, height: 0))
      }
}

extension EventsCinemasController: EventsCinemasDelegate {
    func categoriesFetched() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension EventsCinemasController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let threshold = 5
        let numberOfItems = viewModel.categories.count
        
        guard numberOfItems > 0 else { return }
        
        if let lastIndexPath = indexPaths.last, lastIndexPath.item >= numberOfItems - threshold, !viewModel.isFetching {
            viewModel.fetchNextPage()
        }
    }
}
