//
//  RegisterView.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//


import UIKit

class RegisterView: UIView {
    // MARK: - UI elements
    var labelName: UILabel!
    var textFieldName: UITextField!
    var labelEmail: UILabel!
    var textFieldEmail: UITextField!
    var labelPassword: UILabel!
    var textFieldPassword: UITextField!
    var labelRePassword: UILabel!
    var textFieldRePassword: UITextField!
    var buttonSignUp: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupLabelName()
        setupTextFieldName()
        setupLabelEmail()
        setupTextFieldEmail()
        setupLabelPassword()
        setupTextFieldPassword()
        setupLabelRePassword()
        setupTextFieldRePassword()
        setupButtonSignUp()
        
        initConstraints()
    }
    
    // MARK: - Name
    func setupLabelName() {
        labelName = UILabel()
        labelName.text = "Name"
        labelName.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelName)
    }
    
    func setupTextFieldName() {
        textFieldName = UITextField()
        textFieldName.placeholder = "Enter your name"
        textFieldName.borderStyle = .roundedRect
        textFieldName.autocapitalizationType = .none
        textFieldName.autocorrectionType = .no
        textFieldName.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldName)
    }
    
    // MARK: - Email
    func setupLabelEmail() {
        labelEmail = UILabel()
        labelEmail.text = "Email"
        labelEmail.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        labelEmail.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelEmail)
    }
    
    func setupTextFieldEmail() {
        textFieldEmail = UITextField()
        textFieldEmail.placeholder = "Enter your email"
        textFieldEmail.borderStyle = .roundedRect
        textFieldEmail.keyboardType = .emailAddress
        textFieldEmail.autocapitalizationType = .none
        textFieldEmail.autocorrectionType = .no
        textFieldEmail.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldEmail)
    }
    
    // MARK: - Password
    func setupLabelPassword() {
        labelPassword = UILabel()
        labelPassword.text = "Password"
        labelPassword.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        labelPassword.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelPassword)
    }
    
    func setupTextFieldPassword() {
        textFieldPassword = UITextField()
        textFieldPassword.placeholder = "Enter your password"
        textFieldPassword.borderStyle = .roundedRect
        textFieldPassword.isSecureTextEntry = true
        textFieldPassword.autocapitalizationType = .none
        textFieldPassword.autocorrectionType = .no
        textFieldPassword.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldPassword)
    }
    
    // MARK: - Re-enter Password
    func setupLabelRePassword() {
        labelRePassword = UILabel()
        labelRePassword.text = "Re-enter Password"
        labelRePassword.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        labelRePassword.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelRePassword)
    }
    
    func setupTextFieldRePassword() {
        textFieldRePassword = UITextField()
        textFieldRePassword.placeholder = "Re-enter your password"
        textFieldRePassword.borderStyle = .roundedRect
        textFieldRePassword.isSecureTextEntry = true
        textFieldRePassword.autocapitalizationType = .none
        textFieldRePassword.autocorrectionType = .no
        textFieldRePassword.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldRePassword)
    }
    
    // MARK: - Sign Up Button
    func setupButtonSignUp() {
        buttonSignUp = UIButton(type: .system)
        buttonSignUp.setTitle("Sign Up", for: .normal)
        buttonSignUp.titleLabel?.font = .boldSystemFont(ofSize: 18)
        buttonSignUp.backgroundColor = .systemBlue
        buttonSignUp.tintColor = .white
        buttonSignUp.layer.cornerRadius = 8
        buttonSignUp.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonSignUp)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Name
            labelName.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 40),
            labelName.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            textFieldName.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8),
            textFieldName.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            textFieldName.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textFieldName.heightAnchor.constraint(equalToConstant: 42),
            
            // Email
            labelEmail.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant: 20),
            labelEmail.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            
            textFieldEmail.topAnchor.constraint(equalTo: labelEmail.bottomAnchor, constant: 8),
            textFieldEmail.leadingAnchor.constraint(equalTo: textFieldName.leadingAnchor),
            textFieldEmail.trailingAnchor.constraint(equalTo: textFieldName.trailingAnchor),
            textFieldEmail.heightAnchor.constraint(equalToConstant: 42),
            
            // Password
            labelPassword.topAnchor.constraint(equalTo: textFieldEmail.bottomAnchor, constant: 20),
            labelPassword.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            
            textFieldPassword.topAnchor.constraint(equalTo: labelPassword.bottomAnchor, constant: 8),
            textFieldPassword.leadingAnchor.constraint(equalTo: textFieldName.leadingAnchor),
            textFieldPassword.trailingAnchor.constraint(equalTo: textFieldName.trailingAnchor),
            textFieldPassword.heightAnchor.constraint(equalToConstant: 42),
            
            // Re-enter Password
            labelRePassword.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 20),
            labelRePassword.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            
            textFieldRePassword.topAnchor.constraint(equalTo: labelRePassword.bottomAnchor, constant: 8),
            textFieldRePassword.leadingAnchor.constraint(equalTo: textFieldName.leadingAnchor),
            textFieldRePassword.trailingAnchor.constraint(equalTo: textFieldName.trailingAnchor),
            textFieldRePassword.heightAnchor.constraint(equalToConstant: 42),
            
            // Button
            buttonSignUp.topAnchor.constraint(equalTo: textFieldRePassword.bottomAnchor, constant: 40),
            buttonSignUp.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            buttonSignUp.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.6),
            buttonSignUp.heightAnchor.constraint(equalToConstant: 46)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
