//
//  SignUpModel.swift
//  GNUting
//
//  Created by 원동진 on 3/11/24.
//

import Foundation

struct SignUpModel: Encodable {
    var birthDate: String
    var department: String
    var email: String
    var gender: String
    var name: String
    var nickname: String
    var password: String
    var phoneNumber: String
    var studentId: String
    var userSelfIntroduction: String
}
