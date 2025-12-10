//
//  SignInVC+Actions.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import UIKit

extension SignInViewController {
    
    /// Wires button taps to their respective handlers.
    func setupActions() {
        signInView.buttonSignIn.addTarget(
            self,
            action: #selector(onSignInTapped),
            for: .touchUpInside
        )
        
        signInView.buttonSignUp.addTarget(
            self,
            action: #selector(onSignUpTapped),
            for: .touchUpInside
        )
    }
    
    /// Handles login attempt.
    @objc func onSignInTapped() {
        let email = signInView.textFieldEmail.text ?? ""
        let password = signInView.textFieldPassword.text ?? ""
        
        // MARK: - Validation
        if !AuthValidator.isEmailValid(email) {
            AlertHelper.showError(self, message: "Invalid email format.")
            return
        }
        
        if !AuthValidator.isPasswordValid(password) {
            AlertHelper.showError(self, message: "Password must be at least 6 characters.")
            return
        }
        
        AuthService.shared.login(parameters: [
            "email": email,
            "password": password
        ])
    }
    
    /// Navigates to the registration screen.
    @objc func onSignUpTapped() {
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
}
