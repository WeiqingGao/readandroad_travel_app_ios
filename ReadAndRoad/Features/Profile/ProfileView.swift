//
//  ProfileView.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//

import UIKit

class ProfileView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UI Components
    var imageViewAvatar: UIImageView!
    var textFieldNickname: UITextField!
    var labelEmail: UILabel!
    var buttonChangePassword: UIButton!
    var segmentedControl: UISegmentedControl!
    var tableViewPosts: UITableView!
    var buttonSave: UIButton!
    
    // MARK: - 控制显示
    var isLoggedIn: Bool = false {
        didSet {
            updateLoginStateUI()
        }
    }

    // 头像点击回调（由 Controller 设置）
    var onAvatarTapped: (() -> Void)?
    
    // 模拟数据
    var posts: [(id: String, title: String, author: String, date: String, isSaved: Bool)] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableViewPosts.reloadData()
            }
        }
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        addSubview(loginPromptLabel)
        addSubview(loginButton)
        
        setupTopSection()
        setupSegmentSection()
        setupTableView()
        setupConstraints()

        loginPromptLabel.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false

        loginButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 未登录时显示的提示视图
    private let loginPromptLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign In to see your information"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    private let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign In", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        btn.isHidden = true
        return btn
    }()

    // 登录按钮点击回调
    var onSignInTapped: (() -> Void)?
    
    // MARK: - Top Section
    func setupTopSection() {
        imageViewAvatar = UIImageView(image: UIImage(systemName: "person.circle"))
        imageViewAvatar.tintColor = .systemGray
        imageViewAvatar.contentMode = .scaleAspectFit
        imageViewAvatar.isUserInteractionEnabled = true // ✅ 开启点击
        imageViewAvatar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageViewAvatar)

        // 添加手势
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
    }
    
    @objc private func didTapAvatar() {
        onAvatarTapped?()
    }
    
    // MARK: - Segment Section
    func setupSegmentSection() {
        segmentedControl = UISegmentedControl(items: ["My Posts", "Saved Posts"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(segmentedControl)
    }
    
    // MARK: - TableView Section
    func setupTableView() {
        tableViewPosts = UITableView()
        tableViewPosts.register(CommunityPostCell.self, forCellReuseIdentifier: "ProfilePostCell")
        tableViewPosts.delegate = self
        tableViewPosts.dataSource = self
        tableViewPosts.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableViewPosts)
    }
    
    func updateLoginStateUI() {
        let shouldHideUserInfo = !isLoggedIn

        imageViewAvatar.isHidden = shouldHideUserInfo
        textFieldNickname.isHidden = shouldHideUserInfo
        labelEmail.isHidden = shouldHideUserInfo
        buttonChangePassword.isHidden = shouldHideUserInfo
        buttonSave.isHidden = shouldHideUserInfo

        loginPromptLabel.isHidden = isLoggedIn
        loginButton.isHidden = isLoggedIn

        tableViewPosts.reloadData()
    }

    @objc private func didTapSignIn() {
        onSignInTapped?()
    }
    
    // MARK: - Constraints
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // 顶部1/5
            imageViewAvatar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            imageViewAvatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            imageViewAvatar.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.22),
            imageViewAvatar.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.22),
            
            textFieldNickname.topAnchor.constraint(equalTo: imageViewAvatar.topAnchor),
            textFieldNickname.leadingAnchor.constraint(equalTo: imageViewAvatar.trailingAnchor, constant: 20),
            textFieldNickname.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            labelEmail.topAnchor.constraint(equalTo: textFieldNickname.bottomAnchor, constant: 4),
            labelEmail.leadingAnchor.constraint(equalTo: textFieldNickname.leadingAnchor),
            
            buttonChangePassword.topAnchor.constraint(equalTo: labelEmail.bottomAnchor, constant: 4),
            buttonChangePassword.leadingAnchor.constraint(equalTo: textFieldNickname.leadingAnchor),
            
            buttonSave.topAnchor.constraint(equalTo: buttonChangePassword.bottomAnchor, constant: 4),
            buttonSave.leadingAnchor.constraint(equalTo: textFieldNickname.leadingAnchor),
            
            // 中间切换区
            segmentedControl.topAnchor.constraint(equalTo: imageViewAvatar.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            // 表格部分
            tableViewPosts.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            tableViewPosts.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableViewPosts.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableViewPosts.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            // 未登录状态视图
            loginPromptLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginPromptLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),

            loginButton.topAnchor.constraint(equalTo: loginPromptLabel.bottomAnchor, constant: 12),
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoggedIn ? posts.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isLoggedIn {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Sign In to see your posts"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .secondaryLabel
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilePostCell", for: indexPath) as? CommunityPostCell else {
            return UITableViewCell()
        }
        let post = posts[indexPath.row]
        cell.configure(title: post.title,
                       author: post.author,
                       date: post.date,
                       postID: post.id,
                       isSaved: post.isSaved)
        return cell
    }
}
