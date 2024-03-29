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
    let messageType, email, profileImage, nickname: String
    let message, createdDate: String
}
