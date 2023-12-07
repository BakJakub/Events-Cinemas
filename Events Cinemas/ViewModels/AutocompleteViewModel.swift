//Copyright (c) 2023 Jakub Bąk. All rights reserved.

protocol AutocompleteViewModelDelegate: AnyObject {
    func autocompleteResultsUpdated()
}

class AutocompleteViewModel {
    
    private let movieManager: MovieService
    weak var delegate: AutocompleteViewModelDelegate?
    private(set) var filteredCategories: [MovieDetailResultModel] = []
    private var currentPage = 1
    var isLoadingMore = false { didSet { if !isLoadingMore { currentPage += 1 } } }
    var currentSearchText = "" { didSet { filteredCategories = []; searchCategoriesAndUpdate() } }
    var numberOfResults: Int { return filteredCategories.count }
    var lastSearchedText = ""
    
    init(movieManager: MovieService = MovieService()) {
        self.movieManager = movieManager
    }
    
    func fetchNextPage() {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        searchCategoriesAndUpdate()
    }
    
    func result(at index: Int) -> MovieDetailResultModel? {
        return index < filteredCategories.count ? filteredCategories[index] : nil
    }
    
    func updateSearchText(_ text: String) {
            currentSearchText = text
            if text != lastSearchedText {
                lastSearchedText = text
                filteredCategories = []
                currentPage = 1
                searchCategoriesAndUpdate()
            }
        }
    
    func searchCategoriesAndUpdate() {
        fetchSearchMovies(page: currentPage, searchText: currentSearchText)
    }
    
    func fetchSearchMovies(page: Int, searchText: String) {
        movieManager.fetchSearchMovies(page: page, searchText: searchText) { [weak self] response in
            guard let self = self else { return }
            self.isLoadingMore = false
            
            switch response {
            case .success(let movies):
                if movies.results.isEmpty {
                    self.currentPage -= 1
                } else {
                    self.filteredCategories.append(contentsOf: movies.results)
                }
                self.delegate?.autocompleteResultsUpdated()
            case .serverError, .networkError:
                self.currentPage -= 1
                break
            }
        }
    }
}
