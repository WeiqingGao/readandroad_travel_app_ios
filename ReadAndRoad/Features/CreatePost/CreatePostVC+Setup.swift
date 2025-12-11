//
//  CreatePostVC+Setup.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import UIKit

extension CreatePostViewController {

    /// Initialize tableView + collectionView and register cells.
    func setupUIComponents() {
        // TableView for spots
        mainView.tableViewSpots.delegate = self
        mainView.tableViewSpots.dataSource = self
        mainView.tableViewSpots.register(SpotRatingCell.self,
                                         forCellReuseIdentifier: "SpotRatingCell")

        // CollectionView for photos
        mainView.collectionViewPhotos.delegate = self
        mainView.collectionViewPhotos.dataSource = self
        mainView.collectionViewPhotos.register(PhotoCell.self,
                                               forCellWithReuseIdentifier: "PhotoCell")
    }

    /// Assign button targets.
    func setupTargets() {
        mainView.buttonAddSpot.addTarget(self,
                                         action: #selector(onAddSpotTapped),
                                         for: .touchUpInside)

        mainView.buttonAddPhoto.addTarget(self,
                                          action: #selector(onAddPhotoTapped),
                                          for: .touchUpInside)

        mainView.buttonSubmit.addTarget(self,
                                        action: #selector(onSubmitTapped),
                                        for: .touchUpInside)
        mainView.textFieldSpot.addTarget(self,
                                         action: #selector(onSpotTextChanged),
                                         for: .editingChanged)
    }
    
    @objc func onSpotTextChanged() {
        guard let text = mainView.textFieldSpot.text,
              !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            autocompleteResults = []
            mainView.tableViewAutocomplete.isHidden = true
            mainView.tableViewAutocomplete.reloadData()
            return
        }

        SpotService.shared.searchSpots(prefix: text) { [weak self] names in
            guard let self = self else { return }

            self.autocompleteResults = names
            self.mainView.tableViewAutocomplete.isHidden = names.isEmpty
            self.mainView.tableViewAutocomplete.reloadData()
        }
    }

}

