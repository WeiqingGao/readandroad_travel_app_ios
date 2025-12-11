//
//  SavedPostsService.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import FirebaseAuth
import FirebaseFirestore

/// Handles Firestore operations for saving/unsaving posts.
final class SavedPostService {

    static let shared = SavedPostService()
    private init() {}

    private let db = Firestore.firestore()

    /// Save or unsave a specific post for the current user.
    func setSaved(_ saved: Bool, postID: String, completion: ((Error?) -> Void)? = nil) {

        guard let uid = Auth.auth().currentUser?.uid else {
            completion?(nil)
            return
        }

        let ref = db.collection("users").document(uid)
        let op: FieldValue = saved ? .arrayUnion([postID]) : .arrayRemove([postID])

        ref.setData(["savedPosts": op], merge: true) { error in
            completion?(error)
        }
    }
}
