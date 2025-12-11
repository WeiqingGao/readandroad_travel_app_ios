//
//  ProfileVC+NicknameEditing.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

extension ProfileViewController: UITextFieldDelegate {

    func setupNicknameEditing() {
        profileView.textFieldNickname.delegate = self
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        saveNickname()
        profileView.textFieldNickname.isUserInteractionEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func onEditNicknameTapped() {
        profileView.textFieldNickname.isUserInteractionEnabled = true
        profileView.textFieldNickname.becomeFirstResponder()
    }

    func saveNickname() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let name = profileView.textFieldNickname.text ?? ""

        Firestore.firestore().collection("users").document(uid)
            .setData(["name": name], merge: true)

        NotificationCenter.default.post(
            name: .userNicknameUpdated,
            object: nil,
            userInfo: ["newName": name]
        )
    }

}

