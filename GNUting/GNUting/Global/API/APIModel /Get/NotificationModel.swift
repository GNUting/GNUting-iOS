//
//  NotificationModel.swift
//  GNUting
//
//  Created by 원동진 on 4/8/24.
//

import Foundation

struct NotificationModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: [NotificationModelResult]
}

// MARK: - Result
struct NotificationModelResult: Codable {
    let id: Int
    let title, body, time: String
    let status: String?
    let location: String
    let locationId: Int?
}
