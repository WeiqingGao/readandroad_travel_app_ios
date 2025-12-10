//
//  CommunityPostCell.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//
//

import UIKit
import FirebaseAuth

/// A table view cell displaying a community post.
/// Includes title, author, date, and a save/star button.
class CommunityPostCell: UITableViewCell {

    // MARK: - UI Components

    var labelTitle: UILabel!
    var labelAuthor: UILabel!
    var labelDate: UILabel!
    var buttonStar: UIButton!

    // MARK: - Properties

    private(set) var postID: String?
    private var isSaved: Bool = false {
        didSet { updateStarAppearance() }
    }

    /// Callback triggered when star button is toggled.
    var onToggleSave: ((String, Bool) -> Void)?

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupLabelTitle()
        setupLabelAuthor()
        setupLabelDate()
        setupButtonStar()

        initConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI

    func setupLabelTitle() {
        labelTitle = UILabel()
        labelTitle.font = UIFont.boldSystemFont(ofSize: 16)
        labelTitle.numberOfLines = 0
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelTitle)
    }

    func setupLabelAuthor() {
        labelAuthor = UILabel()
        labelAuthor.font = UIFont.systemFont(ofSize: 13)
        labelAuthor.textColor = .gray
        labelAuthor.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelAuthor)
    }

    func setupLabelDate() {
        labelDate = UILabel()
        labelDate.font = UIFont.systemFont(ofSize: 12)
        labelDate.textColor = .secondaryLabel
        labelDate.textAlignment = .right
        labelDate.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelDate)
    }

    func setupButtonStar() {
        buttonStar = UIButton(type: .system)
        buttonStar.tintColor = .systemYellow
        buttonStar.translatesAutoresizingMaskIntoConstraints = false
        buttonStar.addTarget(self, action: #selector(onStarTapped), for: .touchUpInside)
        contentView.addSubview(buttonStar)
    }

    // MARK: - Constraints

    func initConstraints() {
        NSLayoutConstraint.activate([

            // Title
            labelTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            labelTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelTitle.trailingAnchor.constraint(equalTo: buttonStar.leadingAnchor, constant: -12),

            // Star button
            buttonStar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            buttonStar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            buttonStar.widthAnchor.constraint(equalToConstant: 26),
            buttonStar.heightAnchor.constraint(equalToConstant: 26),

            // Author
            labelAuthor.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 6),
            labelAuthor.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),

            // Date
            labelDate.centerYAnchor.constraint(equalTo: labelAuthor.centerYAnchor),
            labelDate.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Bottom Anchor
            labelAuthor.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    // MARK: - Configure

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
    }

    // MARK: - Star Button Handling

    private func updateStarAppearance() {
        let iconName = isSaved ? "star.fill" : "star"
        buttonStar.setImage(UIImage(systemName: iconName), for: .normal)
    }

    @objc private func onStarTapped() {
        guard let postID else { return }

        if Auth.auth().currentUser == nil {
            onToggleSave?(postID, isSaved)
            return
        }

        isSaved.toggle()
        onToggleSave?(postID, isSaved)
    }
}
