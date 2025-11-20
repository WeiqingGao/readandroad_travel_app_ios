//
//  RegisterViewController.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//

import UIKit

class RegisterViewController: UIViewController {
    
    let notificationCenter = NotificationCenter.default
    let registerScreen = RegisterView()
    
    override func loadView() {
        view = registerScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerScreen.buttonSignUp.addTarget(
            self,
            action: #selector(onButtonSignUpTapped),
            for: .touchUpInside
        )
        
        notificationCenter.addObserver(self,
                                       selector: #selector(onRegisterSuccess(notification:)),
                                       name: .userRegistered,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(onRegisterError(notification:)),
                                       name: .authFailed,
                                       object: nil)
    }
    
    @objc func onButtonSignUpTapped() {
        let name = registerScreen.textFieldName.text ?? ""
        let email = registerScreen.textFieldEmail.text ?? ""
        let password = registerScreen.textFieldPassword.text ?? ""
        let rePassword = registerScreen.textFieldRePassword.text ?? ""
        
        // MARK: - Validation
        if !AuthValidator.isNameValid(name) {
            AlertHelper.showError(self, message: "Name cannot be empty")
            return
        }
        
        if !AuthValidator.isEmailValid(email) {
            AlertHelper.showError(self, message: "Invalid email format")
            return
        }
        
        if !AuthValidator.isPasswordValid(password) {
            AlertHelper.showError(self, message: "Password must be at least 6 characters")
            return
        }
        
        if !AuthValidator.isPasswordMatch(password, rePassword) {
            AlertHelper.showError(self, message: "Passwords do not match")
            return
        }
        
        // MARK: - API calling
        let parameters = [
            "name": name,
            "email": email,
            "password": password
        ]
        
        AuthService.shared.register(parameters: parameters)
    }
    
    @objc func onRegisterSuccess(notification: Notification) {
        navigationController?.pushViewController(ViewController(), animated: true)
    }
    
    @objc func onRegisterError(notification: Notification) {
        let message = notification.object as? String ?? "Registration failed"
        AlertHelper.showError(self, message: message)
    }
}
