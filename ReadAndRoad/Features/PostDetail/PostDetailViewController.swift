//
//  PostDetailViewController.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class PostDetailViewController: UIViewController,
                                UITableViewDelegate, UITableViewDataSource,
                                UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let mainView = PostDetailView()
    let db = Firestore.firestore()
    let storage = Storage.storage()

    var post: Post                       // 由外部传入
    var comments: [Comment] = []         // 你需要创建 Comment.swift
    var listener: ListenerRegistration?
    var isSavedByCurrentUser = false

    init(post: Post) {
        self.post = post
        self.isSavedByCurrentUser = SavedPostManager.shared.isSaved(post.id)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Post"

        if Auth.auth().currentUser != nil {
            SavedPostManager.shared.start()
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(savedPostsUpdated),
            name: .savedPostsUpdated,
            object: nil
        )
        
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.tableView.register(PostDetailHeaderCell.self, forCellReuseIdentifier: "PostHeader")
        mainView.tableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")

        // 评论逻辑
        mainView.sendButton.addTarget(self, action: #selector(sendComment), for: .touchUpInside)
        mainView.addImageButton.addTarget(self, action: #selector(addCommentImage), for: .touchUpInside)

        observeComments()
        checkIfSaved()
    }

    // MARK: - Firestore 监听评论
    func observeComments() {
        listener = db.collection("Posts")
            .document(post.id)
            .collection("comments")
            .order(by: "createdAt", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let docs = snapshot?.documents else { return }
                self?.comments = docs.compactMap { Comment(document: $0) }
                self?.mainView.tableView.reloadData()
            }
    }

    // MARK: - 收藏状态检查
    func checkIfSaved() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(uid)
            .addSnapshotListener { [weak self] snapshot, _ in
                guard let self = self else { return }
                let saved = snapshot?.data()?["savedPosts"] as? [String] ?? []
                self.isSavedByCurrentUser = saved.contains(self.post.id)
                self.mainView.tableView.reloadData()
            }
    }

    // MARK: - 收藏按钮逻辑
    func toggleSave() {
        guard Auth.auth().currentUser != nil else {
            showLoginAlert()
            return
        }

        let target = !isSavedByCurrentUser
        SavedPostManager.shared.setSaved(target, for: post.id) { [weak self] _ in
            // 乐观更新（其实监听器也会更新它）
            self?.isSavedByCurrentUser = target
            self?.mainView.tableView.reloadSections(IndexSet(integer: 0), with: .none)
        }
    }

    func showLoginAlert() {
        let alert = UIAlertController(title: "Login Required",
                                      message: "You need to login to save posts.",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sign In", style: .default, handler: { _ in
            let vc = SignInViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }))

        present(alert, animated: true)
    }

    // MARK: - 发送评论
    @objc func sendComment() {
        guard let text = mainView.commentTextField.text, !text.isEmpty else { return }
        guard let uid = Auth.auth().currentUser?.uid else {
            showLoginAlert()
            return
        }

        let authorName = Auth.auth().currentUser?.displayName ?? "User"

        let ref = db.collection("Posts")
            .document(post.id)
            .collection("comments")
            .document()

        let data: [String: Any] = [
            "authorId": uid,
            "authorName": authorName,
            "text": text,
            "createdAt": FieldValue.serverTimestamp()
        ]

        ref.setData(data)

        // 清空
        mainView.commentTextField.text = ""
        mainView.endEditing(true)
    }
    
    @objc func savedPostsUpdated() {
        let newValue = SavedPostManager.shared.isSaved(post.id)
        if newValue != isSavedByCurrentUser {
            isSavedByCurrentUser = newValue
            // 刷新 Section 0（header cell）
            mainView.tableView.reloadSections(IndexSet(integer: 0), with: .none)
        }
    }

    // MARK: - 评论附图
    @objc func addCommentImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

    // 上传评论附图
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        picker.dismiss(animated: true)

        guard let image = info[.originalImage] as? UIImage,
              let uid = Auth.auth().currentUser?.uid else {
            showLoginAlert()
            return
        }

        let imgID = UUID().uuidString
        let ref = storage.reference().child("comment_photos/\(imgID).jpg")

        guard let data = image.jpegData(compressionQuality: 0.8) else { return }

        ref.putData(data) { _, _ in
            ref.downloadURL { url, _ in
                self.uploadCommentWithImage(url: url)
            }
        }
    }

    func uploadCommentWithImage(url: URL?) {
        guard let url = url,
              let uid = Auth.auth().currentUser?.uid else { return }

        let authorName = Auth.auth().currentUser?.displayName ?? "User"

        let ref = db.collection("Posts")
            .document(post.id)
            .collection("comments")
            .document()

        let data: [String: Any] = [
            "authorId": uid,
            "authorName": authorName,
            "text": "",
            "photoURL": url.absoluteString,
            "createdAt": FieldValue.serverTimestamp()
        ]

        ref.setData(data)
    }

    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int { 2 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : comments.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostHeader", for: indexPath) as! PostDetailHeaderCell
            cell.configure(post: post, isSaved: isSavedByCurrentUser)
            cell.onSaveTapped = { [weak self] in self?.toggleSave() }
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        cell.configure(comment: comments[indexPath.row])
        return cell
    }
}
