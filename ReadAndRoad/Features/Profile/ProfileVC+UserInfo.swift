//
//  ProfileVC+UserInfo.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//


import UIKit
import FirebaseAuth
import FirebaseFirestore

extension ProfileViewController {

    /// Loads display name and avatar from Firestore.
    func loadUserInfo() {

        guard let uid = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("users").document(uid).getDocument { [weak self] snapshot, _ in

            guard let data = snapshot?.data(), let self = self else { return }

            let name = data["name"] as? String ?? "Unknown"
            let email = data["email"] as? String ?? Auth.auth().currentUser?.email ?? ""
            self.profileView.textFieldNickname.text = name
            self.profileView.labelEmail.text = email
        }
    }
}
