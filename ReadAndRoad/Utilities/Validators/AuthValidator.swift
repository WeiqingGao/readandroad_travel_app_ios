//
//  AuthValidator.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/15/25.
//

import Foundation

struct AuthValidator {
    
    static func isNameValid(_ name: String) -> Bool {
        return !name.isEmpty
    }
    
    static func isEmailValid(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: email)
    }
    
    static func isPasswordValid(_ password: String) -> Bool {
        return !password.isEmpty && password.count >= 6
    }
    
    static func isPasswordMatch(_ password: String, _ rePassword: String) -> Bool {
        return password == rePassword
    }
}
