//
//  WrteTextUserData.swift
//  GNUting
//
//  Created by 원동진 on 3/15/24.
//

import Foundation


struct WriteTextUserData: Codable {
    let title: String
    let detail: String
    let inUser: [UserIDList]
    
}
struct UserIDList : Codable{
    let id: Int
}
