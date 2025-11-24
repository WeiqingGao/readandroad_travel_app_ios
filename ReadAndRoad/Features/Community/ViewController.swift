//
//  ViewController.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//

//  ViewController.swift
//  ReadAndRoad

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    let communityScreen = CommunityView()

    // 帖子数据
    var posts: [(id: String, title: String, author: String, date: String, isSaved: Bool)] = [] {
        didSet {
            DispatchQueue.main.async {
                self.communityScreen.tableViewPosts.reloadData()
            }
        }
    }

    override func loadView() {
        view = communityScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        communityScreen.tableViewPosts.dataSource = self
        communityScreen.tableViewPosts.delegate = self

        // 搜索栏设置
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.title = nil
        // 永远使用标准外观，防止导航栏变厚
        if let navBar = navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            
            navBar.standardAppearance = appearance
            navBar.compactAppearance = appearance
            navBar.scrollEdgeAppearance = appearance
        }

        // 使用 searchController
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        loadCommunityPosts()
    }

    func loadCommunityPosts() {
        let mockPosts = [
            (UUID().uuidString, "Best spots in Paris", "Alice", "2025-11-16 09:30", false),
            (UUID().uuidString, "Hidden gems of Kyoto", "Bob", "2025-11-15 17:10", false),
            (UUID().uuidString, "Backpacking through Iceland", "Carol", "2025-11-14 14:02", false),
            (UUID().uuidString, "Solo trip to New Zealand", "David", "2025-11-12 20:45", false)
        ]

        posts = mockPosts.map { (id, t, a, d, s) in
            (id: id, title: t, author: a, date: d, isSaved: s)
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "CommunityPostCell",
            for: indexPath
        ) as? CommunityPostCell else {
            return UITableViewCell()
        }

        let post = posts[indexPath.row]
        cell.configure(title: post.title,
                       author: post.author,
                       date: post.date,
                       postID: post.id,
                       isSaved: post.isSaved)
        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let post = posts[indexPath.row]
        let detailVC = PostDetailViewController()
        // detailVC.postID = post.id
        // detailVC.isSaved = post.isSaved
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
