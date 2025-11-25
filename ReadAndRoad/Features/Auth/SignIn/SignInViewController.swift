//
//  SignInViewController.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//

import UIKit

class SignInViewController: UIViewController {
    
    let notificationCenter = NotificationCenter.default
    let signInScreen = SignInView()
    
    override func loadView() {
        view = signInScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInScreen.buttonSignIn.addTarget(self, action: #selector(onSignInTapped), for: .touchUpInside)
        signInScreen.buttonSignUp.addTarget(self, action: #selector(onSignUpTapped), for: .touchUpInside)
        
        notificationCenter.addObserver(
            self,
            selector:#selector(onLoginSuccess(notification:)),
            name: .userLoggedIn,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector:#selector(onLoginError(notification:)),
            name: .authFailed,
            object: nil
        )
    }
    
    // Add navigation bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        title = "Sign In"
    }
    
    @objc func onSignInTapped() {
        let email = signInScreen.textFieldEmail.text ?? ""
        let password = signInScreen.textFieldPassword.text ?? ""
        
        // MARK: - Validation
        if !AuthValidator.isEmailValid(email) {
            AlertHelper.showError(self, message: "Invalid email format")
            return
        }
        
        if !AuthValidator.isPasswordValid(password) {
            AlertHelper.showError(self, message: "Password must be at least 6 characters")
            return
        }
        
        AuthService.shared.login(parameters: ["email": email, "password": password])
    }
    
    @objc func onSignUpTapped() {
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    @objc func onLoginSuccess(notification: Notification) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func onLoginError(notification: Notification) {
        let msg = notification.object as? String ?? "Login failed"
        AlertHelper.showError(self, message: msg)
    }
}
