//
//  SavedPostStore.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import FirebaseAuth
import FirebaseFirestore

/// Holds the local cache of saved post IDs and listens for Firestore updates.
final class SavedPostStore {

    static let shared = SavedPostStore()
    private init() {}

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    private(set) var savedPostIDs: Set<String> = []
    private(set) var currentUserID: String?

    /// Begin listening for saved posts of current user.
    func start() {
        guard let uid = Auth.auth().currentUser?.uid else {
            stop()
            return
        }

        if uid == currentUserID, listener != nil { return }

        stop()
        currentUserID = uid

        listener = db.collection("users").document(uid)
            .addSnapshotListener { [weak self] snapshot, _ in

                guard let self = self else { return }

                let arr = snapshot?.data()?["savedPosts"] as? [String] ?? []
                let newSet = Set(arr)

                if newSet != self.savedPostIDs {
                    self.savedPostIDs = newSet
                    NotificationCenter.default.post(name: .savedPostsUpdated, object: nil)
                }
            }
    }

    /// Stop listening and clear cached data.
    func stop() {
        listener?.remove()
        listener = nil
        savedPostIDs = []
        currentUserID = nil
    }

    /// Check if a postID is saved.
    func isSaved(_ id: String) -> Bool {
        return savedPostIDs.contains(id)
    }
}
