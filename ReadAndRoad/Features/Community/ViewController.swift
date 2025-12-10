//
//  ViewController.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//


import UIKit
import FirebaseAuth
import FirebaseFirestore

/// Main controller for the Community feed.
/// Displays all public posts and handles navigation + high-level UI setup.
class ViewController: UIViewController {

    let communityView = CommunityView()
    var posts: [Post] = []
    var listener: ListenerRegistration?
    let db = Firestore.firestore()

    override func loadView() {
        view = communityView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Community"
        setupTableView()
        setupSearchBar()
        observePosts()
        setupNotificationObservers()

    }
    
    deinit {
        listener?.remove()
    }
}
