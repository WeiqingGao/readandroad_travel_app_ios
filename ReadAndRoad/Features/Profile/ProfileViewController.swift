//
//  ProfileViewController.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let profileScreen = ProfileView()
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var currentUID: String?
    
    override func loadView() {
        view = profileScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground
        
        profileScreen.onSignInTapped = { [weak self] in
            let signInVC = SignInViewController()
            self?.navigationController?.pushViewController(signInVC, animated: true)
        }
        profileScreen.onAvatarTapped = { [weak self] in
            self?.presentImagePicker()
        }

        profileScreen.segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        profileScreen.buttonSave.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        profileScreen.buttonChangePassword.addTarget(self, action: #selector(didTapChangePassword), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogin), name: .userLoggedIn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userDidSignOut), name: .userSignedOut, object: nil)
        
        updateLoginState()
    }

    func updateLoginState() {
        if let user = Auth.auth().currentUser {
            currentUID = user.uid
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(didTapSignOut))
            profileScreen.isLoggedIn = true
            loadUserInfo()
            loadUserPosts()
        } else {
            navigationItem.rightBarButtonItem = nil
            profileScreen.isLoggedIn = false
        }
    }

    // MARK: - User Info
    func loadUserInfo() {
        guard let user = Auth.auth().currentUser else { return }
        profileScreen.textFieldNickname.text = user.displayName ?? "No nickname"
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

    // MARK: - Posts
    func loadUserPosts() {
        guard let uid = currentUID else { return }
        db.collection("posts").whereField("authorID", isEqualTo: uid).getDocuments { snapshot, _ in
            guard let docs = snapshot?.documents else { return }
            self.profileScreen.posts = docs.map {
                let d = $0.data()
                return (id: $0.documentID,
                        title: d["title"] as? String ?? "",
                        author: d["authorName"] as? String ?? "",
                        date: "1d ago",
                        isSaved: false)
            }
        }
    }

    func loadSavedPosts() {
        guard let uid = currentUID else { return }
        db.collection("users").document(uid).getDocument { doc, _ in
            guard let data = doc?.data(),
                  let saved = data["savedPosts"] as? [String],
                  !saved.isEmpty else { return }
            self.db.collection("posts").whereField(FieldPath.documentID(), in: saved).getDocuments { snapshot, _ in
                guard let docs = snapshot?.documents else { return }
                self.profileScreen.posts = docs.map {
                    let d = $0.data()
                    return (id: $0.documentID,
                            title: d["title"] as? String ?? "",
                            author: d["authorName"] as? String ?? "",
                            date: "1d ago",
                            isSaved: true)
                }
            }
        }
    }

    // MARK: - Avatar Upload
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
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        let ref = storage.reference().child("users/\(uid)/profile.jpg")
        ref.putData(data, metadata: nil) { _, error in
            if let error = error { print("Upload error:", error.localizedDescription); return }
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
        db.collection("users").document(uid).updateData(["photoURL": url.absoluteString])
    }

    // MARK: - Actions
    @objc func segmentChanged() {
        if profileScreen.segmentedControl.selectedSegmentIndex == 0 {
            loadUserPosts()
        } else {
            loadSavedPosts()
        }
    }

    @objc func didTapSave() {
        guard let uid = currentUID else { return }
        let newName = profileScreen.textFieldNickname.text ?? ""
        let change = Auth.auth().currentUser?.createProfileChangeRequest()
        change?.displayName = newName
        change?.commitChanges { error in
            if error == nil {
                self.db.collection("users").document(uid).updateData(["name": newName])
            }
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

    // MARK: - 通知响应
    @objc func userDidLogin() { updateLoginState() }
    @objc func userDidSignOut() { updateLoginState() }

    deinit { NotificationCenter.default.removeObserver(self) }
}
