//
//  APIResponse.swift
//  GNUting
//
//  Created by 원동진 on 3/11/24.
//

import Foundation
struct DefaultResponse : Codable {
    let isSuccess: Bool
    let code: String
    let message: String
}
struct EmailCheckResponse : Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result : Number
}
struct requestChatResponse : Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result : String
}
struct Number : Codable {
    let number : String
}
