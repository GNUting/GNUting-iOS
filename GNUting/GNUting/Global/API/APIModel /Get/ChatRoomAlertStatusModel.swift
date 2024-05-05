//
//  ChatRoomAlertStatusModel.swift
//  GNUting
//
//  Created by 원동진 on 5/5/24.
//

import Foundation

struct ChatRoomAlertStatusModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: ChatRoomAlertStatusModelResult
}

struct ChatRoomAlertStatusModelResult: Codable {
    let notificationSetting: String
}
