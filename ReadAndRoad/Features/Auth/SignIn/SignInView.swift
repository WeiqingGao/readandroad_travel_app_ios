//
//  SignInView.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//

import UIKit

/// Login screen layout containing email, password, and navigation to sign-up.
class SignInView: UIView {
    
    // MARK: - UI Components
    
    var labelWelcome: UILabel!
    var labelEmail: UILabel!
    var textFieldEmail: UITextField!
    var labelPassword: UILabel!
    var textFieldPassword: UITextField!
    var labelSignUpReminder: UILabel!
    var buttonSignUp: UIButton!
    var buttonSignIn: UIButton!
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupLabelWelcome()
        setupLabelEmail()
        setupTextFieldEmail()
        setupLabelPassword()
        setupTextFieldPassword()
        setupLabelSignUpReminder()
        setupButtonSignUp()
        setupButtonSignIn()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    func setupLabelWelcome() {
        labelWelcome = UILabel()
        labelWelcome.text = "Welcome to TravelMate"
        labelWelcome.font = UIFont.boldSystemFont(ofSize: 24)
        labelWelcome.textAlignment = .center
        labelWelcome.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelWelcome)
    }
    
    func setupLabelEmail() {
        labelEmail = UILabel()
        labelEmail.text = "Email"
        labelEmail.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        labelEmail.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelEmail)
    }
    
    func setupTextFieldEmail() {
        textFieldEmail = UITextField()
        textFieldEmail.placeholder = "Enter your email"
        textFieldEmail.borderStyle = .roundedRect
        textFieldEmail.keyboardType = .emailAddress
        textFieldEmail.autocapitalizationType = .none
        textFieldEmail.autocorrectionType = .no
        textFieldEmail.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textFieldEmail)
    }
    
    func setupLabelPassword() {
        labelPassword = UILabel()
        labelPassword.text = "Password"
        labelPassword.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        labelPassword.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelPassword)
    }
    
    func setupTextFieldPassword() {
        textFieldPassword = UITextField()
        textFieldPassword.placeholder = "Enter your password"
        textFieldPassword.borderStyle = .roundedRect
        textFieldPassword.isSecureTextEntry = true
        textFieldPassword.autocapitalizationType = .none
        textFieldPassword.autocorrectionType = .no
        textFieldPassword.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textFieldPassword)
    }
    
    func setupLabelSignUpReminder() {
        labelSignUpReminder = UILabel()
        labelSignUpReminder.text = "A new traveler?"
        labelSignUpReminder.font = UIFont.systemFont(ofSize: 14)
        labelSignUpReminder.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelSignUpReminder)
    }
    
    func setupButtonSignUp() {
        buttonSignUp = UIButton(type: .system)
        buttonSignUp.setTitle("Create an account", for: .normal)
        buttonSignUp.titleLabel?.font = .boldSystemFont(ofSize: 14)
        buttonSignUp.tintColor = .systemBlue
        buttonSignUp.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonSignUp)
    }
    
    func setupButtonSignIn() {
        buttonSignIn = UIButton(type: .system)
        buttonSignIn.setTitle("Sign In", for: .normal)
        buttonSignIn.titleLabel?.font = .boldSystemFont(ofSize: 18)
        buttonSignIn.backgroundColor = .systemBlue
        buttonSignIn.tintColor = .white
        buttonSignIn.layer.cornerRadius = 8
        buttonSignIn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonSignIn)
    }
    
    // MARK: - Constraints
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            labelWelcome.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80),
            labelWelcome.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            labelSignUpReminder.topAnchor.constraint(equalTo: labelWelcome.bottomAnchor, constant: 20),
            labelSignUpReminder.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            buttonSignUp.centerYAnchor.constraint(equalTo: labelSignUpReminder.centerYAnchor),
            buttonSignUp.leadingAnchor.constraint(equalTo: labelSignUpReminder.trailingAnchor, constant: 8),
            
            labelEmail.topAnchor.constraint(equalTo: labelSignUpReminder.bottomAnchor, constant: 40),
            labelEmail.leadingAnchor.constraint(equalTo: labelSignUpReminder.leadingAnchor),
            
            textFieldEmail.topAnchor.constraint(equalTo: labelEmail.bottomAnchor, constant: 8),
            textFieldEmail.leadingAnchor.constraint(equalTo: labelEmail.leadingAnchor),
            textFieldEmail.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textFieldEmail.heightAnchor.constraint(equalToConstant: 42),
            
            labelPassword.topAnchor.constraint(equalTo: textFieldEmail.bottomAnchor, constant: 20),
            labelPassword.leadingAnchor.constraint(equalTo: labelEmail.leadingAnchor),
            
            textFieldPassword.topAnchor.constraint(equalTo: labelPassword.bottomAnchor, constant: 8),
            textFieldPassword.leadingAnchor.constraint(equalTo: labelEmail.leadingAnchor),
            textFieldPassword.trailingAnchor.constraint(equalTo: textFieldEmail.trailingAnchor),
            textFieldPassword.heightAnchor.constraint(equalToConstant: 42),
            
            buttonSignIn.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 40),
            buttonSignIn.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonSignIn.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.6)
        ])
    }
}
