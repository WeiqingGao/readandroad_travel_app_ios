//
//  CreatePostVC+ImagePicker.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import UIKit

extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    /// User taps "Add Photo"
    @objc func onAddPhotoTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info:
                               [UIImagePickerController.InfoKey: Any]) {

        if let img = info[.originalImage] as? UIImage {
            photos.append(img)
            mainView.collectionViewPhotos.reloadData()
        }
        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
