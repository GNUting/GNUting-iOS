//
//  UserData.swift
//  GNUting
//
//  Created by 원동진 on 3/12/24.
//

import Foundation

class UserEmailManager {
    static let shard = UserEmailManager()
    var email = ""
    private init () {}
    func getToken() -> String? {
        let token = KeyChainManager.shared.read(key: email)
        
        return "bearer " + (token ?? "")
    }
}
