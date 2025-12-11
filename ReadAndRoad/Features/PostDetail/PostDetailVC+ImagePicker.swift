//
//  PostDetailVC+ImagePicker.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

extension PostDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @objc func onAddImageTapped() {
        guard Auth.auth().currentUser != nil else {
            presentLoginAlert()
            return
        }

        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        picker.dismiss(animated: true)

        if let image = info[.originalImage] as? UIImage {
            pendingCommentImage = image
            // 你可以在 UI 上加一个小图标提示已选图片，这里暂时不做
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func uploadCommentImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }

        let imgID = UUID().uuidString
        let ref = storage.reference().child("comment_photos/\(uid)/\(imgID).jpg")

        guard let data = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }

        ref.putData(data, metadata: nil) { _, error in
            if let error = error {
                print("Upload comment image error:", error)
                completion(nil)
                return
            }

            ref.downloadURL { url, _ in
                completion(url?.absoluteString)
            }
        }
    }
}
