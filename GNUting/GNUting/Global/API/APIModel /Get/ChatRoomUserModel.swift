//
//  ChatRommUserModel.swift
//  GNUting
//
//  Created by 원동진 on 5/7/24.
//

import Foundation
struct ChatRoomUserModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: [ChatRommUserModelResult]
}

// MARK: - Result
struct ChatRommUserModelResult: Codable {
    let id, userID, chatRoomID: Int
    let nickname, department, studentID: String
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case chatRoomID = "chatRoomId"
        case nickname, profileImage, department
        case studentID = "studentId"
    }
}
