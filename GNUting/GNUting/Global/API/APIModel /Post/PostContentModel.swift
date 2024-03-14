//
//  PostContentModel.swift
//  GNUting
//
//  Created by 원동진 on 3/14/24.
//

import Foundation
// MARK: - Welcome
struct PostContentModel: Decodable {
    let title, detail: String
    let inUser: [InUser]
}

// MARK: - InUser
struct InUser: Codable {
    let id: Int
    let gender, birthDate, nickname, department: String
    let profileImage: String?
    let userRole: String
}
