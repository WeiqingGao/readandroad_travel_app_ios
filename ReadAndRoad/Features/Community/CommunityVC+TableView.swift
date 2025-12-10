//
//  CommunityVC+TableView.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    /// Sets tableView delegate + data source.
    func setupTableView() {
        communityView.tableViewPosts.delegate = self
        communityView.tableViewPosts.dataSource = self
    }

    // MARK: - UITableViewDataSource

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

        cell.configure(
            title: post.text,
            author: post.authorName,
            date: formattedDate(post.createdAt),
            postID: post.id,
            isSaved: SavedPostManager.shared.isSaved(post.id)
        )

        cell.onToggleSave = { [weak self] postID, newStatus in
            self?.handleSaveToggle(postID: postID, newStatus: newStatus)
        }

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let post = posts[indexPath.row]
        let vc = PostDetailViewController(post: post)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Helpers

    /// Formats Firestore Timestamp into a readable date string.
    func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
}
