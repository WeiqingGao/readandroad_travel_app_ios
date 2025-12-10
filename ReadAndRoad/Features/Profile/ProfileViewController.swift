//
//  ProfileViewController.swift
//  ReadAndRoad
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ProfileViewController: UIViewController,
                             UIImagePickerControllerDelegate,
                             UINavigationControllerDelegate {

    let profileScreen = ProfileView()
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var currentUID: String?

    var myPostsListener: ListenerRegistration?
    var savedPostsListener: ListenerRegistration?

    override func loadView() {
        view = profileScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground

        profileScreen.onSignInTapped = { [weak self] in
            let vc = SignInViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }

        profileScreen.onAvatarTapped = { [weak self] in
            self?.presentImagePicker()
        }

        profileScreen.segmentedControl.addTarget(
            self,
            action: #selector(segmentChanged),
            for: .valueChanged
        )

        profileScreen.buttonSave.addTarget(self,
                                           action: #selector(didTapSave),
                                           for: .touchUpInside)

        profileScreen.buttonChangePassword.addTarget(
            self,
            action: #selector(didTapChangePassword),
            for: .touchUpInside
        )
        
        profileScreen.onToggleSave = { [weak self] postID, newStatus in
            guard let self = self else { return }

            if Auth.auth().currentUser == nil {
                self.showLoginAlert()
                return
            }

            SavedPostManager.shared.setSaved(newStatus, for: postID, completion: nil)
        }
        
        profileScreen.onSelectPost = { [weak self] post in
            let detailVC = PostDetailViewController(post: post)
            self?.navigationController?.pushViewController(detailVC, animated: true)
        }

        NotificationCenter.default.addObserver(self,
            selector: #selector(userDidLogin),
            name: .userLoggedIn,
            object: nil)

        NotificationCenter.default.addObserver(self,
            selector: #selector(userDidSignOut),
            name: .userSignedOut,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(savedPostsUpdated),
            name: .savedPostsUpdated,
            object: nil
        )

        updateLoginState()
    }

    // MARK: - LOGIN STATE
    func updateLoginState() {
        if let user = Auth.auth().currentUser {
            currentUID = user.uid
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "Sign Out",
                style: .plain,
                target: self,
                action: #selector(didTapSignOut)
            )
            profileScreen.isLoggedIn = true
            loadUserInfo()
            startListeningMyPosts()
            SavedPostManager.shared.start()
        } else {
            navigationItem.rightBarButtonItem = nil
            profileScreen.isLoggedIn = false
            profileScreen.posts = []
            SavedPostManager.shared.stop()
        }
    }

    // MARK: - USER INFO
    func loadUserInfo() {
        guard let user = Auth.auth().currentUser else { return }
        profileScreen.textFieldNickname.text = user.displayName ?? ""
        profileScreen.labelEmail.text = user.email

        if let url = user.photoURL {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.profileScreen.imageViewAvatar.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }

    // MARK: - FIRESTORE LISTENERS

    /// 实时监听用户发的帖子
    func startListeningMyPosts() {
        guard let uid = currentUID else { return }

        // 先取消旧监听，避免重复
        myPostsListener?.remove()

        myPostsListener =
            db.collection("Posts")
                .whereField("authorId", isEqualTo: uid)
                .order(by: "createdAt", descending: true)
                .addSnapshotListener { [weak self] snapshot, error in
                    guard let self = self,
                          let docs = snapshot?.documents else { return }
                    self.profileScreen.posts = docs.map { Post(document: $0) }
            }
    }

    /// 实时监听 Saved Posts
    func startListeningSavedPosts() {
        loadSavedPostsOnce()
    }
    
    func loadSavedPostsOnce() {
        let ids = Array(SavedPostManager.shared.savedPostIDs)
        if ids.isEmpty {
            profileScreen.posts = []
            return
        }

        db.collection("Posts")
            .whereField(FieldPath.documentID(), in: ids)
            .order(by: "createdAt", descending: true)
            .getDocuments { [weak self] snap, _ in
                guard let docs = snap?.documents else { return }
                self?.profileScreen.posts = docs.map { Post(document: $0) }
            }
    }

    // MARK: - AVATAR UPLOAD
    func presentImagePicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        picker.dismiss(animated: true)

        guard let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage,
              let uid = currentUID else { return }

        profileScreen.imageViewAvatar.image = image

        let ref = storage.reference().child("users/\(uid)/profile.jpg")
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }

        ref.putData(data, metadata: nil) { _, _ in
            ref.downloadURL { url, _ in
                guard let url = url else { return }
                self.updateUserPhotoURL(url)
            }
        }
    }

    func updateUserPhotoURL(_ url: URL) {
        guard let uid = currentUID else { return }

        let change = Auth.auth().currentUser?.createProfileChangeRequest()
        change?.photoURL = url
        change?.commitChanges(completion: nil)

        db.collection("users").document(uid).updateData([
            "photoURL": url.absoluteString
        ])
    }

    // MARK: - ACTIONS
    @objc func segmentChanged() {
        if profileScreen.segmentedControl.selectedSegmentIndex == 0 {
            startListeningMyPosts()
        } else {
            startListeningSavedPosts()
        }
    }

    @objc func didTapSave() {
        guard let uid = currentUID else { return }

        let newName = profileScreen.textFieldNickname.text ?? ""

        let change = Auth.auth().currentUser?.createProfileChangeRequest()
        change?.displayName = newName
        change?.commitChanges { _ in
            self.db.collection("users").document(uid).updateData([
                "name": newName
            ])
        }
    }

    @objc func didTapChangePassword() {
        let vc = ChangePasswordViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func didTapSignOut() {
        do {
            try Auth.auth().signOut()
            NotificationCenter.default.post(name: .userSignedOut, object: nil)
            updateLoginState()
        } catch {
            print("Sign out error:", error.localizedDescription)
        }
    }
    
    @objc func savedPostsUpdated() {
        // 只有在 "Saved Posts" tab 下才刷新
        if profileScreen.segmentedControl.selectedSegmentIndex == 1 {
            loadSavedPostsOnce()
        }
    }

    @objc func userDidLogin() { updateLoginState() }
    @objc func userDidSignOut() { updateLoginState() }
    
    func confirmDelete(post: Post) {
        let alert = UIAlertController(
            title: "Delete Post?",
            message: "This action cannot be undone.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deletePost(post)
        }))

        present(alert, animated: true)
    }
    
    func deletePost(_ post: Post) {
        let postRef = db.collection("Posts").document(post.id)

        // 删除评论子集合
        postRef.collection("comments").getDocuments { snap, _ in
            snap?.documents.forEach { $0.reference.delete() }

            // 删除帖子本体
            postRef.delete()
        }
    }
    
    func showLoginAlert() {
        let alert = UIAlertController(
            title: "Login Required",
            message: "You must sign in to save posts.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sign In", style: .default, handler: { _ in
            let vc = SignInViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        present(alert, animated: true)
    }

    deinit {
        myPostsListener?.remove()
        savedPostsListener?.remove()
        NotificationCenter.default.removeObserver(self)
    }
}

extension ProfileViewController: UITableViewDelegate {

    // 允许滑动删除
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration? {

        let post = profileScreen.posts[indexPath.row]

        // 不是作者 → 不能删除
        guard post.authorId == currentUID else { return nil }

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, done in
            self.confirmDelete(post: post)
            done(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
