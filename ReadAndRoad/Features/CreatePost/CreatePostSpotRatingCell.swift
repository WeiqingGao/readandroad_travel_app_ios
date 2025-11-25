//
//  CreatePostSpotRatingCell.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/24/25.
//

import UIKit

class SpotRatingCell: UITableViewCell {

    let nameLabel = UILabel()
    let starStack = UIStackView()
    var stars: [UIButton] = []
    var onRatingChanged: ((Int) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        nameLabel.font = .systemFont(ofSize: 16)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        starStack.axis = .horizontal
        starStack.spacing = 4
        starStack.translatesAutoresizingMaskIntoConstraints = false

        for i in 1...5 {
            let btn = UIButton(type: .system)
            btn.tag = i
            btn.setImage(UIImage(systemName: "star"), for: .normal)
            btn.tintColor = .systemYellow
            btn.addTarget(self, action: #selector(handleStar(_:)), for: .touchUpInside)
            stars.append(btn)
            starStack.addArrangedSubview(btn)
        }

        contentView.addSubview(nameLabel)
        contentView.addSubview(starStack)

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            starStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            starStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    @objc private func handleStar(_ sender: UIButton) {
        let rating = sender.tag
        updateStars(rating)
        onRatingChanged?(rating)
    }

    func updateStars(_ rating: Int) {
        for star in stars {
            let name = star.tag <= rating ? "star.fill" : "star"
            star.setImage(UIImage(systemName: name), for: .normal)
        }
    }
}
