//
//  NotificationCheckModel.swift
//  GNUting
//
//  Created by 원동진 on 4/8/24.
//

import Foundation
struct NotificationCheckModel: Codable{
    let isSuccess: Bool
    let code, message: String
    let result: Bool
}
