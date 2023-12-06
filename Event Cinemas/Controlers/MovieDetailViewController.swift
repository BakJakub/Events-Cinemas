//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

class MovieDetailViewController: UIViewController {
    
    private var viewModel: MovieDetailViewModel
    private var movieDetailView: MovieDetailView!

    init(data: MovieDetailResultModel) {
        self.viewModel = MovieDetailViewModel(data: data)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        movieDetailView = MovieDetailView(frame: view.bounds)
        view.addSubview(movieDetailView)
        
        loadData()
    }
    
    private func loadData() {
        guard !viewModel.isLoading else { return }
        viewModel.isLoading = true
        
        movieDetailView.loadingIndicator.startAnimating()
        movieDetailView.loadingIndicator.isHidden = false
        
        viewModel.fetchMoviePoster { [weak self] image in
            DispatchQueue.main.async {
                self?.movieDetailView.loadingIndicator.stopAnimating()
                self?.movieDetailView.loadingIndicator.isHidden = true
                self?.movieDetailView.movieBackdropImageView.image = image
                self?.updateUIWithMovieDetails()
            }
        }
    }
    
    private func updateUIWithMovieDetails() {
        movieDetailView.titleLabel.text = viewModel.data.title
        movieDetailView.releaseDateLabel.text = "Release Date: \(viewModel.data.releaseDate ?? "Date not available")"
        movieDetailView.ratingLabel.text = "Rating: \(viewModel.data.voteAverage?.description ?? "Rating not available")"
        movieDetailView.overviewTextView.text = viewModel.data.overview ?? "Overview not available"
    }
}
