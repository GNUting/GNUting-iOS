//
//  SignUpManager.swift
//  GNUting
//
//  Created by 원동진 on 3/6/24.
//

import Foundation

class SignUpModelManager {
    static let shared = SignUpModelManager()
    var signUpDictionary : [String: String] = ["email": "","password": "","name": "","phoneNumber": "","gender": "","birthDate": "","nickName": "","department": "","studentId": "","userSelfIntroduction": ""]
    
    private init () {}
    
    func setSignUpDictionary(setkey: String, setData: String?) {
        signUpDictionary[setkey] = setData
    }
}
