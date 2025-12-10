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
import FirebaseFirestore

class ViewController: UIViewController {

    let communityScreen = CommunityView()
    let db = Firestore.firestore()
    var posts: [Post] = []
    
    var listener: ListenerRegistration?

    override func loadView() {
        view = communityScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableview
        communityScreen.tableViewPosts.dataSource = self
        communityScreen.tableViewPosts.delegate = self

        // 搜索栏（只设 placeholder，具体搜索逻辑后面加）
        communityScreen.searchBarSection.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false

        navigationItem.title = nil
        
        if let navBar = navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            
            navBar.standardAppearance = appearance
            navBar.compactAppearance = appearance
            navBar.scrollEdgeAppearance = appearance
        }

        observePosts()
    }
    
    deinit {
        listener?.remove()
    }

    // MARK: - Firestore
    func observePosts() {
        listener = db.collection("Posts")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self, let docs = snapshot?.documents else { return }

                self.posts = docs.map { Post(document: $0) }

                DispatchQueue.main.async {
                    self.communityScreen.tableViewPosts.reloadData()
                }
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

        // 格式化时间
        let dateString: String
        if let date = post.createdAt {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            dateString = formatter.string(from: date)
        } else {
            dateString = ""
        }

        // 先用 post.text 作为 title，post.authorName 作为 author，
        // isSaved 先写死为 false（后面做收藏功能的时候再改）
        cell.configure(
            title: post.text,
            author: post.authorName,
            date: dateString,
            postID: post.id,
            isSaved: false
        )

        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let post = posts[indexPath.row]
        let detailVC = PostDetailViewController(post: post)
        // detailVC.post = post   // 定义好 PostDetail 再传递
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate (预留)
extension ViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 这里实现搜索逻辑（在内存中过滤 posts，或者改成 query Firestore）。先留空。
    }
}
