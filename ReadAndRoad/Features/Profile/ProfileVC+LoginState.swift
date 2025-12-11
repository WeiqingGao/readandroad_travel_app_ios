//
//  ProfileVC+LoginState.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import UIKit
import FirebaseAuth

extension ProfileViewController {

    /// Updates UI depending on login status.
    func updateLoginStateUI() {
        let isLoggedIn = Auth.auth().currentUser != nil
        profileView.isLoggedIn = isLoggedIn

        if isLoggedIn {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "Sign Out",
                style: .plain,
                target: self,
                action: #selector(onLogoutTapped)
            )
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }

    /// Connect button actions (logout, edit profile, segment changed)
    func setupTargets() {
        profileView.segmentControl.addTarget(self,
                                             action: #selector(onSegmentChanged),
                                             for: .valueChanged)
    }

    @objc func onLogoutTapped() {
        do {
            try Auth.auth().signOut()
            SavedPostStore.shared.stop()
            updateLoginStateUI()
        } catch {
            print("Logout error:", error)
        }
    }

    @objc func onSegmentChanged() {
        selectedSegmentIndex = profileView.segmentControl.selectedSegmentIndex
        profileView.tableViewPosts.reloadData()
    }
}
