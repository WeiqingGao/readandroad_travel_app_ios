//
//  ProfileVC+SaveActions.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import UIKit
import FirebaseAuth

extension ProfileViewController {

    /// Handle star button toggle from cells (My Posts / Saved Posts).
    func handleSaveToggle(postID: String, newStatus: Bool) {

        // If user is not signed in, show login alert
        guard Auth.auth().currentUser != nil else {
            presentLoginAlertFromProfile()
            return
        }

        // Update Firestore saved state
        SavedPostService.shared.setSaved(newStatus, postID: postID) { error in
            if let error = error {
                print("Failed to update saved status:", error)
            }
        }
    }

    /// Alert: user must sign in to save posts.
    private func presentLoginAlertFromProfile() {
        let alert = UIAlertController(
            title: "Sign In Required",
            message: "Please sign in to save posts.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Sign In", style: .default, handler: { [weak self] _ in
            let vc = SignInViewController()
            vc.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(vc, animated: true)
        }))

        present(alert, animated: true)
    }
}

