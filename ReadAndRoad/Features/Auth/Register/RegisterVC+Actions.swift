//
//  RegisterVC+Actions.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import UIKit

extension RegisterViewController {

    /// Wires UI components to their button tap handlers.
    func setupActions() {
        registerView.buttonSignUp.addTarget(
            self,
            action: #selector(onSignUpTapped),
            for: .touchUpInside
        )
    }

    /// Handles user registration request.
    @objc func onSignUpTapped() {
        let name = registerView.textFieldName.text ?? ""
        let email = registerView.textFieldEmail.text ?? ""
        let password = registerView.textFieldPassword.text ?? ""
        let rePassword = registerView.textFieldRePassword.text ?? ""

        // MARK: - Input Validation

        if !AuthValidator.isNameValid(name) {
            AlertHelper.showError(self, message: "Name cannot be empty.")
            return
        }

        if !AuthValidator.isEmailValid(email) {
            AlertHelper.showError(self, message: "Invalid email format.")
            return
        }

        if !AuthValidator.isPasswordValid(password) {
            AlertHelper.showError(self, message: "Password must be at least 6 characters.")
            return
        }

        if !AuthValidator.isPasswordMatch(password, rePassword) {
            AlertHelper.showError(self, message: "Passwords do not match.")
            return
        }

        // MARK: - API Call

        AuthService.shared.register(parameters: [
            "name" : name,
            "email": email,
            "password": password
        ])
    }
}
