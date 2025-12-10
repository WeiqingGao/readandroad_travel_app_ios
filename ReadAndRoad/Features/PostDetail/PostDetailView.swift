//
//  PostDetailView.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//

import UIKit

class PostDetailView: UIView {

    // 整个帖子 + 评论都放在 tableView 中
    let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    // 底部评论输入栏
    let commentInputView: UIView = {
        let v = UIView()
        v.backgroundColor = .secondarySystemBackground
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let commentTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Write a comment..."
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    let addImageButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "photo"), for: .normal)
        btn.tintColor = .label
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    let sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Send", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground

        addSubview(tableView)
        addSubview(commentInputView)

        commentInputView.addSubview(commentTextField)
        commentInputView.addSubview(addImageButton)
        commentInputView.addSubview(sendButton)

        setupConstraints()
    }

    required init?(coder: NSCoder) { fatalError() }

    func setupConstraints() {

        NSLayoutConstraint.activate([

            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: commentInputView.topAnchor),

            commentInputView.leadingAnchor.constraint(equalTo: leadingAnchor),
            commentInputView.trailingAnchor.constraint(equalTo: trailingAnchor),
            commentInputView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            commentInputView.heightAnchor.constraint(equalToConstant: 60),

            addImageButton.leadingAnchor.constraint(equalTo: commentInputView.leadingAnchor, constant: 12),
            addImageButton.centerYAnchor.constraint(equalTo: commentInputView.centerYAnchor),
            addImageButton.widthAnchor.constraint(equalToConstant: 28),
            addImageButton.heightAnchor.constraint(equalToConstant: 28),

            sendButton.trailingAnchor.constraint(equalTo: commentInputView.trailingAnchor, constant: -12),
            sendButton.centerYAnchor.constraint(equalTo: commentInputView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 50),

            commentTextField.leadingAnchor.constraint(equalTo: addImageButton.trailingAnchor, constant: 12),
            commentTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -12),
            commentTextField.centerYAnchor.constraint(equalTo: commentInputView.centerYAnchor),
            commentTextField.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
