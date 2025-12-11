//
//  PostDetailHeaderCell.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/9/25.
//

import UIKit

class PostDetailHeaderCell: UITableViewCell {

    // MARK: - UI Components

    let authorLabel = UILabel()
    let dateLabel = UILabel()
    let postTextLabel = UILabel()

    let imagesScrollView = UIScrollView()
    let imagesStackView = UIStackView()

    let saveButton = UIButton(type: .system)

    // Callback for save button
    var onSaveTapped: (() -> Void)?

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupViews() {
        authorLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        authorLabel.textColor = .label

        dateLabel.font = .systemFont(ofSize: 13)
        dateLabel.textColor = .secondaryLabel

        postTextLabel.font = .systemFont(ofSize: 15)
        postTextLabel.numberOfLines = 0

        imagesScrollView.translatesAutoresizingMaskIntoConstraints = false
        imagesScrollView.showsHorizontalScrollIndicator = false

        imagesStackView.axis = .horizontal
        imagesStackView.alignment = .fill
        imagesStackView.distribution = .fillEqually
        imagesStackView.spacing = 8
        imagesStackView.translatesAutoresizingMaskIntoConstraints = false

        imagesScrollView.addSubview(imagesStackView)

        saveButton.tintColor = .systemYellow
        saveButton.addTarget(self, action: #selector(savePressed), for: .touchUpInside)

        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        postTextLabel.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(authorLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(postTextLabel)
        contentView.addSubview(imagesScrollView)
        contentView.addSubview(saveButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            saveButton.centerYAnchor.constraint(equalTo: authorLabel.centerYAnchor),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            saveButton.widthAnchor.constraint(equalToConstant: 30),
            saveButton.heightAnchor.constraint(equalToConstant: 30),

            dateLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),

            postTextLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            postTextLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            postTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            imagesScrollView.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 8),
            imagesScrollView.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            imagesScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imagesScrollView.heightAnchor.constraint(equalToConstant: 220),
            imagesScrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            imagesStackView.topAnchor.constraint(equalTo: imagesScrollView.topAnchor),
            imagesStackView.bottomAnchor.constraint(equalTo: imagesScrollView.bottomAnchor),
            imagesStackView.leadingAnchor.constraint(equalTo: imagesScrollView.leadingAnchor),
            imagesStackView.trailingAnchor.constraint(equalTo: imagesScrollView.trailingAnchor),
            imagesStackView.heightAnchor.constraint(equalTo: imagesScrollView.heightAnchor)
        ])
    }

    // MARK: - Configure

    func configure(post: Post, isSaved: Bool) {

        authorLabel.text = post.authorName

        if let date = post.createdAt {
            let f = DateFormatter()
            f.dateFormat = "yyyy-MM-dd HH:mm"
            dateLabel.text = f.string(from: date)
        } else {
            dateLabel.text = ""
        }

        postTextLabel.text = post.text

        let icon = isSaved ? "star.fill" : "star"
        saveButton.setImage(UIImage(systemName: icon), for: .normal)

        // Images
        imagesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for url in post.photoURLs {
            let imgView = UIImageView()
            imgView.contentMode = .scaleAspectFill
            imgView.clipsToBounds = true
            imgView.layer.cornerRadius = 10
            imgView.translatesAutoresizingMaskIntoConstraints = false
            imgView.widthAnchor.constraint(equalToConstant: 200).isActive = true
            imgView.heightAnchor.constraint(equalToConstant: 220).isActive = true

            imgView.setRemoteImage(url) // 👈 使用我们自己的扩展

            imagesStackView.addArrangedSubview(imgView)
        }
    }

    // MARK: - Actions

    @objc private func savePressed() {
        onSaveTapped?()
    }
}

