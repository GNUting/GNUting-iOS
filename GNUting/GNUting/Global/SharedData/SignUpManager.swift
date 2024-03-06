//
//  SignUpManager.swift
//  GNUting
//
//  Created by 원동진 on 3/6/24.
//

import Foundation

struct SignUpModel {
    let email: String
    let password: String
    let name: String
    let phoneNumber: String
    let gender: String
    let birthDate: String
    let nickName: String
    let department: String
    let studentId: String
    let userSelfIntroduction: String
    
    init(email: String, password: String, name: String, phoneNumber: String, gender: String, birthDate: String, nickName: String, department: String, studentId: String, userSelfIntroduction: String) {
        self.email = email
        self.password = password
        self.name = name
        self.phoneNumber = phoneNumber
        self.gender = gender
        self.birthDate = birthDate
        self.nickName = nickName
        self.department = department
        self.studentId = studentId
        self.userSelfIntroduction = userSelfIntroduction
    }
}

class SignUpManager {
    static let sharred = SignUpManager()
    var signUpdata : SignUpModel?
    
    private init () {}
}
