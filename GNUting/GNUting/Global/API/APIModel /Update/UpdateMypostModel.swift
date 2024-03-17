//
//  UpdateMypostModel.swift
//  GNUting
//
//  Created by 원동진 on 3/17/24.
//

import Foundation
struct UpdateMypostModel: Codable {
    let title, detail: String
    let inUser: [UserInfosModel]
}


