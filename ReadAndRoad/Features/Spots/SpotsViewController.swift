//
//  SpotsViewController.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//

import UIKit

struct Spot {
    let name: String
    let imageName: String
}

class SpotsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    let mainView = SpotsView()

    var allSpots: [Spot] = [
        Spot(name: "Central Park", imageName: "test_spot"),
        Spot(name: "Grand Canyon", imageName: "test_spot"),
        Spot(name: "Yellowstone", imageName: "test_spot")
    ]

    var filteredSpots: [Spot] = []

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spots"

        filteredSpots = allSpots

        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(SpotsSpotCell.self, forCellReuseIdentifier: "SpotsSpotCell")

        mainView.searchBar.delegate = self

        // Button actions
        mainView.buttonTypeSolo.addTarget(self, action: #selector(filterSolo), for: .touchUpInside)
        mainView.buttonTypeCouple.addTarget(self, action: #selector(filterCouple), for: .touchUpInside)
        mainView.buttonTypeFamily.addTarget(self, action: #selector(filterFamily), for: .touchUpInside)
        mainView.buttonTypeDog.addTarget(self, action: #selector(filterDog), for: .touchUpInside)
    }

    // MARK: - Button Filters Example
    @objc func filterSolo() {
        filteredSpots = allSpots.filter { $0.name.contains("Park") }
        mainView.tableView.reloadData()
    }
    
    @objc func filterCouple() {
        filteredSpots = allSpots
        mainView.tableView.reloadData()
    }

    @objc func filterFamily() {
        filteredSpots = allSpots
        mainView.tableView.reloadData()
    }

    @objc func filterDog() {
        filteredSpots = allSpots
        mainView.tableView.reloadData()
    }

    // MARK: - Search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredSpots = searchText.isEmpty
            ? allSpots
            : allSpots.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        mainView.tableView.reloadData()
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSpots.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpotsSpotCell", for: indexPath) as! SpotsSpotCell
        let spot = filteredSpots[indexPath.row]
        cell.configure(with: spot)
        return cell
    }
}
