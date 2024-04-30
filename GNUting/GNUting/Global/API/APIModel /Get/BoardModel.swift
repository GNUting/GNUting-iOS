//
//  BoardModel.swift
//  GNUting
//
//  Created by 원동진 on 3/13/24.
//

import Foundation
struct BoardModel: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [BoardResult]?
}

struct BoardResult: Codable {
    let id: Int
    let title: String
    let detail: String
    let status: String
    let gender: String
    let user : BoardUser
    let inUserCount: Int
}

struct BoardUser: Codable {
    let nickname: String
    let department: String
    let studentId: String
}
