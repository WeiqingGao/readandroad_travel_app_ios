//
//  SignInVC+NotificationHandlers.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import UIKit

extension SignInViewController {

    /// Registers observers for authentication result notifications.
    func setupNotificationObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onLoginSuccess),
            name: .userLoggedIn,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onLoginError(_:)),
            name: .authFailed,
            object: nil
        )
    }

    /// Called when login succeeds.
    @objc func onLoginSuccess() {
        navigationController?.popViewController(animated: true)
    }

    /// Called when login fails.
    @objc func onLoginError(_ notification: Notification) {
        let message = notification.object as? String ?? "Login failed."
        AlertHelper.showError(self, message: message)
    }
}
