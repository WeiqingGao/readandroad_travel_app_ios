//
//  UIImageView+Remote.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import UIKit

extension UIImageView {

    /// Simple async image loading from a URL string.
    func setRemoteImage(_ urlString: String?) {
        image = nil

        guard
            let urlString,
            let url = URL(string: urlString)
        else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self, let data, let img = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.image = img
            }
        }.resume()
    }
}
