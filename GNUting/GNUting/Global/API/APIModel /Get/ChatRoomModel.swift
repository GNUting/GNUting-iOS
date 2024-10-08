//
//  ChatRoomModel.swift
//  GNUting
//
//  Created by 원동진 on 3/27/24.
//

import Foundation

struct ChatRoomModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: [ChatRoomModelResult]
}

struct ChatRoomModelResult: Codable, Equatable {
    let id: Int
    let title, leaderUserDepartment, applyLeaderDepartment: String
    let chatRoomUsers: [ChatRoomUserList]
    let hasNewMessage: Bool
    let lastMessageTime, lastMessage: String
    let chatRoomUserProfileImages: [String?]
}

struct ChatRoomUserList: Codable, Equatable {
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
