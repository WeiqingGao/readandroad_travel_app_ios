//
//  CommunityVC+NotificationHandlers.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import UIKit

extension ViewController {

    /// Adds observers for saved-related notifications.
    func setupNotificationObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onSavedPostsUpdated),
            name: .savedPostsUpdated,
            object: nil
        )
    }

    /// Called when save/unsave a post.
    @objc func onSavedPostsUpdated() {
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
