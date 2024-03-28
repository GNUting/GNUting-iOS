//
//  ChatRoomModel.swift
//  GNUting
//
//  Created by 원동진 on 3/27/24.
//

import Foundation
// MARK: - Welcome
struct ChatRoomModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: [ChatRoomModelResult]
}

// MARK: - Result
struct ChatRoomModelResult: Codable {
    let id: Int
    let title, leaderUserDepartment, applyLeaderDepartment: String
}

