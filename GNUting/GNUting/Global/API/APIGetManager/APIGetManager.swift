//
//  APIGetManager.swift
//  GNUting
//
//  Created by 원동진 on 3/12/24.
//

import Foundation

import Alamofire

class APIGetManager {
    static let shared = APIGetManager()
    func checkNickname(nickname: String, completion: @escaping(NicknameCheckModel?,Int) -> Void) {
        let url = EndPoint.checkNickname.url
        let parameters : [String : String] = ["nickname": nickname]
        AF.request(url,method: .get,parameters: parameters,encoding: URLEncoding.default)
            .responseDecodable(of: NicknameCheckModel.self){ response in
                guard let statusCode = response.response?.statusCode else { return }
                print("checkNickname statusCode:\(statusCode)")
                switch statusCode {
                case 200..<300:
                    completion(response.value,statusCode)
                default:
                    guard let data = response.value else { return }
                    completion(data,statusCode)
                }
            }
    }
}
