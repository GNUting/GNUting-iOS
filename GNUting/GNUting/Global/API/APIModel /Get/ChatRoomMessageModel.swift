//
//  ChatRoomMessageModel.swift
//  GNUting
//
//  Created by 원동진 on 3/29/24.
//

import Foundation
// MARK: - Welcome
struct ChatRoomMessageModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: [ChatRoomMessageModelResult]
}

// MARK: - Result
struct ChatRoomMessageModelResult: Codable {
    let id, chatRoomId: Int
    let messageType : String
    let email: String?
    let nickname: String?
    let profileImage: String?
    let message: String
    let createdDate: String
}


struct LeaveMessageModel: Codable {
    let messageType: String
    let message: String
}
