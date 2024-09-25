//
//  EventServerOpenModel.swift
//  GNUting
//
//  Created by 원동진 on 9/25/24.
//

import Foundation
struct EventServerOpenModel: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String
}

struct EventParticipateModel: Encodable {
    let nickname: String
}

struct EventApplyResponseModel: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: EventApplyModelData
}

struct EventApplyModelData: Decodable {
    let chatId: Int
}
