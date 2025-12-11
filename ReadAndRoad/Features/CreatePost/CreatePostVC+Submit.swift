//
//  CreatePostVC+Submit.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import UIKit
import FirebaseAuth

extension CreatePostViewController {

    /// User taps "Publish"
    @objc func onSubmitTapped() {
        guard let user = Auth.auth().currentUser else {
            AlertHelper.showError(self, message: "Please sign in to publish a post.")
            return
        }

        let text = mainView.textViewContent.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if text.isEmpty && photos.isEmpty && spots.isEmpty {
            AlertHelper.showError(self, message: "Post content cannot be empty.")
            return
        }

        mainView.buttonSubmit.isEnabled = false

        // Ensure all Spots exist in Firestore
        SpotService.shared.ensureSpotsExist(spots)

        // Use CreatePostService to handle uploads + Firestore writes
        CreatePostService.shared.createPost(
            text: text,
            spots: spots,
            photos: photos
        ) { [weak self] result in

            guard let self else { return }
            self.mainView.buttonSubmit.isEnabled = true

            switch result {
            case .success:
                self.resetForm()
                
                let alert = UIAlertController(
                    title: "Success",
                    message: "Your post has been published!",
                    preferredStyle: .alert
                )

                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.navigationController?.popToRootViewController(animated: true)
                }))

                self.present(alert, animated: true)


            case .failure(let error):
                AlertHelper.showError(self, message: "Failed: \(error.localizedDescription)")
            }
        }
    }
    
    func resetForm() {
        mainView.textViewContent.text = ""
        mainView.textFieldSpot.text = ""
        spots.removeAll()
        photos.removeAll()

        mainView.tableViewSpots.reloadData()
        mainView.collectionViewPhotos.reloadData()
    }

}
