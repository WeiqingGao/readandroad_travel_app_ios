//
//  CommentCell.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/9/25.
//

import UIKit
import SDWebImage

class CommentCell: UITableViewCell {

    let authorLabel = UILabel()
    let dateLabel = UILabel()
    let commentLabel = UILabel()
    let commentImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        authorLabel.font = .boldSystemFont(ofSize: 15)

        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .secondaryLabel

        commentLabel.font = .systemFont(ofSize: 15)
        commentLabel.numberOfLines = 0

        commentImageView.contentMode = .scaleAspectFill
        commentImageView.clipsToBounds = true
        commentImageView.layer.cornerRadius = 8
        commentImageView.translatesAutoresizingMaskIntoConstraints = false

        [authorLabel, dateLabel, commentLabel, commentImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        setupConstraints()
    }

    required init?(coder: NSCoder) { fatalError() }

    func setupConstraints() {

        NSLayoutConstraint.activate([

            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            dateLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 2),
            dateLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),

            commentLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 6),
            commentLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            commentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            commentImageView.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 8),
            commentImageView.leadingAnchor.constraint(equalTo: commentLabel.leadingAnchor),
            commentImageView.widthAnchor.constraint(equalToConstant: 200),
            commentImageView.heightAnchor.constraint(equalToConstant: 200),

            contentView.bottomAnchor.constraint(
                greaterThanOrEqualTo: commentImageView.bottomAnchor,
                constant: 12
            )
        ])
    }

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
            commentImageView.sd_setImage(with: URL(string: url))
        } else {
            commentImageView.isHidden = true
        }
    }
}
