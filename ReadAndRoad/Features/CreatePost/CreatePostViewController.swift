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

/// Main controller for creating a post.
///
/// Logic is split into several extensions:
/// - Setup UI components
/// - Spot actions (add / rate)
/// - TableView: spot rating list
/// - CollectionView: photo preview
/// - Image picker
/// - Submit request (PostService + SpotService)
class CreatePostViewController: UIViewController {

    // MARK: - UI
    let mainView = CreatePostView()

    // MARK: - Data
    /// (spotName, rating)
    var spots: [(name: String, rating: Int)] = []
    /// Selected images for the post
    var photos: [UIImage] = []

    // MARK: - Firebase
    let db = Firestore.firestore()
    let storage = Storage.storage()

    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Post"
        view.backgroundColor = .systemBackground

        setupUIComponents()
        setupTargets()
    }
}
