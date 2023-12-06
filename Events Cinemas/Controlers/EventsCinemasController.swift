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
    private var collectionViewTopConstraint: NSLayoutConstraint?
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        setupCollectionView()
    }
    
    private func setupUI() {
        setupCollectionViewPagination()
        setupSearchController()
        setupCollectionViewManager()
        setupAutocompleteView()
        setupCollectionView()
    }
    
    private var isAutocompleteVisible = false {
        didSet {
            setupUI()
        }
    }
    
    private func setupAutocompleteView() {
        addChild(autocompleteViewController)
        autocompleteViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(autocompleteViewController.view)
        setupAutocompleteViewConstarint()
        autocompleteViewController.didMove(toParent: self)
        autocompleteViewController.eventsCinemasDelegate = self
    }
    
    private func setupSearchController() {
        searchControllerManager.delegateSearchBarText = self
        searchControllerManager.delegate = self
        searchControllerManager.setupSearchController(with: searchController.searchBar, autocompleteViewController: autocompleteViewController)
        autocompleteViewController.eventsCinemasDelegate = self
        autocompleteViewController.delegateSearchBarText = self
        navigationItem.searchController = searchController
    }
    
    func setupAutocompleteViewConstarint(){
        NSLayoutConstraint.activate([
            autocompleteViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            autocompleteViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            autocompleteViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            autocompleteViewController.view.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        setupCollectionViewConstraint()
    }
    
    private func setupCollectionViewConstraint() {
        collectionViewTopConstraint?.isActive = false
        
        let topAnchor: NSLayoutYAxisAnchor = isAutocompleteVisible ? autocompleteViewController.view.bottomAnchor : view.safeAreaLayoutGuide.topAnchor
        collectionViewTopConstraint = collectionView.topAnchor.constraint(equalTo: topAnchor)
        collectionViewTopConstraint?.isActive = true
        
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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
        self.coordinator?.pushMovieDetail(data: moviewModel)
    }
    
}

extension EventsCinemasController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.endEditing(true)
    }
}

extension EventsCinemasController: SearchControllerManagerDelegate, SearchBarTextDelegate {
    
    func didChangeActiveStatus(_ active: Bool) {
        isAutocompleteVisible = active
    }
    
    func didChangeSearchText(_ searchText: String) {
        autocompleteViewController.currentSearchText = searchText
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
