//
//  ProfileViewController.swift
//  ReadAndRoad
//


import UIKit
import FirebaseAuth

/// Controller for the Profile screen.
/// Displays user info, My Posts, and Saved Posts.
class ProfileViewController: UIViewController {

    // MARK: - UI
    let profileView = ProfileView()

    // MARK: - Data
    var myPosts: [Post] = []
    var savedPosts: [Post] = []
    var selectedSegmentIndex: Int = 0   // 0 = My Posts, 1 = Saved Posts

    override func loadView() {
        view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupTargets()
        setupObservers()
        updateLoginStateUI()

        SavedPostStore.shared.start()   // NEW
        loadMyPosts()
        loadSavedPosts()
        loadUserInfo()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        SavedPostStore.shared.stop()
    }
}
