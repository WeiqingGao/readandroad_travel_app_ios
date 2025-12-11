//
//  CreatePostSpotRatingCell.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/24/25.
//

import UIKit

/// Cell for a single spot + 1–5 star rating.
class SpotRatingCell: UITableViewCell {
    
    let nameLabel = UILabel()
    let starStack = UIStackView()
    private(set) var stars: [UIButton] = []
    
    /// Called when user taps a star and rating changes.
    var onRatingChanged: ((Int) -> Void)?
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupNameLabel()
        setupStarStack()
        setupStars()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupNameLabel() {
        nameLabel.font = .systemFont(ofSize: 16)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
    }
    
    private func setupStarStack() {
        starStack.axis = .horizontal
        starStack.spacing = 4
        starStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(starStack)
    }
    
    private func setupStars() {
        for i in 1...5 {
            let button = UIButton(type: .system)
            button.tag = i
            button.setImage(UIImage(systemName: "star"), for: .normal)
            button.tintColor = .systemYellow
            button.addTarget(self, action: #selector(onStarTapped(_:)), for: .touchUpInside)
            stars.append(button)
            starStack.addArrangedSubview(button)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            starStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            starStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func onStarTapped(_ sender: UIButton) {
        let rating = sender.tag
        updateStars(rating)
        onRatingChanged?(rating)
    }
    
    /// Update star icons according to the given rating.
    func updateStars(_ rating: Int) {
        for star in stars {
            let imageName = star.tag <= rating ? "star.fill" : "star"
            star.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
}
