//Copyright (c) 2023 Jakub Bąk. All rights reserved.

protocol AutocompleteViewModelDelegate: AnyObject {
    func autocompleteResultsUpdated()
}

class AutocompleteViewModel {
    private let movieManager: MovieManagerApiRequest
    weak var delegate: AutocompleteViewModelDelegate?
    var isLoadingMore = false
    private var currentPage = 1
    var filteredCategories: [MovieDetailResultModel] = []
    
    var currentSearchText = "" { didSet {
        filteredCategories = []
        searchCategoriesAndUpdate()
    } }
    
    var numberOfResults: Int { return filteredCategories.count }
    
    init(movieManager: MovieManagerApiRequest = MovieManagerApiRequest()) {
        self.movieManager = movieManager
    }

    func fetchNextPage() {
        if isLoadingMore { return }
        isLoadingMore = false
        currentPage += 1
        searchCategoriesAndUpdate()
    }
    
    func result(at index: Int) -> MovieDetailResultModel? {
        guard index < filteredCategories.count else { return nil }
        return filteredCategories[index]
    }
    
    func didSelectRow(at index: Int) {
        // Handle selection here if needed
    }
    
    func updateAutocompleteResults(_ results: [MovieDetailResultModel]) {
        if currentPage == 1 { filteredCategories = results }
        else { filteredCategories.append(contentsOf: results) }
        delegate?.autocompleteResultsUpdated()
    }
    
    func updateSearchText(_ text: String) {
        currentSearchText = text
    }
    
    func searchCategoriesAndUpdate() {
        fetchSearchMovies(page: currentPage, searchText: currentSearchText)
    }
    
    func fetchSearchMovies(page: Int, searchText: String) {
        guard !isLoadingMore else { return }
        isLoadingMore = true

        searchMovies(page: page, searchText: searchText) { [weak self] result in
            self?.isLoadingMore = false
            switch result {
                case .success(let movies):
                    if let movieResults = movies.first?.results {
                        if page == 1 { self?.filteredCategories = movieResults }
                        else { self?.filteredCategories.append(contentsOf: movieResults) }
                        self?.delegate?.autocompleteResultsUpdated()
                    }
                case .serverError(_), .networkError(_):
                    break
            }
        }
    }
    
    func searchMovies(page: Int, searchText: String, completion: @escaping (Result<[MovieResultModel]>)-> Void) {
        movieManager.fetchSearchMovies(page: page, searchText: searchText) {  response in
            switch response {
                case .success(let data):
                    completion(.success([data]))
                case .serverError(let serverError):
                    completion(.serverError(serverError))
                case .networkError(let networkErrorMessage):
                    completion(.networkError(networkErrorMessage))
            }
        }
    }
}
