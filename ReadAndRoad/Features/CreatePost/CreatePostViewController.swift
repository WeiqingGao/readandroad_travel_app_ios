//
//  CreatePostViewController.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//


import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class CreatePostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
                                UICollectionViewDelegate, UICollectionViewDataSource,
                                UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let mainView = CreatePostView()

    var spots: [(name: String, rating: Int)] = []
    var photos: [UIImage] = []

    let db = Firestore.firestore()
    let storage = Storage.storage()

    override func loadView() { view = mainView }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Post"
        view.backgroundColor = .systemBackground

        mainView.spotsTableView.delegate = self
        mainView.spotsTableView.dataSource = self
        mainView.spotsTableView.register(SpotRatingCell.self, forCellReuseIdentifier: "SpotRatingCell")

        mainView.photosCollectionView.delegate = self
        mainView.photosCollectionView.dataSource = self
        mainView.photosCollectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")

        mainView.addSpotButton.addTarget(self, action: #selector(addSpot), for: .touchUpInside)
        mainView.addPhotoButton.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        mainView.submitButton.addTarget(self, action: #selector(submitPost), for: .touchUpInside)
    }

    // MARK: - Add Spot
    @objc func addSpot() {
        guard let text = mainView.spotTextField.text, !text.isEmpty else { return }
        spots.append((name: text, rating: 0))
        mainView.spotTextField.text = ""
        mainView.spotsTableView.reloadData()
    }

    // MARK: - TableView: Spots + Ratings
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { spots.count }

    func tableView(_ tv: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCell(withIdentifier: "SpotRatingCell", for: indexPath) as! SpotRatingCell

        let (name, rating) = spots[indexPath.row]
        cell.nameLabel.text = name
        cell.updateStars(rating)

        cell.onRatingChanged = { [weak self] newRating in
            self?.spots[indexPath.row].rating = newRating
        }

        return cell
    }

    // MARK: - Add Photo
    @objc func addPhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[.originalImage] as? UIImage {
            photos.append(img)
            mainView.photosCollectionView.reloadData()
        }
        dismiss(animated: true)
    }

    // MARK: - Photo Collection
    func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int { photos.count }

    func collectionView(_ cv: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.imageView.image = photos[indexPath.row]
        return cell
    }

    // MARK: - Submit Post
    @objc func submitPost() {
        let text = mainView.contentTextView.text ?? ""

        // 上传图片
        uploadPhotos { [weak self] urls in
            self?.createPost(text: text, photoURLs: urls)
        }
    }

    // MARK: - Firestore: Create Post
    func createPost(text: String, photoURLs: [String]) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let postData: [String: Any] = [
            "authorId": uid,
            "authorName": Auth.auth().currentUser?.displayName ?? "", // 如果有
            "text": text,
            "spots": self.spots.map { ["name": $0.name, "rating": $0.rating] },
            "photoURLs": photoURLs,
            "createdAt": FieldValue.serverTimestamp(),
            "commentsCount": 0
        ]

        db.collection("Posts").addDocument(data: postData) { [weak self] error in
            if let error = error {
                print("Error creating post: \(error)")
                return
            }
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Upload Photos to Firebase Storage
    func uploadPhotos(completion: @escaping ([String]) -> Void) {
        if photos.isEmpty { completion([]); return }

        var urls: [String] = []
        let group = DispatchGroup()

        for img in photos {
            group.enter()

            let id = UUID().uuidString
            let ref = storage.reference().child("post_photos/\(id).jpg")

            if let data = img.jpegData(compressionQuality: 0.8) {
                ref.putData(data) { _, _ in
                    ref.downloadURL { url, _ in
                        if let u = url { urls.append(u.absoluteString) }
                        group.leave()
                    }
                }
            }
        }

        group.notify(queue: .main) {
            completion(urls)
        }
    }
}
