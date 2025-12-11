//
//  ViewController.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//

import UIKit

/// Main controller for the Community feed.
class ViewController: UIViewController {

    let communityView = CommunityView()
    var posts: [Post] = []

    override func loadView() {
        view = communityView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Community"

        setupTableView()
        setupSearchBar()
        setupNotificationObservers()   
        startListening()
    }

    deinit {
        CommunityService.shared.stopListening()
        SavedPostStore.shared.stop()
    }
}
