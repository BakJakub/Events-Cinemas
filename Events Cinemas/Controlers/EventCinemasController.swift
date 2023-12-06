//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

protocol EventCinemaSelectedDelegate: AnyObject {
    func didSelectCategory(_ moviewModel: MovieDetailResultModel)
}

class EventCinemasController: UIViewController {
    
    var coordinator: Coordinator?
    private var isFetching = false
    private var viewModel = EventCinemasViewModel()
    private lazy var collectionView = EventCinemasViewBuilder.buildCollectionView()
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
        autocompleteViewController.eventCinemaDelegate = self
        navigationItem.searchController = searchController
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.fetchCategories()
    }
    
    private func setupCollectionViewManager() {
        collectionViewManager = CollectionViewManager(viewModel: viewModel)
        collectionViewManager.navigationController = navigationController
        collectionViewManager.eventCinemaDelegate = self
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

extension EventCinemasController: EventCinemaSelectedDelegate {
    
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

extension EventCinemasController: SearchControllerManagerDelegate, SearchBarTextDelegate, PopoverDelegate {
    
    func didChangeSearchText(_ searchText: String) {
        autocompleteViewController.currentSearchText = searchText
    }
    
    func didChangeSearchTextValue(_ searchText: String) {
          let navController = UINavigationController(rootViewController: autocompleteViewController)
          configurePopover(for: navController, sourceView: searchController.searchBar, sourceRect: CGRect(x: 0, y: searchController.searchBar.bounds.height, width: 0, height: 0))
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
        
        if let lastIndexPath = indexPaths.last, lastIndexPath.item >= numberOfItems - threshold, !viewModel.isFetching {
            viewModel.fetchNextPage()
        }
    }
}
