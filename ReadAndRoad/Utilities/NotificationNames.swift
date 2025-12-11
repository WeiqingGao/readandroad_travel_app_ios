//
//  NotificationNames.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//

import Foundation

extension Notification.Name {
    // auth
    static let userLoggedIn = Notification.Name("userLoggedIn")
    static let userRegistered = Notification.Name("userRegistered")
    static let authFailed = Notification.Name("authFailed")
    static let userSignedOut = Notification.Name("userSignedOut")
    
    // post
    static let savedPostsUpdated = Notification.Name("savedPostsUpdated")
    static let postCreated = Notification.Name("postCreated")

    static let authStateDidChange = Notification.Name("authStateDidChange")
    static let userNicknameUpdated = Notification.Name("userNicknameUpdated")

}
