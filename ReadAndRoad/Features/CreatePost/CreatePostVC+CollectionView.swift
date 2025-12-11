//
//  CreatePostVC+CollectionView.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import UIKit

extension CreatePostViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ cv: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ cv: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = cv.dequeueReusableCell(withReuseIdentifier: "PhotoCell",
                                          for: indexPath) as! PhotoCell
        cell.imageView.image = photos[indexPath.item]
        return cell
    }

    /// Optional: tap to remove a photo.
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        // Optional: enable deletion by tap
        // photos.remove(at: indexPath.item)
        // mainView.collectionViewPhotos.deleteItems(at: [indexPath])
    }
}

