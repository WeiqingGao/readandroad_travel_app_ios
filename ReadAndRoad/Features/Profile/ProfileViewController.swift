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
    let notificationCenter = NotificationCenter.default

    override func loadView() {
        view = profileScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        profileScreen.onSignInTapped = { [weak self] in
            self?.goToSignIn()
        }
        profileScreen.onAvatarTapped = { [weak self] in
            self?.presentImagePicker()
        }

        notificationCenter.addObserver(
            self,
            selector: #selector(onUserLoggedIn(_:)),
            name: .userLoggedIn,
            object: nil
        )

        refreshUIByAuth()
    }

    
    func refreshUIByAuth() {
        if let user = Auth.auth().currentUser {
            // 已登录
            profileScreen.isLoggedIn = true
            currentUID = user.uid
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "Sign Out",
                style: .plain,
                target: self,
                action: #selector(didTapSignOut)
            )

            loadUserInfo()
            loadUserPosts()

        } else {
            // 未登录
            profileScreen.isLoggedIn = false
            currentUID = nil

            navigationItem.rightBarButtonItem = nil
        }
    }


    // MARK: - 登录跳转
    func goToSignIn() {
        let vc = SignInViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - 用户信息
    func loadUserInfo() {
        guard let user = Auth.auth().currentUser else { return }
        currentUID = user.uid
        profileScreen.textFieldNickname.text = user.displayName ?? "No nickname"
        profileScreen.labelEmail.text = user.email
        
        // 加载头像（如果用户有 photoURL）
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

    // MARK: - 打开相册
    func presentImagePicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }

    // MARK: - 选择图片后上传
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage,
              let uid = currentUID else { return }

        // 显示新头像（立即刷新）
        profileScreen.imageViewAvatar.image = image

        // 压缩并上传
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        let ref = storage.reference().child("users/\(uid)/profile.jpg")

        ref.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Upload error: \(error.localizedDescription)")
                return
            }
            ref.downloadURL { url, _ in
                guard let url = url else { return }
                self.updateUserPhotoURL(url)
            }
        }
    }

    func updateUserPhotoURL(_ url: URL) {
        guard let uid = currentUID else { return }

        // 更新 Firebase Auth 用户资料
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.photoURL = url
        changeRequest?.commitChanges { error in
            if let error = error {
                print("Error updating photoURL:", error)
            }
        }

        // 更新 Firestore 用户文档
        db.collection("users").document(uid).updateData([
            "photoURL": url.absoluteString
        ])

        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Avatar Updated",
                                          message: "Your new profile photo has been uploaded successfully.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }

    // MARK: - Load Posts
    func loadUserPosts() {
        guard let uid = currentUID else { return }
        db.collection("posts").whereField("authorID", isEqualTo: uid).getDocuments { snapshot, error in
            guard let docs = snapshot?.documents else { return }
            self.profileScreen.posts = docs.map {
                let data = $0.data()
                return (
                    id: $0.documentID,
                    title: data["title"] as? String ?? "",
                    author: data["authorName"] as? String ?? "",
                    date: "1d ago",
                    isSaved: false
                )
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
                    return (
                        id: $0.documentID,
                        title: d["title"] as? String ?? "",
                        author: d["authorName"] as? String ?? "",
                        date: "1d ago",
                        isSaved: true
                    )
                }
            }
        }
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
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = newName
        changeRequest?.commitChanges(completion: { error in
            if let error = error {
                print("Error updating nickname:", error)
            } else {
                self.db.collection("users").document(uid).updateData(["name": newName])
                let alert = UIAlertController(title: "Saved", message: "Nickname updated successfully.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        })
    }

    @objc func didTapChangePassword() {
        let vc = ChangePasswordViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func didTapSignOut() {
        do {
            try Auth.auth().signOut()
            refreshUIByAuth()
        } catch {
            print("Sign out error:", error)
        }
    }
    
    @objc func onUserLoggedIn(_ notification: Notification) {
        refreshUIByAuth()
    }

}
