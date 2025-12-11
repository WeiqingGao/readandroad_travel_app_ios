//
//  CommunityVC+NotificationHandlers.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import UIKit
import FirebaseAuth

extension ViewController {

    /// Adds observers for saved-related notifications.
    func setupNotificationObservers() {
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

    /// Called when save/unsave a post.
    @objc func onSavedPostsUpdated() {
        communityView.tableViewPosts.reloadData()
    }
    
    @objc func onUserNicknameUpdated(_ notification: Notification) {
        guard let newName = notification.userInfo?["newName"] as? String else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }

        // Update all posts currently shown in community feed
        for i in posts.indices {
            if posts[i].authorId == uid {
                posts[i].authorName = newName
            }
        }

        communityView.tableViewPosts.reloadData()
    }
    
    /// Start SavedPostStore + Firestore listeners
    func startListening() {

        SavedPostStore.shared.start()

        CommunityService.shared.observeAllPosts { [weak self] posts in
            self?.posts = posts
            self?.communityView.tableViewPosts.reloadData()
        }
    }
}
