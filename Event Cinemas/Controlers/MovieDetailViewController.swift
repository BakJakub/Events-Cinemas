//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

class MovieDetailViewController: UIViewController {
    
    var movieId: Int?
    private var movie: MovieResultModel?
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .black
        return indicator
    }()
    
    private let moviePosterImageView: UIImageView = {
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
        view.addSubview(moviePosterImageView)
        view.addSubview(titleLabel)
        view.addSubview(releaseDateLabel)
        view.addSubview(ratingLabel)
        view.addSubview(overviewTextView)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            // Movie Poster Image
            moviePosterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            moviePosterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            moviePosterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            moviePosterImageView.heightAnchor.constraint(equalToConstant: 180),
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: moviePosterImageView.bottomAnchor, constant: 20),
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
        //guard let movieId = movieId else { return }
        
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.loadingIndicator.stopAnimating()
            self?.loadingIndicator.isHidden = true
            
//            let movie = MovieModel()
//            self?.movie = movie
            
            self?.updateUIWithMovieDetails()
        }
    }
    
    private func updateUIWithMovieDetails() {
//        guard let movie = movie else { return }
//        
//        moviePosterImageView.image = movie.posterImage
//        titleLabel.text = movie.title
//        releaseDateLabel.text = "Release Date: \(movie.releaseDate)"
//        ratingLabel.text = "Rating: \(movie.rating)"
//        overviewTextView.text = movie.overview
        
       // guard let movie = movie else { return }
        
        titleLabel.text = "movie.title"
        releaseDateLabel.text = "Release Date:"
        ratingLabel.text = "Rating:"
        overviewTextView.text = "movie.overview"
    }
}
