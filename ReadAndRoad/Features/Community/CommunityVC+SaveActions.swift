//
//  CommunityVC+SaveActions.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import UIKit
import FirebaseAuth

extension ViewController {

    /// Handles user tapping the save/star icon on a post.
    func handleSaveToggle(postID: String, newStatus: Bool) {

        guard Auth.auth().currentUser != nil else {
            presentLoginAlert()
            return
        }

        SavedPostManager.shared.setSaved(newStatus, for: postID)
    }

    /// Shown when user tries to save a post while not logged in.
    func presentLoginAlert() {
        let alert = UIAlertController(
            title: "Sign In Required",
            message: "Please sign in to save posts.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Sign In", style: .default, handler: { _ in
            let vc = SignInViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }))

        present(alert, animated: true)
    }
}
