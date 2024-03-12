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
    var url : URL {
        switch self{
        case .signUp:
            return .makeForEndpoint(endPoint: "signup")
        case .emailCheck:
            return .makeForEndpoint(endPoint: "mail")
        case .checkNickname:
            return .makeForEndpoint(endPoint: "check-nickname")
        }
    }
}

private extension URL{
    static let baseURL = "http://localhost:8080/api/v1/"
    static func makeForEndpoint(endPoint : String) -> URL{
        URL(string: baseURL + endPoint)!
    }
}
