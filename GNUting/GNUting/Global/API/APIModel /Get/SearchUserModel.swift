//
//  SearchUserModel.swift
//  GNUting
//
//  Created by 원동진 on 3/14/24.
//

import Foundation
// MARK: - Welcome
struct SearchUserModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: SearchUserData
}

// MARK: - Result
struct SearchUserData: Codable {
    let id: Int
    let name, gender, age, nickname: String
    let department, studentId, userRole: String
    let profileImage: String?
    let userSelfIntroduction: String
}
