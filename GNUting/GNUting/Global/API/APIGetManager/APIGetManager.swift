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
    
    func getSearchUser(searchNickname: String, completion:@escaping(SearchUserModel?)-> Void) {
        let url = EndPoint.searchGetUserData.url
        let email = UserEmailManager.shard.email
        guard let token = KeyChainManager.shared.read(key: email) else { return }
  
        let headers : HTTPHeaders = ["Authorization": token]
        let parameters: [String:Any] = ["nickname": searchNickname]
        AF.request(url,method: .get,parameters: parameters,encoding: URLEncoding.default,headers: headers).responseDecodable(of: SearchUserModel.self) { response in
            guard let statusCode = response.response?.statusCode else { return }
            print("getSearchUser statusCode: \(statusCode)")
            switch response.result {
            case .success:
                completion(response.value)
            case .failure(let err):
                print(err)
                break
            }
        }
    }
    
    func getSearchBoardText(searchText: String,page: Int, completion: @escaping(SearchBoardTextModel?)->Void) {
        let url = EndPoint.searchGetBoardData.url
        let email = UserEmailManager.shard.email
        guard let token = KeyChainManager.shared.read(key: email) else { return }
        let headers : HTTPHeaders = ["Authorization": token]
        let parameters: [String:Any] = ["keyword": searchText,"page": page]
        AF.request(url,method: .get,parameters: parameters,encoding: URLEncoding.default,headers: headers)
            .responseDecodable(of:SearchBoardTextModel.self) { response in
                guard let statusCode = response.response?.statusCode else { return }
                print("getSearchBoardText statusCode: \(statusCode)")
                switch response.result {
                case .success:
                    completion(response.value)
                case .failure(let err):
                    print(err)
                    break
                }
            }
    }
    func getBoardText(page:Int, size: Int, completion: @escaping(BoardModel?)-> Void) {
        let url = EndPoint.getBoardData.url
        let email = UserEmailManager.shard.email
        guard let token = KeyChainManager.shared.read(key: email) else { return }
        let headers : HTTPHeaders = ["Authorization": token]
        let parameters: [String:Any] = ["page": page, "size": size]
        AF.request(url,method: .get,parameters: parameters,encoding: URLEncoding.default,headers: headers)
            .responseDecodable(of:BoardModel.self) { response in
                guard let statusCode = response.response?.statusCode else { return }
                print("getBoardText statusCode: \(statusCode)")
                switch response.result {
                case .success:
                    completion(response.value)
                case .failure(let err):
                    print(err)
                    break
                }
            }
    }
    func getUserData(completion: @escaping(GetUserDataModel?) -> Void) {
        let url = EndPoint.getUserData.url
        let email = UserEmailManager.shard.email
        guard let token = KeyChainManager.shared.read(key: email) else { return }
        print(token)
        let headers : HTTPHeaders = ["Authorization": token]
        AF.request(url,method: .get,headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: GetUserDataModel.self) { response in
                switch response.result {
                case .success:
                    completion(response.value)
                case .failure(let err):
                    print(err)
                    break
                }
            }
        
        
    }
    
    
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

