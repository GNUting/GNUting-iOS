//
//  APIURL.swift
//  GNUting
//
//  Created by 원동진 on 3/11/24.
//

import Foundation
enum EndPoint{
    case signUp
    case emailCheck
    case checkNickname
    case login
    case getUserData
    case getBoardData
    case searchBoardData
    var url : URL {
        switch self{
        case .login:
            return .makeForEndpoint(endPoint: "login")
        case .signUp:
            return .makeForEndpoint(endPoint: "signup")
        case .emailCheck:
            return .makeForEndpoint(endPoint: "mail")
        case .checkNickname:
            return .makeForEndpoint(endPoint: "check-nickname")
        case .getUserData:
            return .makeForEndpoint(endPoint: "board/user/myinfo")
        case .getBoardData:
            return .makeForEndpoint(endPoint: "board")
        case .searchBoardData:
            return .makeForEndpoint(endPoint: "board/search")
        }
    }
}

private extension URL{
    static let baseURL = "http://localhost:8080/api/v1/"
    static func makeForEndpoint(endPoint : String) -> URL{
        URL(string: baseURL + endPoint)!
    }
}
