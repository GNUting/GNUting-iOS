//
//  ChatMessageModel.swift
//  GNUting
//
//  Created by 원동진 on 3/27/24.
//

import Foundation
struct ChatMessageModel: Codable {
    let id : Int
    let chatRoomId: Int
    let messageType: String
    let email: String
    let profileImage: String?
    let nickname: String
    let message: String
    let createdDate: String
}
