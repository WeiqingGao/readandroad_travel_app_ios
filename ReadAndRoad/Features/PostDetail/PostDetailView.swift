//
//  PostDetailView.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//

import UIKit

class PostDetailView: UIView {

    // MARK: - Public UI Components

    let tableView = UITableView()
    let commentInputView = UIView()
    let commentTextField = UITextField()
    let addImageButton = UIButton(type: .system)
    let sendButton = UIButton(type: .system)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground

        setupTableView()
        setupCommentInputView()
        setupAddImageButton()
        setupSendButton()
        setupCommentTextField()

        layoutUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Setup Methods

    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
    }

    private func setupCommentInputView() {
        commentInputView.backgroundColor = .secondarySystemBackground
        commentInputView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(commentInputView)
    }

    private func setupAddImageButton() {
        let img = UIImage(systemName: "photo")
        addImageButton.setImage(img, for: .normal)
        addImageButton.tintColor = .label
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        commentInputView.addSubview(addImageButton)
    }

    private func setupSendButton() {
        sendButton.setTitle("Send", for: .normal)
        sendButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        commentInputView.addSubview(sendButton)
    }

    private func setupCommentTextField() {
        commentTextField.placeholder = "Write a comment..."
        commentTextField.borderStyle = .roundedRect
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        commentInputView.addSubview(commentTextField)
    }


    // MARK: - Layout Constraints

    private func layoutUI() {

        NSLayoutConstraint.activate([

            // Table
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: commentInputView.topAnchor),

            // Input Bar
            commentInputView.leadingAnchor.constraint(equalTo: leadingAnchor),
            commentInputView.trailingAnchor.constraint(equalTo: trailingAnchor),
            commentInputView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            commentInputView.heightAnchor.constraint(equalToConstant: 60),

            // Add Image Button
            addImageButton.leadingAnchor.constraint(equalTo: commentInputView.leadingAnchor, constant: 12),
            addImageButton.centerYAnchor.constraint(equalTo: commentInputView.centerYAnchor),
            addImageButton.widthAnchor.constraint(equalToConstant: 28),
            addImageButton.heightAnchor.constraint(equalToConstant: 28),

            // Send Button
            sendButton.trailingAnchor.constraint(equalTo: commentInputView.trailingAnchor, constant: -12),
            sendButton.centerYAnchor.constraint(equalTo: commentInputView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 50),

            // Comment TextField
            commentTextField.leadingAnchor.constraint(equalTo: addImageButton.trailingAnchor, constant: 12),
            commentTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -12),
            commentTextField.centerYAnchor.constraint(equalTo: commentInputView.centerYAnchor),
            commentTextField.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
