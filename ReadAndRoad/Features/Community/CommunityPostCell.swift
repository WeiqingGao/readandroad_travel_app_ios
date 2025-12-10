//
//  CommunityPostCell.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//

import UIKit
import FirebaseAuth

class CommunityPostCell: UITableViewCell {
    
    private let labelTitle = UILabel()
    private let labelAuthor = UILabel()
    private let labelDate = UILabel()
    private let buttonStar = UIButton(type: .system)
    
    var postID: String?
    var isSaved: Bool = false {
        didSet { updateStarAppearance() }
    }
    // 回调：传递 postID 与新的 isSaved
    var onToggleSave: ((String, Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        labelTitle.font = UIFont.boldSystemFont(ofSize: 16)
        labelAuthor.font = UIFont.systemFont(ofSize: 13)
        labelAuthor.textColor = .gray
        labelDate.font = UIFont.systemFont(ofSize: 12)
        labelDate.textColor = .secondaryLabel
        
        buttonStar.setImage(UIImage(systemName: "star"), for: .normal)
        buttonStar.tintColor = .systemYellow
        buttonStar.addTarget(self, action: #selector(didTapStar), for: .touchUpInside)
        
        [labelTitle, labelAuthor, labelDate, buttonStar].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelAuthor.translatesAutoresizingMaskIntoConstraints = false
        labelDate.translatesAutoresizingMaskIntoConstraints = false
        buttonStar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            labelTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            labelAuthor.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 4),
            labelAuthor.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),
            labelAuthor.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            labelDate.centerYAnchor.constraint(equalTo: labelAuthor.centerYAnchor),
            labelDate.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            labelDate.widthAnchor.constraint(equalToConstant: 80),
            
            buttonStar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            buttonStar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            buttonStar.widthAnchor.constraint(equalToConstant: 24),
            buttonStar.heightAnchor.constraint(equalToConstant: 24)

        ])
    }
    
    func configure(title: String, author: String, date: String, postID: String, isSaved: Bool) {
        labelTitle.text = title
        labelAuthor.text = "by \(author)"
        labelDate.text = date
        self.postID = postID
        self.isSaved = isSaved
        updateStarAppearance()
    }
    
    private func updateStarAppearance() {
        let image = UIImage(systemName: isSaved ? "star.fill" : "star")
        buttonStar.setImage(image, for: .normal)
    }
    
    @objc private func didTapStar() {
        guard let postID = postID else { return }

        // 未登录交给控制器处理
        if Auth.auth().currentUser == nil {
            onToggleSave?(postID, isSaved)    // 不改变 isSaved，让 VC 决定是否弹窗
            return
        }

        // 切换状态
        isSaved.toggle()
        updateStarAppearance()

        onToggleSave?(postID, isSaved)
    }
}
