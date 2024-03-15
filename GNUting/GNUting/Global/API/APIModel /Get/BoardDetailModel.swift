//
//  BoardDetailModel.swift
//  GNUting
//
//  Created by 원동진 on 3/15/24.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - BoardDetailModel
struct BoardDetailModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: BoardDetailResult
}

// MARK: - Result
struct BoardDetailResult: Codable {
    let id, inUserCount: Int
    let title, detail, status, gender, time: String
    let inUser: [UserInfosModel]
    let user: User
}



// MARK: - User
struct User: Codable {
    let nickname, department, studentId: String
    let image: String?
}
