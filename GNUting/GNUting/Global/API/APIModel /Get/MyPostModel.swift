//
//  MyPostModel.swift
//  GNUting
//
//  Created by 원동진 on 3/15/24.
//

import Foundation
struct MyPostModel : Codable{
    let isSuccess: Bool
       let code, message: String
       let result: [MyPostResult]
}
// MARK: - Result
struct MyPostResult: Codable {
    let id: Int
    let title, detail, status, gender: String
    let user: MyInfo
    let inUserCount: Int
}

// MARK: - User
struct MyInfo: Codable {
    let nickname, department, studentId: String
}
