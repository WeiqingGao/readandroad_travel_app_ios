//
//  MessageView.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//

import UIKit

class MessageView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UI Components
    var labelSignInPrompt: UILabel!
    var buttonSignIn: UIButton!
    
    var buttonFavorites: UIButton!
    var buttonComments: UIButton!
    var tableViewChats: UITableView!
    
    var isLoggedIn: Bool = false {
        didSet { updateLayoutForLoginState() }
    }
    
    var chats: [(user: String, lastMessage: String)] = [] {
        didSet { tableViewChats.reloadData() }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
        updateLayoutForLoginState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    func setupSubviews() {
        // 未登录提示
        labelSignInPrompt = UILabel()
        labelSignInPrompt.text = "Sign In to See Your Messages"
        labelSignInPrompt.textAlignment = .center
        labelSignInPrompt.font = .systemFont(ofSize: 18, weight: .semibold)
        labelSignInPrompt.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelSignInPrompt)
        
        buttonSignIn = UIButton(type: .system)
        buttonSignIn.setTitle("Sign In", for: .normal)
        buttonSignIn.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        buttonSignIn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonSignIn)
        
        // 登录状态组件
        buttonFavorites = UIButton(type: .system)
        buttonFavorites.setTitle("Favorites", for: .normal)
        buttonFavorites.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        buttonFavorites.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonFavorites)
        
        buttonComments = UIButton(type: .system)
        buttonComments.setTitle("Comments", for: .normal)
        buttonComments.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        buttonComments.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonComments)
        
        tableViewChats = UITableView()
        tableViewChats.register(UITableViewCell.self, forCellReuseIdentifier: "ChatCell")
        tableViewChats.translatesAutoresizingMaskIntoConstraints = false
        tableViewChats.delegate = self
        tableViewChats.dataSource = self
        addSubview(tableViewChats)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            labelSignInPrompt.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelSignInPrompt.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            
            buttonSignIn.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonSignIn.topAnchor.constraint(equalTo: labelSignInPrompt.bottomAnchor, constant: 16),
            
            buttonFavorites.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            buttonFavorites.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            buttonComments.topAnchor.constraint(equalTo: buttonFavorites.topAnchor),
            buttonComments.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            tableViewChats.topAnchor.constraint(equalTo: buttonFavorites.bottomAnchor, constant: 12),
            tableViewChats.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableViewChats.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableViewChats.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - 切换布局
    private func updateLayoutForLoginState() {
        labelSignInPrompt.isHidden = isLoggedIn
        buttonSignIn.isHidden = isLoggedIn
        buttonFavorites.isHidden = !isLoggedIn
        buttonComments.isHidden = !isLoggedIn
        tableViewChats.isHidden = !isLoggedIn
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath)
        let chat = chats[indexPath.row]
        cell.textLabel?.text = "\(chat.user): \(chat.lastMessage)"
        cell.textLabel?.numberOfLines = 2
        return cell
    }
}
