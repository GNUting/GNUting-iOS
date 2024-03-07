//
//  SignUpManager.swift
//  GNUting
//
//  Created by 원동진 on 3/6/24.
//

import Foundation

class SignUpModelManager {
    static let shared = SignUpModelManager()
    var signUpDictionary : [String: String?] = ["email": nil,"password": nil,"name": nil,"phoneNumber": nil,"gender": nil,"birthDate": nil,"nickName": nil,"department": nil,"studentId": nil,"userSelfIntroduction": nil]
    
    private init () {}
    
    func setSignUpDictionary(setkey: String, setData: String?) {
        signUpDictionary[setkey] = setData
    }
}
