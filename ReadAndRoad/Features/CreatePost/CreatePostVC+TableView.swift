//
//  CreatePostVC+TableView.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import UIKit

extension CreatePostViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: - Sections
    // We use 1 section for both tables.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // MARK: - Rows count
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {

        // Autocomplete table
        if tableView == mainView.tableViewAutocomplete {
            return autocompleteResults.count
        }

        // Spots table (rating list)
        return spots.count
    }

    // MARK: - Cell for row
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // -------------------------------
        // AUTOCOMPLETE TABLE
        // -------------------------------
        if tableView == mainView.tableViewAutocomplete {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "AutocompleteCell")
            cell.textLabel?.text = autocompleteResults[indexPath.row]
            cell.textLabel?.font = .systemFont(ofSize: 15)
            return cell
        }

        // -------------------------------
        // SPOT RATING TABLE
        // -------------------------------
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "SpotRatingCell",
            for: indexPath
        ) as! SpotRatingCell

        let (spotName, rating) = spots[indexPath.row]

        cell.nameLabel.text = spotName
        cell.updateStars(rating)

        // When user taps a star → update local rating
        cell.onRatingChanged = { [weak self] newRating in
            self?.spots[indexPath.row].rating = newRating
        }

        return cell
    }

    // MARK: - Row selection
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        // -------------------------------
        // AUTOCOMPLETE SELECTED
        // -------------------------------
        if tableView == mainView.tableViewAutocomplete {
            let selectedSpot = autocompleteResults[indexPath.row]

            // Fill into textFieldSpot
            mainView.textFieldSpot.text = selectedSpot

            // Hide autocomplete table
            mainView.tableViewAutocomplete.isHidden = true

            return
        }

        // -------------------------------
        // SPOT RATING TABLE SELECTED
        // (Normally: nothing happens)
        // -------------------------------
    }

    // MARK: - Swipe to delete (for spot list)
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {

        if tableView == mainView.tableViewSpots,
           editingStyle == .delete {

            spots.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
