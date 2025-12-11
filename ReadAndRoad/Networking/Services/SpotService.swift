//
//  SpotService.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import FirebaseFirestore

/// Handles creation & lookup of Spots.
/// Makes sure each spot is stored globally under /Spots collection.
final class SpotService {

    static let shared = SpotService()
    private let db = Firestore.firestore()

    private init() {}

    /// Ensure a spot exists in DB (id = slugified name).
    /// Ratings from posts can later be aggregated (avg rating).
    func ensureSpotExists(name: String, rating: Int) {
        let id = name.lowercased().trimmingCharacters(in: .whitespaces)

        let ref = db.collection("Spots").document(id)

        ref.getDocument { snapshot, _ in
            if snapshot?.exists == true { return }

            ref.setData([
                "name": name,
                "createdAt": FieldValue.serverTimestamp(),
                "initialRating": rating
            ])
        }
    }

    /// Ensure multiple spots exist.
    func ensureSpotsExist(_ spots: [(name: String, rating: Int)]) {
        for s in spots {
            ensureSpotExists(name: s.name, rating: s.rating)
        }
    }
    
    func searchSpots(prefix: String, completion: @escaping ([String]) -> Void) {

        let query = db.collection("Spots")
            .order(by: "name")
            .start(at: [prefix])
            .end(at: [prefix + "\u{f8ff}"]) // Firestore prefix search hack

        query.getDocuments { snapshot, _ in
            let names = snapshot?.documents.compactMap { $0.data()["name"] as? String } ?? []
            completion(names)
        }
    }

}
