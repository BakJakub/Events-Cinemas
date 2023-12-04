//Copyright (c) 2023 Jakub Bąk. All rights reserved.
import UIKit

class EventCinemasController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var viewModel = EventsViewModel()
    private var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setupSearchController()
        setupViewModel()
    }
    
    private func configureCollectionView() {
        collectionView = EventCinemasViewBuilder.buildCollectionView()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.fetchCategories()
    }
}

extension EventCinemasController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.updateSearchText(searchText)
        viewModel.searchCategoriesAndUpdate()
    }
}

extension EventCinemasController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
    }
}

extension EventCinemasController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.isFiltering ? viewModel.filteredCategories.count : viewModel.categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? EventsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let category = viewModel.getFilteredCategory(at: indexPath.item) ?? viewModel.categories[indexPath.item]
        cell.viewModel = EventsCellViewModel(category: category)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width - 20
        let cellHeight: CGFloat = 100
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = viewModel.isFiltering ? viewModel.getFilteredCategory(at: indexPath.item) : (indexPath.item < viewModel.categories.count ? viewModel.categories[indexPath.item] : nil)
        
        if let validSelectedCategory = selectedCategory {
            print("Selected category: \(validSelectedCategory.name)")
        }
    }
}

extension EventCinemasController: EventsViewModelDelegate {
    func filteredCategoriesUpdated(categories: [EventsCinemaModel]) {
        collectionView.reloadData()
    }
    
    func categoriesFetched() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }
}
