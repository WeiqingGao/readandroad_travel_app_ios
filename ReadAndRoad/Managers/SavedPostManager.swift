//
//  SavedPostManager.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

extension Notification.Name {
    static let savedPostsUpdated = Notification.Name("SavedPostsUpdated")
}

class SavedPostManager {

    static let shared = SavedPostManager()
    private init() {}

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    private(set) var savedPostIDs: Set<String> = []
    private(set) var currentUserId: String?

    // 开始监听当前用户的 savedPosts（如果已经在监听同一个人就不会重复）
    func start() {
        guard let uid = Auth.auth().currentUser?.uid else {
            stop()
            return
        }

        if uid == currentUserId, listener != nil {
            return
        }

        stop()
        currentUserId = uid

        listener = db.collection("users").document(uid)
            .addSnapshotListener { [weak self] snap, _ in
                guard let self = self else { return }
                let array = (snap?.data()?["savedPosts"] as? [String]) ?? []
                let newSet = Set(array)

                if newSet != self.savedPostIDs {
                    self.savedPostIDs = newSet
                    NotificationCenter.default.post(name: .savedPostsUpdated, object: nil)
                }
            }
    }

    func stop() {
        listener?.remove()
        listener = nil
        currentUserId = nil
        savedPostIDs = []
    }

    func isSaved(_ postID: String) -> Bool {
        return savedPostIDs.contains(postID)
    }

    func setSaved(_ saved: Bool, for postID: String, completion: ((Error?) -> Void)? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion?(nil)
            return
        }

        let ref = db.collection("users").document(uid)
        let op: FieldValue = saved ? FieldValue.arrayUnion([postID]) : FieldValue.arrayRemove([postID])

        ref.setData(["savedPosts": op], merge: true) { error in
            completion?(error)
        }
    }

    func toggle(postID: String, completion: ((Error?) -> Void)? = nil) {
        let target = !isSaved(postID)
        setSaved(target, for: postID, completion: completion)
    }
}
