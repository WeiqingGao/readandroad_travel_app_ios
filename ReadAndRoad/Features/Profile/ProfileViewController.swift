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

        NotificationCenter.default.addObserver(self,
            selector: #selector(userDidLogin),
            name: .userLoggedIn,
            object: nil)

        NotificationCenter.default.addObserver(self,
            selector: #selector(userDidSignOut),
            name: .userSignedOut,
            object: nil)

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
        } else {
            navigationItem.rightBarButtonItem = nil
            profileScreen.isLoggedIn = false
            profileScreen.posts = []
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
        guard let uid = currentUID else { return }

        savedPostsListener?.remove()

        let userRef = db.collection("users").document(uid)

        savedPostsListener =
            userRef.addSnapshotListener { [weak self] snapshot, error in
                guard let self = self,
                      let data = snapshot?.data(),
                      let saved = data["savedPosts"] as? [String],
                      !saved.isEmpty else {
                          self?.profileScreen.posts = []
                          return
                      }

                self.db.collection("Posts")
                    .whereField(FieldPath.documentID(), in: saved)
                    .order(by: "createdAt", descending: true)
                    .getDocuments { snap, _ in
                        guard let docs = snap?.documents else { return }
                        self.profileScreen.posts = docs.map { Post(document: $0) }
                    }
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

    @objc func userDidLogin() { updateLoginState() }
    @objc func userDidSignOut() { updateLoginState() }

    deinit {
        myPostsListener?.remove()
        savedPostsListener?.remove()
        NotificationCenter.default.removeObserver(self)
    }
}
