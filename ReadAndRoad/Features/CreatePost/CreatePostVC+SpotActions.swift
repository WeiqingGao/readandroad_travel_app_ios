//
//  CreatePostVC+SpotActions.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import UIKit

extension CreatePostViewController {

    /// User taps "Add" to add a new spot name.
    @objc func onAddSpotTapped() {
        guard let text = mainView.textFieldSpot.text?
                .trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty else { return }

        // Append a new spot with rating = 0
        spots.append((name: text, rating: 0))

        mainView.textFieldSpot.text = ""
        mainView.tableViewSpots.reloadData()
    }
}
