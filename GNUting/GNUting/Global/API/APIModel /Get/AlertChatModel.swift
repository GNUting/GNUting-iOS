//
//  AlertChatModel.swift
//  GNUting
//
//  Created by 원동진 on 5/9/24.
//

import Foundation
// MARK: - 채팅 알림 클릭시 이동
struct AlertChatModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: AlertChatModelResult
}

// MARK: - Result
struct AlertChatModelResult: Codable {
    let title, leaderUserDepartment, applyLeaderDepartment: String
}
