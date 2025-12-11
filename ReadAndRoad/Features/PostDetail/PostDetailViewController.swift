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

class PostDetailViewController: UIViewController {

    // MARK: - UI

    let mainView = PostDetailView()

    // MARK: - Firebase

    let db = Firestore.firestore()
    let storage = Storage.storage()

    // MARK: - Data

    var post: Post
    var comments: [Comment] = []
    var commentsListener: ListenerRegistration?
    var isSavedByCurrentUser: Bool = false

    // Pending image for new comment
    var pendingCommentImage: UIImage?

    // MARK: - Init

    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Post Detail"
        view.backgroundColor = .systemBackground

        setupTableView()
        setupActions()
        setupObservers()

        applyInitialSaveState()
        observeComments()
    }

    deinit {
        commentsListener?.remove()
        NotificationCenter.default.removeObserver(self)
    }
}
