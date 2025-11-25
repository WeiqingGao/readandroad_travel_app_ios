//
//  SpotsSpotCell.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/24/25.
//

import UIKit

class SpotsSpotCell: UITableViewCell {

    let spotImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    let spotNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(spotImageView)
        contentView.addSubview(spotNameLabel)

        NSLayoutConstraint.activate([
            spotImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            spotImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            spotImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            spotImageView.widthAnchor.constraint(equalToConstant: 90),
            spotImageView.heightAnchor.constraint(equalToConstant: 70),

            spotNameLabel.leadingAnchor.constraint(equalTo: spotImageView.trailingAnchor, constant: 12),
            spotNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            spotNameLabel.centerYAnchor.constraint(equalTo: spotImageView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with spot: Spot) {
        spotNameLabel.text = spot.name
        spotImageView.image = UIImage(named: spot.imageName)
    }
}
