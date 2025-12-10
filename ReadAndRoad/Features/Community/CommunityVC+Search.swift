//
//  CommunityVC+Search.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import UIKit

extension ViewController: UISearchBarDelegate {

    /// Sets the search bar delegate.
    func setupSearchBar() {
        communityView.searchBarSection.delegate = self
    }

    /// Called whenever the search text changes.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Future implementation:
        // - Local filtering
        // - Firestore query with prefix search
        print("Search text:", searchText)
    }
}
