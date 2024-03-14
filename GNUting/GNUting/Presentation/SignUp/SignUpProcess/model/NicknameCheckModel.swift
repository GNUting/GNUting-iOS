//
//  NicknameCheckModel.swift
//  GNUting
//
//  Created by 원동진 on 3/12/24.
//

import Foundation
struct NicknameCheckModel: Decodable{
    let isSuccess: Bool
    let code: String
    let message: String
}

