//
//  RequestStatusModel.swift
//  GNUting
//
//  Created by 원동진 on 3/18/24.
//

import Foundation
struct ApplicationStatusModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: [ApplicationStatusResult]
}

// MARK: - RequestStatusResult

struct ApplicationStatusResult: Codable {
    let id: Int
    let applyUserDepartment, participantUserDepartment: String
    let applyUser, participantUser: [ApplicationStatusUser]
    let applyUserCount, participantUserCount: Int
    let applyStatus: String
}

// MARK: - User
struct ApplicationStatusUser: Codable {
    let id: Int
    let name, gender, age, nickname: String
    let department: String
    let profileImage: String?
    let studentId, userRole, userSelfIntroduction: String

}
