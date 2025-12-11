//
//  ProfileView.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//

import UIKit

/// View for displaying user profile, login prompt, and post lists.
class ProfileView: UIView {

    // MARK: - Public UI Components

    // Not logged in
    var labelSignInPrompt: UILabel!
    var buttonSignIn: UIButton!

    // Logged in - User Info
    var imageViewAvatar: UIImageView!
    var textFieldNickname: UITextField!
    var buttonEditNickname: UIButton!
    var labelEmail: UILabel!
    var buttonChangePassword: UIButton!

    // Logged in - Posts
    var segmentControl: UISegmentedControl!
    var tableViewPosts: UITableView!

    // MARK: - State
    var isLoggedIn: Bool = false {
        didSet { updateLayoutForLoginState() }
    }

    // Callbacks
    var onSignInTapped: (() -> Void)?
    var onAvatarTapped: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground

        setupSignInPrompt()
        setupSignInButton()

        setupAvatar()
        setupNicknameField()
        setupEditNicknameButton()
        setupEmailLabel()
        setupChangePasswordButton()

        setupSegmentControl()
        setupTableView()

        setupConstraints()
        updateLayoutForLoginState()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI Components

    // --- Not logged in ---

    func setupSignInPrompt() {
        labelSignInPrompt = UILabel()
        labelSignInPrompt.text = "Sign in to see your information"
        labelSignInPrompt.font = .systemFont(ofSize: 18, weight: .semibold)
        labelSignInPrompt.textAlignment = .center
        labelSignInPrompt.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelSignInPrompt)
    }

    func setupSignInButton() {
        buttonSignIn = UIButton(type: .system)
        buttonSignIn.setTitle("Sign In", for: .normal)
        buttonSignIn.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        buttonSignIn.translatesAutoresizingMaskIntoConstraints = false
        buttonSignIn.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        addSubview(buttonSignIn)
    }

    // --- Logged in: User Info ---

    func setupAvatar() {
        imageViewAvatar = UIImageView(image: UIImage(systemName: "person.circle"))
        imageViewAvatar.tintColor = .systemGray
        imageViewAvatar.contentMode = .scaleAspectFit
        imageViewAvatar.translatesAutoresizingMaskIntoConstraints = false
        imageViewAvatar.isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        imageViewAvatar.addGestureRecognizer(tap)

        addSubview(imageViewAvatar)
    }

    func setupNicknameField() {
        textFieldNickname = UITextField()
        textFieldNickname.placeholder = "Your Nickname"
        textFieldNickname.borderStyle = .none
        textFieldNickname.isUserInteractionEnabled = false
        textFieldNickname.font = .systemFont(ofSize: 16, weight: .medium)
        textFieldNickname.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textFieldNickname)
    }

    func setupEditNicknameButton() {
        buttonEditNickname = UIButton(type: .system)
        buttonEditNickname.setImage(UIImage(systemName: "pencil"), for: .normal)
        buttonEditNickname.tintColor = .secondaryLabel
        buttonEditNickname.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonEditNickname)
    }

    func setupEmailLabel() {
        labelEmail = UILabel()
        labelEmail.font = .systemFont(ofSize: 15)
        labelEmail.textColor = .secondaryLabel
        labelEmail.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelEmail)
    }

    func setupChangePasswordButton() {
        buttonChangePassword = UIButton(type: .system)
        buttonChangePassword.setTitle("Change Password", for: .normal)
        buttonChangePassword.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        buttonChangePassword.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonChangePassword)
    }

    // --- Logged in: Posts list ---

    func setupSegmentControl() {
        segmentControl = UISegmentedControl(items: ["My Posts", "Saved Posts"])
        segmentControl.selectedSegmentIndex = 0
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(segmentControl)
    }

    func setupTableView() {
        tableViewPosts = UITableView()
        tableViewPosts.translatesAutoresizingMaskIntoConstraints = false
        tableViewPosts.register(CommunityPostCell.self, forCellReuseIdentifier: "ProfilePostCell")
        addSubview(tableViewPosts)
    }

    // MARK: - Constraints

    func setupConstraints() {
        NSLayoutConstraint.activate([
            // --- Not logged in ---
            labelSignInPrompt.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelSignInPrompt.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),

            buttonSignIn.topAnchor.constraint(equalTo: labelSignInPrompt.bottomAnchor, constant: 16),
            buttonSignIn.centerXAnchor.constraint(equalTo: centerXAnchor),

            // --- Avatar ---
            imageViewAvatar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            imageViewAvatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            imageViewAvatar.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.22),
            imageViewAvatar.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.22),

            // --- Nickname ---
            textFieldNickname.topAnchor.constraint(equalTo: imageViewAvatar.topAnchor),
            textFieldNickname.leadingAnchor.constraint(equalTo: imageViewAvatar.trailingAnchor, constant: 20),

            buttonEditNickname.centerYAnchor.constraint(equalTo: textFieldNickname.centerYAnchor),
            buttonEditNickname.leadingAnchor.constraint(equalTo: textFieldNickname.trailingAnchor, constant: 8),
            buttonEditNickname.widthAnchor.constraint(equalToConstant: 24),
            buttonEditNickname.heightAnchor.constraint(equalToConstant: 24),

            // --- Email ---
            labelEmail.topAnchor.constraint(equalTo: textFieldNickname.bottomAnchor, constant: 10),
            labelEmail.leadingAnchor.constraint(equalTo: textFieldNickname.leadingAnchor),

            // --- Change Password ---
            buttonChangePassword.topAnchor.constraint(equalTo: labelEmail.bottomAnchor, constant: 10),
            buttonChangePassword.leadingAnchor.constraint(equalTo: textFieldNickname.leadingAnchor),

            // --- Segment Control ---
            segmentControl.topAnchor.constraint(equalTo: buttonChangePassword.bottomAnchor, constant: 20),
            segmentControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            segmentControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),

            // --- Table View ---
            tableViewPosts.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 10),
            tableViewPosts.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableViewPosts.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableViewPosts.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - Login Layout Handling

    func updateLayoutForLoginState() {
        let show = isLoggedIn

        // Not logged in
        labelSignInPrompt.isHidden = show
        buttonSignIn.isHidden = show

        // Logged in content
        imageViewAvatar.isHidden = !show
        textFieldNickname.isHidden = !show
        buttonEditNickname.isHidden = !show
        labelEmail.isHidden = !show
        buttonChangePassword.isHidden = !show
        segmentControl.isHidden = !show
        tableViewPosts.isHidden = !show
    }

    // MARK: - Actions

    @objc private func didTapSignIn() {
        onSignInTapped?()
    }

    @objc private func didTapAvatar() {
        onAvatarTapped?()
    }
}
