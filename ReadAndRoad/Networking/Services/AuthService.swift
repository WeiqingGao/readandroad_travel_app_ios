//
//  AuthService.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    static let shared = AuthService()
    private init() {}
    
    private let db = Firestore.firestore()
    
    // MARK: - Firebase Register
    func register(parameters: [String: Any]) {
        guard let name = parameters["name"] as? String,
              let email = parameters["email"] as? String,
              let password = parameters["password"] as? String else {
            NotificationCenter.default.post(name: .authFailed, object: "Invalid registration parameters.")
            return
        }
        
        // MARK: check if the username already exists
        let usernamesRef = db.collection("usernames").document()
        usernamesRef.getDocument { snapshot, error in
            if let error = error {
                print("Check username error:", error.localizedDescription)
                NotificationCenter.default.post(name: .authFailed, object: "Failed to check username. Please try again")
                return
            }
            
            if let snapshot = snapshot, snapshot.exists {
                // MARK: already exist
                NotificationCenter.default.post(name: .authFailed, object: "Username already taken.")
                return
            }
            
            // MARK: username available
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error as NSError? {
                    print("Registration error:", error.localizedDescription)
                    
                    if error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                        NotificationCenter.default.post(name: .authFailed, object: "This email is already in use.")
                    } else {
                        NotificationCenter.default.post(name: .authFailed, object: error.localizedDescription)
                    }
                    return
                }
                
                guard let user = authResult?.user else {
                    NotificationCenter.default.post(name: .authFailed, object: "Failed to get user info.")
                    return
                }
                
                let change = user.createProfileChangeRequest()
                change.displayName = name
                change.commitChanges { commitError in
                    if let commitError = commitError {
                        print("Failed to set displayName:", commitError.localizedDescription)
                    }
                }
                
                let uid = user.uid
                print("User registered:", user.email ?? "")
                
                let batch = self.db.batch()
                
                let userRef = self.db.collection("users").document(uid)
                let usernameRef = self.db.collection("usernames").document(name)
                
                let userData: [String: Any] = [
                    "uid": uid,
                    "name": name,
                    "email": email,
                    "createdAt": FieldValue.serverTimestamp()
                ]
                
                batch.setData(userData, forDocument: userRef)
                batch.setData(["uid": uid], forDocument: usernameRef)
                
                batch.commit { batchError in
                    if let batchError = batchError {
                        print("Firestore save error:", batchError.localizedDescription)
                        NotificationCenter.default.post(name: .authFailed, object: "Failed to save user info.")
                        return
                    }
                    
                    NotificationCenter.default.post(name: .userRegistered, object: uid)
                }
            }
        }
    }
    
    // MARK: - Firebase Login
    func login(parameters: [String: Any]) {
        guard let email = parameters["email"] as? String,
              let password = parameters["password"] as? String else {
            NotificationCenter.default.post(name: .authFailed, object: "Invalid login parameters.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Login error:", error.localizedDescription)
                NotificationCenter.default.post(name: .authFailed, object: error.localizedDescription)
                return
            }
            
            if let user = authResult?.user {
                print("User logged in:", user.email ?? "")
                NotificationCenter.default.post(name: .userLoggedIn, object: user.uid)
            }
        }
    }
}
