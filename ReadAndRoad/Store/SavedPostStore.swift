//
//  SavedPostStore.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import FirebaseAuth
import FirebaseFirestore

/// Holds the local cache of saved post Ids and listens for Firestore updates.
final class SavedPostStore {

    static let shared = SavedPostStore()

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    private(set) var savedPostIds: [String] = []
    private(set) var currentUserId: String?
    
    private init() {}

    /// Begin listening for saved posts of current user.
    func start() {
        guard let uid = Auth.auth().currentUser?.uid else {
            stop()
            return
        }

        if uid == currentUserId, listener != nil { return }

        stop()
        currentUserId = uid

        listener = db.collection("users").document(uid)
            .addSnapshotListener { [weak self] snapshot, _ in
                guard let self = self else { return }

                let newArr = snapshot?.data()?["savedPosts"] as? [String] ?? []
                let changed = (newArr != self.savedPostIds)

                self.savedPostIds = newArr

                if changed {
                    NotificationCenter.default.post(name: .savedPostsUpdated, object: nil)
                }
            }
    }

    /// Stop listening and clear cached data.
    func stop() {
        listener?.remove()
        listener = nil
        savedPostIds = []
        currentUserId = nil
    }

    /// Check if a postId is saved.
    func isSaved(_ id: String) -> Bool {
        return savedPostIds.contains(id)
    }
}
