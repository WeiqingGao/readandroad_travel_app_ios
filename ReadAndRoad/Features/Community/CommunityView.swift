//
//  CommunityView.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//

import UIKit

class CommunityView: UIView {
    // MARK: - UI elements
    var searchBarSection: UISearchBar!
    var labelHotPosts: UILabel!
    var tableViewPosts: UITableView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupViews() {

        searchBarSection = UISearchBar()
        searchBarSection.placeholder = "Search in Community"
        searchBarSection.translatesAutoresizingMaskIntoConstraints = false
        addSubview(searchBarSection)

        labelHotPosts = UILabel()
        labelHotPosts.text = "Welcome to our Community"
        labelHotPosts.font = .systemFont(ofSize: 20, weight: .semibold)
        labelHotPosts.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelHotPosts)

        tableViewPosts = UITableView()
        tableViewPosts.translatesAutoresizingMaskIntoConstraints = false
        tableViewPosts.register(CommunityPostCell.self, forCellReuseIdentifier: "CommunityPostCell")
        addSubview(tableViewPosts)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBarSection.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 4),
            searchBarSection.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            searchBarSection.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            labelHotPosts.topAnchor.constraint(equalTo: searchBarSection.bottomAnchor, constant: 8),
            labelHotPosts.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),

            tableViewPosts.topAnchor.constraint(equalTo: labelHotPosts.bottomAnchor, constant: 4),
            tableViewPosts.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableViewPosts.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableViewPosts.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor) 
        ])
    }
}
