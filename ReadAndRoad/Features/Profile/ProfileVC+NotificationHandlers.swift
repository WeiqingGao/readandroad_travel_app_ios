//
//  ProfileVC+NotificationHandlers.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import UIKit
import FirebaseAuth

extension ProfileViewController {

    func setupObservers() {

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onSavedPostsUpdated),
            name: .savedPostsUpdated,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onAuthStateChanged),
            name: .authStateDidChange,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onUserNicknameUpdated(_:)),
            name: .userNicknameUpdated,
            object: nil
        )
    }

    @objc func onSavedPostsUpdated() {
        if selectedSegmentIndex == 1 {
            loadSavedPosts(reset: true)
        }
    }

    @objc func onAuthStateChanged() {
        updateLoginStateUI()
    }
    
    @objc func onUserNicknameUpdated(_ notification: Notification) {
        guard let newName = notification.userInfo?["newName"] as? String else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }

        // Update My Posts
        for i in myPosts.indices {
            if myPosts[i].authorId == uid {
                myPosts[i].authorName = newName
            }
        }

        // Update Saved Posts
        for i in savedPosts.indices {
            if savedPosts[i].authorId == uid {
                savedPosts[i].authorName = newName
            }
        }

        profileView.tableViewPosts.reloadData()
    }

}
