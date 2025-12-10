//
//  CommunityVC+Firestore.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import FirebaseFirestore

extension ViewController {

    /// Starts Firestore listener to observe all posts in descending order.
    func observePosts() {
        listener?.remove()

        listener = db.collection("Posts")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in

                guard let docs = snapshot?.documents else { return }

                self?.posts = docs.compactMap { Post(document: $0) }
                self?.communityView.tableViewPosts.reloadData()
            }
    }
}
