//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

class MovieDetailView: UIView {
    
    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .black
        return indicator
    }()
    
    let movieBackdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let overviewTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(movieBackdropImageView)
        addSubview(titleLabel)
        addSubview(releaseDateLabel)
        addSubview(ratingLabel)
        addSubview(overviewTextView)
        addSubview(loadingIndicator)
        
        self.setupConstraint()
    }
    
    private func setupConstraint() {

        NSLayoutConstraint.activate([
            // Movie Poster Image
            movieBackdropImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            movieBackdropImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            movieBackdropImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            movieBackdropImageView.heightAnchor.constraint(equalToConstant: 180),
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: movieBackdropImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Release Date Label
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            releaseDateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            releaseDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Rating Label
            ratingLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 10),
            ratingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            ratingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Overview Text View
            overviewTextView.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 20),
            overviewTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            overviewTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            overviewTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            // Loading Indicator
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
