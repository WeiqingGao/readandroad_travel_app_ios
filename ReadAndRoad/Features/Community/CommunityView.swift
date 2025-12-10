//
//  CommunityView.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//

//
//  CommunityView.swift
//  ReadAndRoad
//

import UIKit

/// Main view for the Community screen.
/// Contains a search bar, a welcome label, and a table view of posts.
class CommunityView: UIView {

    // MARK: - UI Components
    var searchBarSection: UISearchBar!
    var labelWelcome: UILabel!
    var tableViewPosts: UITableView!

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground

        setupSearchBar()
        setupLabelWelcome()
        setupTableView()

        initConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    func setupSearchBar() {
        searchBarSection = UISearchBar()
        searchBarSection.placeholder = "Search in Community"
        searchBarSection.translatesAutoresizingMaskIntoConstraints = false
        addSubview(searchBarSection)
    }

    func setupLabelWelcome() {
        labelWelcome = UILabel()
        labelWelcome.text = "Welcome to our Community"
        labelWelcome.font = .systemFont(ofSize: 20, weight: .semibold)
        labelWelcome.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelWelcome)
    }

    func setupTableView() {
        tableViewPosts = UITableView()
        tableViewPosts.translatesAutoresizingMaskIntoConstraints = false
        tableViewPosts.separatorStyle = .singleLine
        tableViewPosts.register(CommunityPostCell.self,
                                forCellReuseIdentifier: "CommunityPostCell")
        addSubview(tableViewPosts)
    }

    // MARK: - Constraints

    func initConstraints() {
        NSLayoutConstraint.activate([

            // Search Bar
            searchBarSection.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 4),
            searchBarSection.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            searchBarSection.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            // Welcome Label
            labelWelcome.topAnchor.constraint(equalTo: searchBarSection.bottomAnchor, constant: 8),
            labelWelcome.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),

            // Table View
            tableViewPosts.topAnchor.constraint(equalTo: labelWelcome.bottomAnchor, constant: 4),
            tableViewPosts.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableViewPosts.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableViewPosts.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
