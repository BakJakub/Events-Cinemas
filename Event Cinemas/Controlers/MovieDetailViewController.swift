//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

class MovieDetailViewController: UIViewController {
    
    private var viewModel: MovieDetailViewModel

    init(data: MovieDetailResultModel) {
        self.viewModel = MovieDetailViewModel(data: data)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .black
        return indicator
    }()
    
    private let movieBackdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overviewTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupUI()
        loadData()
    }
    
    private func setupUI() {
        view.addSubview(movieBackdropImageView)
        view.addSubview(titleLabel)
        view.addSubview(releaseDateLabel)
        view.addSubview(ratingLabel)
        view.addSubview(overviewTextView)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            // Movie Poster Image
            movieBackdropImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            movieBackdropImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            movieBackdropImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            movieBackdropImageView.heightAnchor.constraint(equalToConstant: 180),
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: movieBackdropImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Release Date Label
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            releaseDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            releaseDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Rating Label
            ratingLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 10),
            ratingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ratingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Overview Text View
            overviewTextView.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 20),
            overviewTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            overviewTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            // Loading Indicator
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func loadData() {
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        viewModel.isLoading = true
        
        viewModel.fetchMoviePoster { [weak self] image in
            DispatchQueue.main.async { [weak self] in
                self?.loadingIndicator.stopAnimating()
                self?.loadingIndicator.isHidden = true
                self?.movieBackdropImageView.image = image
                self?.updateUIWithMovieDetails()
            }
        }
    }
    
    private func updateUIWithMovieDetails() {
        titleLabel.text = viewModel.data.title
        releaseDateLabel.text = "Release Date: \(viewModel.data.releaseDate ?? "Date not available")"
        ratingLabel.text = "Rating: \(viewModel.data.voteAverage?.description ?? "Rating not available")"
        overviewTextView.text = viewModel.data.overview ?? "Overview not available"
    }
}
