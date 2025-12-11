//
//  ProfileVC+TableView.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import UIKit

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: - Setup

    func setupTableView() {
        profileView.tableViewPosts.delegate = self
        profileView.tableViewPosts.dataSource = self
    }

    // MARK: - Data Source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if selectedSegmentIndex == 0 {
            return myPosts.count
        } else {
            return savedPosts.count
        }
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "ProfilePostCell",
            for: indexPath
        ) as? CommunityPostCell else {
            return UITableViewCell()
        }

        let post = (selectedSegmentIndex == 0 ? myPosts : savedPosts)[indexPath.row]

        cell.configure(
            title: post.text,
            author: post.authorName,
            date: formattedDate(post.createdAt),
            postID: post.id,
            isSaved: SavedPostStore.shared.isSaved(post.id)
        )

        // Handle save toggle from star button
        cell.onToggleSave = { [weak self] postID, newStatus in
            self?.handleSaveToggle(postID: postID, newStatus: newStatus)
        }

        return cell
    }

    // MARK: - Selection

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let post = (selectedSegmentIndex == 0 ? myPosts : savedPosts)[indexPath.row]

        let vc = PostDetailViewController(post: post)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Pagination Scroll

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        loadMoreIfNeeded(scrollView: scrollView)
    }

    // MARK: - Helper

    func formattedDate(_ date: Date?) -> String {
        guard let date else { return "" }

        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm"
        return f.string(from: date)
    }
}
