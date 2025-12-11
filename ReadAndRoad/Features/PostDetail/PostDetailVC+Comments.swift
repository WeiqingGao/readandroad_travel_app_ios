//
//  PostDetailVC+Comments.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

extension PostDetailViewController {

    func observeComments() {

        commentsListener?.remove()

        commentsListener = db.collection("Posts")
            .document(post.id)
            .collection("comments")
            .order(by: "createdAt", descending: false)
            .addSnapshotListener { [weak self] snapshot, _ in

                guard let docs = snapshot?.documents, let self else { return }
                self.comments = docs.compactMap { Comment(document: $0) }
                self.mainView.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
            }
    }

    func setupActions() {
        mainView.sendButton.addTarget(self,
                                      action: #selector(onSendTapped),
                                      for: .touchUpInside)

        mainView.addImageButton.addTarget(self,
                                          action: #selector(onAddImageTapped),
                                          for: .touchUpInside)
    }

    @objc func onSendTapped() {
        guard let text = mainView.commentTextField.text,
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else { return }

        guard let uid = Auth.auth().currentUser?.uid else {
            presentLoginAlert()
            return
        }

        // If has pending image, upload then send; else send text-only comment
        if let image = pendingCommentImage {
            uploadCommentImage(image) { [weak self] urlString in
                self?.createCommentDocument(uid: uid, text: text, photoURL: urlString)
            }
        } else {
            createCommentDocument(uid: uid, text: text, photoURL: nil)
        }
    }

    private func createCommentDocument(uid: String, text: String, photoURL: String?) {

        fetchCurrentUserName(uid: uid) { [weak self] authorName in
            guard let self else { return }

            let ref = self.db.collection("Posts")
                .document(self.post.id)
                .collection("comments")
                .document()

            let data: [String: Any] = [
                "id": ref.documentID,
                "authorID": uid,
                "authorName": authorName,
                "text": text,
                "photoURL": photoURL as Any,
                "createdAt": FieldValue.serverTimestamp()
            ]

            ref.setData(data) { [weak self] error in
                if let error = error {
                    print("Failed to create comment:", error)
                }
                DispatchQueue.main.async {
                    self?.mainView.commentTextField.text = ""
                    self?.pendingCommentImage = nil
                }
            }
        }
    }

    private func fetchCurrentUserName(uid: String, completion: @escaping (String) -> Void) {
        db.collection("users").document(uid).getDocument { snapshot, _ in
            let name = snapshot?.data()?["name"] as? String ?? "User"
            completion(name)
        }
    }
}
