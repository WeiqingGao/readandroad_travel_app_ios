//
//  CreatePostVC+TableView.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import UIKit

extension CreatePostViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return spots.count
    }

    func tableView(_ tv: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tv.dequeueReusableCell(withIdentifier: "SpotRatingCell",
                                          for: indexPath) as! SpotRatingCell
        
        let (name, rating) = spots[indexPath.row]
        cell.nameLabel.text = name
        cell.updateStars(rating)

        cell.onRatingChanged = { [weak self] newRating in
            self?.spots[indexPath.row].rating = newRating
        }

        return cell
    }

    /// Allow deletion of a spot row by swipe.
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            spots.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
