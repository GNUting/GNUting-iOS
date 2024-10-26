//
//  CommonModel.swift
//  GNUting
//
//  Created by 원동진 on 3/15/24.
//

import Foundation
struct UserInfosModel: Codable {
    let id: Int
    let name, gender, age, nickname, department, studentId, userRole, userSelfIntroduction: String
    let profileImage: String?
}
