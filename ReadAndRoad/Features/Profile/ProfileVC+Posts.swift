//
//  ProfileVC+Posts.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

extension ProfileViewController {

    // MARK: - Pagination State (My Posts)

    /// Firestore last document pointer for "My Posts" pagination.
    private var myPostsLastDoc: DocumentSnapshot? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.myPostsLastDoc) as? DocumentSnapshot }
        set { objc_setAssociatedObject(self, &AssociatedKeys.myPostsLastDoc, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// Prevents duplicate pagination requests for "My Posts".
    private var isLoadingMyPosts: Bool {
        get { (objc_getAssociatedObject(self, &AssociatedKeys.isLoadingMyPosts) as? Bool) ?? false }
        set { objc_setAssociatedObject(self, &AssociatedKeys.isLoadingMyPosts, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    // MARK: - Pagination State (Saved Posts)

    /// Prevents duplicate pagination requests for saved posts.
    private var isLoadingSavedPosts: Bool {
        get { (objc_getAssociatedObject(self, &AssociatedKeys.isLoadingSavedPosts) as? Bool) ?? false }
        set { objc_setAssociatedObject(self, &AssociatedKeys.isLoadingSavedPosts, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private static let pageSize = 10


    // MARK: - Load My Posts (Paginated)

    /// Loads the next page of posts authored by the current user.
    /// - Parameter reset: If true, clears current data and loads from the beginning.
    func loadMyPosts(reset: Bool = false) {

        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard !isLoadingMyPosts else { return }

        isLoadingMyPosts = true

        // Reset pagination
        if reset {
            myPosts.removeAll()
            myPostsLastDoc = nil
            profileView.tableViewPosts.reloadData()
        }

        var query = Firestore.firestore()
            .collection("Posts")
            .whereField("authorID", isEqualTo: uid)
            .order(by: "createdAt", descending: true)
            .limit(to: Self.pageSize)

        // If continuing pagination
        if let last = myPostsLastDoc {
            query = query.start(afterDocument: last)
        }

        query.getDocuments { [weak self] snapshot, _ in

            guard let self = self else { return }
            self.isLoadingMyPosts = false

            guard let snap = snapshot, !snap.isEmpty else { return }

            let newPosts = snap.documents.compactMap { Post(document: $0) }
            self.myPosts.append(contentsOf: newPosts)

            // Save pointer for next page
            self.myPostsLastDoc = snap.documents.last

            // Update UI only if user is viewing "My Posts"
            if self.selectedSegmentIndex == 0 {
                self.profileView.tableViewPosts.reloadData()
            }
        }
    }


    // MARK: - Load Saved Posts (Paginated)

    /// Loads the next page of saved posts.
    func loadSavedPosts(reset: Bool = false) {

        guard !isLoadingSavedPosts else { return }
        isLoadingSavedPosts = true

        let allIDs = Array(SavedPostStore.shared.savedPostIDs)

        if reset {
            savedPosts.removeAll()
            profileView.tableViewPosts.reloadData()
        }

        // No saved posts at all
        guard !allIDs.isEmpty else {
            savedPosts.removeAll()
            profileView.tableViewPosts.reloadData()
            isLoadingSavedPosts = false
            return
        }

        // Determine the slice for the next page
        let startIndex = savedPosts.count
        let endIndex = min(startIndex + Self.pageSize, allIDs.count)

        guard startIndex < endIndex else {
            // No more data to load
            isLoadingSavedPosts = false
            return
        }

        let nextIDs = Array(allIDs[startIndex..<endIndex])
        let batches = nextIDs.chunked(into: 10)   // Firestore IN constraint

        let group = DispatchGroup()
        var fetchedPosts: [Post] = []

        for batch in batches {
            group.enter()

            Firestore.firestore().collection("Posts")
                .whereField(FieldPath.documentID(), in: batch)
                .getDocuments { snapshot, _ in

                    let posts = snapshot?.documents.compactMap { Post(document: $0) } ?? []
                    fetchedPosts.append(contentsOf: posts)
                    group.leave()
                }
        }

        group.notify(queue: .main) {

            // Merge results
            self.savedPosts.append(contentsOf: fetchedPosts)

            // Sort by date (newest first)
            self.savedPosts.sort {
                ($0.createdAt ?? Date.distantPast) > ($1.createdAt ?? Date.distantPast)
            }

            self.isLoadingSavedPosts = false

            if self.selectedSegmentIndex == 1 {
                self.profileView.tableViewPosts.reloadData()
            }
        }
    }


    // MARK: - Infinite Scroll Entry Point

    /// Call this inside scrollViewDidScroll to trigger pagination when near bottom.
    func loadMoreIfNeeded(scrollView: UIScrollView) {

        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let visibleHeight = scrollView.frame.size.height

        // When user scrolls to bottom area
        if position > contentHeight - visibleHeight * 1.5 {

            if selectedSegmentIndex == 0 {
                loadMyPosts(reset: false)
            } else {
                loadSavedPosts(reset: false)
            }
        }
    }


    // MARK: - Storage Keys for Associated Properties

    private struct AssociatedKeys {
        static var myPostsLastDoc = "myPostsLastDoc_key"
        static var isLoadingMyPosts = "isLoadingMyPosts_key"
        static var isLoadingSavedPosts = "isLoadingSavedPosts_key"
    }
}
