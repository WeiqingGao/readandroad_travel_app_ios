//
//  RegisterVC+NotificationHandlers.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import UIKit

extension RegisterViewController {

    /// Adds observers for authentication-related notifications.
    func setupNotificationObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onRegisterSuccess),
            name: .userRegistered,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onRegisterError(_:)),
            name: .authFailed,
            object: nil
        )
    }

    /// Called when registration succeeds.
    @objc func onRegisterSuccess() {
        navigationController?.popViewController(animated: true)
    }

    /// Called when registration fails.
    @objc func onRegisterError(_ notification: Notification) {
        let message = notification.object as? String ?? "Registration failed."
        AlertHelper.showError(self, message: message)
    }
}

