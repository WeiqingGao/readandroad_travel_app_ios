//
//  CommunityPostCell.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//
//

import UIKit
import FirebaseAuth

/// Cell displaying a community post with title, author, date and a save/star button.
class CommunityPostCell: UITableViewCell {

    // MARK: - UI Components

    private let labelTitle = UILabel()
    private let labelAuthor = UILabel()
    private let labelDate = UILabel()
    private let buttonStar = UIButton(type: .system)

    // MARK: - Properties

    private(set) var postID: String?
    private var isSaved: Bool = false {
        didSet { updateStarAppearance() }
    }

    /// Callback for save toggle: (postID, newStatus)
    var onToggleSave: ((String, Bool) -> Void)?

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    private func setupUI() {

        labelTitle.font = UIFont.boldSystemFont(ofSize: 16)
        labelTitle.numberOfLines = 0

        labelAuthor.font = UIFont.systemFont(ofSize: 13)
        labelAuthor.textColor = .gray

        labelDate.font = UIFont.systemFont(ofSize: 12)
        labelDate.textColor = .secondaryLabel
        labelDate.textAlignment = .right

        buttonStar.tintColor = .systemYellow
        buttonStar.addTarget(self, action: #selector(didTapStar), for: .touchUpInside)

        [labelTitle, labelAuthor, labelDate, buttonStar].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }

    // MARK: - Layout

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Title
            labelTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            labelTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelTitle.trailingAnchor.constraint(equalTo: buttonStar.leadingAnchor, constant: -12),

            // Star Button
            buttonStar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            buttonStar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            buttonStar.widthAnchor.constraint(equalToConstant: 26),
            buttonStar.heightAnchor.constraint(equalToConstant: 26),

            // Author
            labelAuthor.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 6),
            labelAuthor.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),

            // Date aligned with author line
            labelDate.centerYAnchor.constraint(equalTo: labelAuthor.centerYAnchor),
            labelDate.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Bottom
            labelAuthor.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    // MARK: - Public Configure

    func configure(title: String,
                   author: String,
                   date: String,
                   postID: String,
                   isSaved: Bool) {

        labelTitle.text = title
        labelAuthor.text = "by \(author)"
        labelDate.text = date

        self.postID = postID
        self.isSaved = isSaved
        // didSet will update star appearance
    }

    // MARK: - Star Handling

    private func updateStarAppearance() {
        let imageName = isSaved ? "star.fill" : "star"
        buttonStar.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @objc private func didTapStar() {
        guard let postID = postID else { return }

        // Let VC handle login restriction
        if Auth.auth().currentUser == nil {
            onToggleSave?(postID, isSaved)
            return
        }

        // Toggle instantly for UX
        isSaved.toggle()
        onToggleSave?(postID, isSaved)
    }
}
