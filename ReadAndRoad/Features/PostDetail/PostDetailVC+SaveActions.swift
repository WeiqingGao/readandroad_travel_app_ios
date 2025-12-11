//
//  PostDetailVC+SaveActions.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import UIKit
import FirebaseAuth

extension PostDetailViewController {

    func applyInitialSaveState() {
        isSavedByCurrentUser = SavedPostStore.shared.isSaved(post.id)
    }

    func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onSavedPostsUpdated),
            name: .savedPostsUpdated,
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
        let newValue = SavedPostStore.shared.isSaved(post.id)
        if newValue != isSavedByCurrentUser {
            isSavedByCurrentUser = newValue
            // Refresh header section only
            mainView.tableView.reloadSections(IndexSet(integer: 0), with: .none)
        }
    }

    func toggleSave() {
        guard Auth.auth().currentUser != nil else {
            presentLoginAlert()
            return
        }

        let target = !isSavedByCurrentUser

        SavedPostService.shared.setSaved(target, postID: post.id) { error in
            if let error = error {
                print("Failed to update saved status in PostDetail:", error)
            }
        }
    }

    func presentLoginAlert() {
        let alert = UIAlertController(
            title: "Login Required",
            message: "Please sign in to perform this action.",
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

    @objc func onUserNicknameUpdated(_ notification: Notification) {
        guard
            let newName = notification.userInfo?["newName"] as? String,
            let uid = Auth.auth().currentUser?.uid
        else { return }

        if post.authorId == uid {
            post.authorName = newName
        }

        for i in comments.indices where comments[i].authorId == uid {
            comments[i].authorName = newName
        }

        mainView.tableView.reloadData()
    }
}
