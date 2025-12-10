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
        
        // 启动 SavedPostManager（如果已经登录）
        if Auth.auth().currentUser != nil {
            SavedPostManager.shared.start()
        }

        // 监听收藏变化通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(savedPostsUpdated),
            name: .savedPostsUpdated,
            object: nil
        )

        observePosts()
    }
    
    deinit {
        listener?.remove()
        NotificationCenter.default.removeObserver(self)
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
    
    func showLoginAlert() {
        let alert = UIAlertController(
            title: "Login Required",
            message: "You must sign in to save posts.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sign In", style: .default, handler: { _ in
            let vc = SignInViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }))

        present(alert, animated: true)
    }
    
    @objc func savedPostsUpdated() {
        communityScreen.tableViewPosts.reloadData()
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

        let isSaved = SavedPostManager.shared.isSaved(post.id)

        cell.configure(
            title: post.text,
            author: post.authorName,
            date: dateString,
            postID: post.id,
            isSaved: isSaved
        )
        
        cell.onToggleSave = { [weak self] postID, newStatus in
            guard let self = self else { return }

            if Auth.auth().currentUser == nil {
                self.showLoginAlert()
                return
            }

            SavedPostManager.shared.setSaved(newStatus, for: postID, completion: nil)
        }

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
