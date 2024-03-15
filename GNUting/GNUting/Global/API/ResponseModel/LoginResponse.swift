//
//  LoginResponse.swift
//  GNUting
//
//  Created by 원동진 on 3/12/24.
//

import Foundation

struct LoginSuccessResponse: Decodable {
    let isSuccess : Bool
    let code : String
    let message : String
    let result : ResponseResult
}

struct ResponseResult: Decodable {
    let accessToken: String
    let refreshToken: String
}
