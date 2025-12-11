//
//  CommunityService.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import FirebaseFirestore

/// Handles all Firestore operations related to community posts.
final class CommunityService {

    static let shared = CommunityService()
    private init() {}

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    /// Observes the "Posts" collection in Firestore.
    func observeAllPosts(completion: @escaping ([Post]) -> Void) {
        listener?.remove()

        listener = db.collection("Posts")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapshot, error in

                let posts = snapshot?.documents.compactMap { Post(document: $0) } ?? []
                completion(posts)
            }
    }

    /// Stops listening for Firestore updates.
    func stopListening() {
        listener?.remove()
        listener = nil
    }
}
