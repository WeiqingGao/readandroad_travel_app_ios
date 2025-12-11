//
//  PostDetailVC+TableView.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import UIKit

extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func setupTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self

        mainView.tableView.register(PostDetailHeaderCell.self,
                                    forCellReuseIdentifier: "PostHeader")
        mainView.tableView.register(CommentCell.self,
                                    forCellReuseIdentifier: "CommentCell")

        mainView.tableView.estimatedRowHeight = 100
        mainView.tableView.rowHeight = UITableView.automaticDimension
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2    // 0: header, 1: comments
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : comments.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "PostHeader",
                for: indexPath
            ) as! PostDetailHeaderCell

            cell.configure(post: post, isSaved: isSavedByCurrentUser)
            cell.onSaveTapped = { [weak self] in
                self?.toggleSave()
            }

            return cell
        }

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "CommentCell",
            for: indexPath
        ) as! CommentCell

        cell.configure(comment: comments[indexPath.row])
        return cell
    }
}
