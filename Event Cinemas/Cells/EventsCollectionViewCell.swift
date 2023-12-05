//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

class EventsCollectionViewCell: UICollectionViewCell {
    
    private let categoryImageView = UIImageView()
    private let nameLabel = UILabel()
    private let favoriteButton = UIButton(type: .custom)

    var viewModel: EventsCellViewModelProtocol? {
        didSet {
            guard let viewModel = viewModel else { return }
            configure(with: viewModel)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupFavoriteButton()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func favoriteButtonTapped() {
        guard let viewModel = viewModel else { return }
        viewModel.toggleFavorite()
        favoriteButton.isSelected = viewModel.isFavorite
    }

    private func configure(with viewModel: EventsCellViewModelProtocol) {
        nameLabel.text = viewModel.name
        favoriteButton.isSelected = viewModel.isFavorite
    }

    private func setupFavoriteButton() {
        contentView.addSubview(favoriteButton)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
        favoriteButton.tintColor = .yellow
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }

    private func setupCell() {
        layer.cornerRadius = 10
        backgroundColor = UIColor.gray.withAlphaComponent(0.5)

        categoryImageView.contentMode = .scaleAspectFit
        contentView.addSubview(categoryImageView)

        nameLabel.textColor = .black
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        contentView.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        categoryImageView.frame = contentView.bounds
    }
}
