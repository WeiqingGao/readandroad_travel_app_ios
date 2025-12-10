//
//  PostDetailHeaderCell.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/9/25.
//

import UIKit
import SDWebImage   // 推荐使用 SDWebImage 加载图片（非常常用）

class PostDetailHeaderCell: UITableViewCell {

    // MARK: - UI Components
    let authorLabel = UILabel()
    let dateLabel = UILabel()
    let postTextLabel = UILabel()
    let saveButton = UIButton(type: .system)

    let imagesScrollView = UIScrollView()
    let imagesStackView = UIStackView()

    // 回调：收藏按钮点击
    var onSaveTapped: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        authorLabel.font = .boldSystemFont(ofSize: 16)
        dateLabel.font = .systemFont(ofSize: 13)
        dateLabel.textColor = .secondaryLabel

        postTextLabel.font = .systemFont(ofSize: 16)
        postTextLabel.numberOfLines = 0

        saveButton.tintColor = .systemYellow
        saveButton.addTarget(self, action: #selector(savePressed), for: .touchUpInside)

        imagesScrollView.showsHorizontalScrollIndicator = false
        imagesStackView.axis = .horizontal
        imagesStackView.spacing = 10

        imagesScrollView.addSubview(imagesStackView)

        [authorLabel, dateLabel, postTextLabel, saveButton, imagesScrollView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        imagesStackView.translatesAutoresizingMaskIntoConstraints = false

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Constraints
    private func setupConstraints() {

        NSLayoutConstraint.activate([

            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            saveButton.centerYAnchor.constraint(equalTo: authorLabel.centerYAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 32),
            saveButton.heightAnchor.constraint(equalToConstant: 32),

            dateLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),

            postTextLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 12),
            postTextLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            postTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            imagesScrollView.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 12),
            imagesScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imagesScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imagesScrollView.heightAnchor.constraint(equalToConstant: 250),

            imagesStackView.topAnchor.constraint(equalTo: imagesScrollView.topAnchor),
            imagesStackView.leadingAnchor.constraint(equalTo: imagesScrollView.leadingAnchor, constant: 16),
            imagesStackView.trailingAnchor.constraint(equalTo: imagesScrollView.trailingAnchor),
            imagesStackView.bottomAnchor.constraint(equalTo: imagesScrollView.bottomAnchor),
            imagesStackView.heightAnchor.constraint(equalTo: imagesScrollView.heightAnchor),

            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: imagesScrollView.bottomAnchor, constant: 20)
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

        // 收藏按钮
        let icon = isSaved ? "star.fill" : "star"
        saveButton.setImage(UIImage(systemName: icon), for: .normal)

        // 图片加载
        imagesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for url in post.photoURLs {
            let imgView = UIImageView()
            imgView.contentMode = .scaleAspectFill
            imgView.clipsToBounds = true
            imgView.layer.cornerRadius = 10
            imgView.sd_setImage(with: URL(string: url))

            imgView.widthAnchor.constraint(equalToConstant: 200).isActive = true
            imgView.heightAnchor.constraint(equalToConstant: 250).isActive = true

            imagesStackView.addArrangedSubview(imgView)
        }
    }

    @objc func savePressed() {
        onSaveTapped?()
    }
}
