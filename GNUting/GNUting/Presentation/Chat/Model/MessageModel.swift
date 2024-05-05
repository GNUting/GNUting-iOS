//
//  MessageModel.swift
//  GNUting
//
//  Created by 원동진 on 5/5/24.
//

import Foundation
struct MessageModel: Codable {
    let id : Int
    let chatRoomId : Int
    let messageType : String
    let email : String
    let profileImage : String
    let nickname: String
    let message: String
    let createdDate : String
    let department : String
    let studentId : String
}
