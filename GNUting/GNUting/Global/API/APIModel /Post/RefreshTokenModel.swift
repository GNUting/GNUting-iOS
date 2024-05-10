//
//  RefreshTokenModel.swift
//  GNUting
//
//  Created by 원동진 on 3/22/24.
//

import Foundation
struct RefreshTokenModel: Codable {
    let refreshToken: String
    let fcmToken: String
}
