//
//  SearchUserModel.swift
//  GNUting
//
//  Created by 원동진 on 3/14/24.
//

import Foundation
// MARK: - SearchUserModel
struct SearchUserModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: UserInfosModel
}
