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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onPostCreated),
            name: .postCreated,
            object: nil
        )

    }

    @objc func onSavedPostsUpdated() {
        loadSavedPosts(reset: true)

        if selectedSegmentIndex == 1 {
            profileView.tableViewPosts.reloadData()
        }
    }


    @objc func onAuthStateChanged() {
        updateLoginStateUI()

        if Auth.auth().currentUser != nil {
            SavedPostStore.shared.start()
            loadUserInfo()
            loadMyPosts(reset: true)
            loadSavedPosts(reset: true)
        } else {
            SavedPostStore.shared.stop()
            myPosts.removeAll()
            savedPosts.removeAll()
            profileView.tableViewPosts.reloadData()
            profileView.textFieldNickname.text = ""
            profileView.labelEmail.text = ""
        }
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
    
    @objc func onPostCreated() {
        guard Auth.auth().currentUser != nil else { return }
        loadMyPosts(reset: true)
    }


}
