//
//  CreatePostService.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

/// Handles creating posts, uploading images, and writing Firestore documents.
final class CreatePostService {

    static let shared = CreatePostService()

    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    private init() {}

    // MARK: - Public API

    /// Create a new post:
    /// - Upload all photos
    /// - Build post payload
    /// - Write to Firestore
    func createPost(
        text: String,
        spots: [(name: String, rating: Int)],
        photos: [UIImage],
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "Auth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not logged in."])))
            return
        }

        // Fetch nickname from Firestore (it is the authoritative source)
        db.collection("users").document(user.uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            let authorName = snapshot?.data()?["name"] as? String ?? (user.displayName ?? "User")

            self.uploadPhotos(photos) { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let photoURLs):
                    self.writePostDocument(
                        authorId: user.uid,
                        authorName: authorName,
                        text: text,
                        spots: spots,
                        photoURLs: photoURLs,
                        completion: completion
                    )
                }
            }
        }
    }

    // MARK: - Firestore: Write post document

    private func writePostDocument(
        authorId: String,
        authorName: String,
        text: String,
        spots: [(name: String, rating: Int)],
        photoURLs: [String],
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let postData: [String: Any] = [
            "authorId": authorId,
            "authorName": authorName,
            "text": text,
            "spots": spots.map { ["name": $0.name, "rating": $0.rating] },
            "photoURLs": photoURLs,
            "createdAt": FieldValue.serverTimestamp(),
            "commentsCount": 0
        ]

        db.collection("Posts").addDocument(data: postData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                NotificationCenter.default.post(name: .postCreated, object: nil)
                completion(.success(()))
            }
        }
    }

    // MARK: - Upload photos to Firebase Storage

    private func uploadPhotos(_ images: [UIImage],
                              completion: @escaping (Result<[String], Error>) -> Void)
    {
        if images.isEmpty {
            completion(.success([]))
            return
        }

        var urls: [String] = []
        let group = DispatchGroup()

        for img in images {
            group.enter()

            let id = UUID().uuidString
            let ref = storage.reference().child("post_photos/\(id).jpg")

            guard let data = img.jpegData(compressionQuality: 0.85) else {
                group.leave()
                continue
            }

            ref.putData(data, metadata: nil) { _, error in
                if let error = error {
                    group.leave()
                    return
                }

                ref.downloadURL { url, error in
                    if let url = url {
                        urls.append(url.absoluteString)
                    }
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) {
            completion(.success(urls))
        }
    }
}
