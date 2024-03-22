//
//  UserDefaultsManager.swift
//  GNUting
//
//  Created by 원동진 on 3/22/24.
//

import Foundation
class UserDefaultsManager{
    static let shared = UserDefaultsManager()
    func setLogin() {
        
        UserDefaults.standard.set(true, forKey: "LoginState")
    }
    func setLogout() {
        UserDefaults.standard.set(false, forKey: "LoginState")
    }
    func getLoginState() -> Any? {
        return UserDefaults.standard.object(forKey: "LoginState")
    }
}
