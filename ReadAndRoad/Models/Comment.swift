//
//  Comment.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/9/25.
//

import Foundation
import FirebaseFirestore

struct Comment {
    let id: String
    let authorId: String
    let authorName: String
    let text: String
    let photoURL: String?
    let createdAt: Date?

    init?(document: DocumentSnapshot) {
        let data = document.data() ?? [:]

        id = document.documentID
        authorId = data["authorId"] as? String ?? ""
        authorName = data["authorName"] as? String ?? ""
        text = data["text"] as? String ?? ""
        photoURL = data["photoURL"] as? String

        if let ts = data["createdAt"] as? Timestamp {
            createdAt = ts.dateValue()
        } else {
            createdAt = nil
        }
    }
}
