//
//  CommentCell.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/9/25.
//

import UIKit

class CommentCell: UITableViewCell {

    let authorLabel = UILabel()
    let dateLabel = UILabel()
    let commentLabel = UILabel()
    let commentImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        authorLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .secondaryLabel

        commentLabel.font = .systemFont(ofSize: 15)
        commentLabel.numberOfLines = 0

        commentImageView.contentMode = .scaleAspectFill
        commentImageView.clipsToBounds = true
        commentImageView.layer.cornerRadius = 8
        commentImageView.translatesAutoresizingMaskIntoConstraints = false

        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(authorLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(commentLabel)
        contentView.addSubview(commentImageView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            dateLabel.centerYAnchor.constraint(equalTo: authorLabel.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: authorLabel.trailingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),

            commentLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 4),
            commentLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            commentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            commentImageView.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 6),
            commentImageView.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            commentImageView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            commentImageView.heightAnchor.constraint(equalToConstant: 180),
            commentImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    // MARK: - Configure

    func configure(comment: Comment) {

        authorLabel.text = comment.authorName

        if let date = comment.createdAt {
            let f = DateFormatter()
            f.dateFormat = "yyyy-MM-dd HH:mm"
            dateLabel.text = f.string(from: date)
        } else {
            dateLabel.text = ""
        }

        commentLabel.text = comment.text

        if let url = comment.photoURL {
            commentImageView.isHidden = false
            commentImageView.setRemoteImage(url)
        } else {
            commentImageView.isHidden = true
        }
    }
}
