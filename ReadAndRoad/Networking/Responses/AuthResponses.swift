//
//  AuthResponses.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//

import Foundation

struct LoginAndRegisterResponse: Codable {
    let token: String?
    let message: String?
}
