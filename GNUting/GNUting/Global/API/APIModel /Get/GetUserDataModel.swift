//
//  GetUserDataManager.swift
//  GNUting
//
//  Created by 원동진 on 3/12/24.
//

import Foundation
struct GetUserDataModel: Decodable {
    let isSuccess: Bool
    let code : String
    let result : UserDataResult?
}
struct UserDataResult: Decodable {
    let id: Int
    let gender: String
    let age: String
    let name: String
    let nickname: String
    let department: String
    let profileImage: String?
    let studentId: String
    let userRole: String
    let userSelfIntroduction: String
}
