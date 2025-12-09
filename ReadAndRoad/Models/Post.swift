//
//  Post.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//

import Foundation
import FirebaseFirestore

struct Post {
    let id: String
    let authorId: String
    let authorName: String
    let text: String
    let photoURLs: [String]
    let commentsCount: Int
    let createdAt: Date?

    init(document: DocumentSnapshot) {
        id = document.documentID
        let data = document.data() ?? [:]
        authorId = data["authorId"] as? String ?? ""
        authorName = data["authorName"] as? String ?? ""
        text = data["text"] as? String ?? ""
        photoURLs = data["photoURLs"] as? [String] ?? []
        commentsCount = data["commentsCount"] as? Int ?? 0
        if let ts = data["createdAt"] as? Timestamp {
            createdAt = ts.dateValue()
        } else {
            createdAt = nil
        }
    }
}
