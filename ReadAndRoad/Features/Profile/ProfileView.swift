//
//  ProfileView.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//

import UIKit

class ProfileView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - 未登录视图
    var labelSignInPrompt: UILabel!
    var buttonSignIn: UIButton!
    
    // MARK: - 登录状态视图
    var imageViewAvatar: UIImageView!
    var textFieldNickname: UITextField!
    var labelEmail: UILabel!
    var buttonChangePassword: UIButton!
    var buttonSave: UIButton!
    var segmentedControl: UISegmentedControl!
    var tableViewPosts: UITableView!
    
    // MARK: - 状态变量
    var isLoggedIn: Bool = false {
        didSet { updateLayoutForLoginState() }
    }
    
    // MARK: - 回调
    var onSignInTapped: (() -> Void)?
    var onAvatarTapped: (() -> Void)?
    
    var posts: [Post] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableViewPosts.reloadData()
            }
        }
    }
    
    // MARK: - 初始化
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
    
    // MARK: - 视图设置
    func setupSubviews() {
        // 未登录状态
        labelSignInPrompt = UILabel()
        labelSignInPrompt.text = "Sign in to see your information"
        labelSignInPrompt.textAlignment = .center
        labelSignInPrompt.font = .systemFont(ofSize: 18, weight: .semibold)
        labelSignInPrompt.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelSignInPrompt)
        
        buttonSignIn = UIButton(type: .system)
        buttonSignIn.setTitle("Sign In", for: .normal)
        buttonSignIn.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        buttonSignIn.translatesAutoresizingMaskIntoConstraints = false
        buttonSignIn.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        addSubview(buttonSignIn)
        
        // 登录状态
        imageViewAvatar = UIImageView(image: UIImage(systemName: "person.circle"))
        imageViewAvatar.tintColor = .systemGray
        imageViewAvatar.contentMode = .scaleAspectFit
        imageViewAvatar.isUserInteractionEnabled = true
        imageViewAvatar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageViewAvatar)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        imageViewAvatar.addGestureRecognizer(tapGesture)
        
        textFieldNickname = UITextField()
        textFieldNickname.placeholder = "Your Nickname"
        textFieldNickname.borderStyle = .roundedRect
        textFieldNickname.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textFieldNickname.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textFieldNickname)
        
        labelEmail = UILabel()
        labelEmail.textColor = .secondaryLabel
        labelEmail.font = UIFont.systemFont(ofSize: 15)
        labelEmail.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelEmail)
        
        buttonChangePassword = UIButton(type: .system)
        buttonChangePassword.setTitle("Change Password", for: .normal)
        buttonChangePassword.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        buttonChangePassword.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonChangePassword)
        
        buttonSave = UIButton(type: .system)
        buttonSave.setTitle("Save", for: .normal)
        buttonSave.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        buttonSave.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonSave)
        
        segmentedControl = UISegmentedControl(items: ["My Posts", "Saved Posts"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(segmentedControl)
        
        tableViewPosts = UITableView()
        tableViewPosts.register(CommunityPostCell.self, forCellReuseIdentifier: "ProfilePostCell")
        tableViewPosts.delegate = self
        tableViewPosts.dataSource = self
        tableViewPosts.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableViewPosts)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // 未登录
            labelSignInPrompt.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelSignInPrompt.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            
            buttonSignIn.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonSignIn.topAnchor.constraint(equalTo: labelSignInPrompt.bottomAnchor, constant: 16),
            
            // 登录状态
            imageViewAvatar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            imageViewAvatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            imageViewAvatar.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.22),
            imageViewAvatar.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.22),
            
            textFieldNickname.topAnchor.constraint(equalTo: imageViewAvatar.topAnchor),
            textFieldNickname.leadingAnchor.constraint(equalTo: imageViewAvatar.trailingAnchor, constant: 20),
            textFieldNickname.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            labelEmail.topAnchor.constraint(equalTo: textFieldNickname.bottomAnchor, constant: 10),
            labelEmail.leadingAnchor.constraint(equalTo: textFieldNickname.leadingAnchor),
            
            buttonChangePassword.topAnchor.constraint(equalTo: labelEmail.bottomAnchor, constant: 10),
            buttonChangePassword.leadingAnchor.constraint(equalTo: textFieldNickname.leadingAnchor),
            
            buttonSave.topAnchor.constraint(equalTo: buttonChangePassword.bottomAnchor, constant: 10),
            buttonSave.leadingAnchor.constraint(equalTo: textFieldNickname.leadingAnchor),
            
            segmentedControl.topAnchor.constraint(equalTo: imageViewAvatar.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            tableViewPosts.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            tableViewPosts.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableViewPosts.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableViewPosts.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func updateLayoutForLoginState() {
        // 未登录时显示提示；登录时显示资料部分
        labelSignInPrompt.isHidden = isLoggedIn
        buttonSignIn.isHidden = isLoggedIn
        
        imageViewAvatar.isHidden = !isLoggedIn
        textFieldNickname.isHidden = !isLoggedIn
        labelEmail.isHidden = !isLoggedIn
        buttonChangePassword.isHidden = !isLoggedIn
        buttonSave.isHidden = !isLoggedIn
        segmentedControl.isHidden = !isLoggedIn
        tableViewPosts.isHidden = !isLoggedIn
    }
    
    @objc private func didTapSignIn() {
        onSignInTapped?()
    }
    
    @objc private func didTapAvatar() {
        onAvatarTapped?()
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "ProfilePostCell",
            for: indexPath
        ) as? CommunityPostCell else {
            return UITableViewCell()
        }
        
        let post = posts[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = post.createdAt.map { formatter.string(from: $0) } ?? ""
        
        cell.configure(
            title: post.text,
            author: post.authorName,
            date: dateString,
            postID: post.id,
            isSaved: false   // Saved逻辑后续添加
        )
        
        return cell
    }
}
