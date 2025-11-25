//
//  SpotsView.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//

import UIKit

class SpotsView: UIView {

    // MARK: - UI Components

    // Search Bar
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search Spots"
        sb.searchBarStyle = .minimal
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()

    // Buttons
    var buttonTypeSolo: UIButton!
    var buttonTypeCouple: UIButton!
    var buttonTypeFamily: UIButton!
    var buttonTypeDog: UIButton!

    // TableView
    let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorInset = .zero
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupTypeButtons()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Four Buttons
    func setupTypeButtons() {

        let types: [(imageName: String, title: String)] = [
            ("type_solo", "Solo"),
            ("type_couple", "Couple"),
            ("type_family", "Family"),
            ("type_dog", "Pet Friendly")
        ]

        var categoryStacks: [UIStackView] = []

        for (imageName, title) in types {
            let button = UIButton(type: .system)
            button.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal),
                            for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 55).isActive = true
            button.widthAnchor.constraint(equalToConstant: 55).isActive = true

            let label = UILabel()
            label.text = title
            label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            label.textColor = .label
            label.textAlignment = .center

            let vStack = UIStackView(arrangedSubviews: [button, label])
            vStack.axis = .vertical
            vStack.alignment = .center
            vStack.spacing = 6
            vStack.translatesAutoresizingMaskIntoConstraints = false

            switch title {
            case "Solo": buttonTypeSolo = button
            case "Couple": buttonTypeCouple = button
            case "Family": buttonTypeFamily = button
            case "Pet Friendly": buttonTypeDog = button
            default: break
            }

            categoryStacks.append(vStack)
        }

        let hStack = UIStackView(arrangedSubviews: categoryStacks)
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .equalSpacing
        hStack.spacing = 12
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.tag = 100

        addSubview(hStack)
    }

    // MARK: - Layout
    private func setupLayout() {
        addSubview(searchBar)
        addSubview(tableView)

        // 获取 4-button 的 hStack
        guard let hStack = viewWithTag(100) else { return }

        NSLayoutConstraint.activate([
            // Search Bar
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            // HStack Buttons
            hStack.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            // Table View
            tableView.topAnchor.constraint(equalTo: hStack.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
