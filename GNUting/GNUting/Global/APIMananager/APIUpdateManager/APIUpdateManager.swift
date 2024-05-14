//
//  APIUpdateManager.swift
//  GNUting
//
//  Created by 원동진 on 3/15/24.
//


import UIKit
import Alamofire

class APIUpdateManager {
    static let shared = APIUpdateManager()
    
    // MARK: - 과팅 신청 거절하기 ✅
    func rejectedApplication(boardID: Int, completion: @escaping(DefaultResponse) -> Void) {
        let uslString = "http://203.255.3.66:10001/api/v1/board/applications/refuse/\(boardID)"
        guard let url = URL(string: uslString) else { return }
        AF.request(url,method: .patch,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .response{ response in
                
                guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
                switch response.result {
                case .success:
                    print("🟢 rejectedApplication statusCode: \(statusCode)")
                    completion(json)
                case .failure:
                    print("🔴 rejectedApplication statusCode: \(statusCode)")
                    print(response.result)
                    completion(json)
                    break
                }
            }
    }
    
    // MARK: - 유저 정보 수정 ✅
    func updateUserProfile(nickname: String, department: String, userSelfIntroduction: String,image: UIImage,completion :@escaping(DefaultResponse)->Void) {
        let url = EndPoint.updateProfile.url
        guard let email = KeyChainManager.shared.read(key: "UserEmail") else { return } //🔨
        guard let token = KeyChainManager.shared.read(key: email) else { return }
        
        let header: HTTPHeaders = ["Content-Type": "multipart/form-data","Authorization": "Bearer " + token]
        let parameters : [String : String] = ["department":department,"nickname": nickname,"userSelfIntroduction": userSelfIntroduction]
        let imageData = image.jpegData(compressionQuality: 0.2)
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key,value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            if let image = imageData {
                print(image)
                multipartFormData.append(image, withName: "profileImage",fileName: "\(nickname).jpeg",mimeType: "image/jpg")
            }
            print(multipartFormData)
        }, to: url,method: .patch,headers:header)
        .validate(statusCode: 200..<300)
        .response { response in
            guard let statusCode = response.response?.statusCode, let data = response.data else { return }
            guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
            switch response.result {
            case .success:
                print("🟢 updateUserProfile statusCode: \(statusCode)")
                completion(json)
            case .failure:
                print("🔴 updateUserProfile statusCode: \(statusCode)")
                completion(json)
                break
            }
        }
    }
    
    // MARK: - 글 수정 ✅
    func updateWriteText(boardID: Int,title: String,detail:String,memeberInfos: [UserInfosModel],completion: @escaping(DefaultResponse)->Void) {
        let uslString = "http://203.255.3.66:10001/api/v1/board/\(boardID)"
        guard let url = URL(string: uslString) else { return }
  
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
  
        let requestBody = UpdateMypostModel(title: title, detail: detail, inUser: memeberInfos)
        do {
            try request.httpBody = JSONEncoder().encode(requestBody)
        }catch {
            print("Error encoding request data: \(error)")
            return
        }
        
        AF.request(request,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .response { response in
                guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
                switch response.result {
                case .success:
                    print("🟢 updateWriteText statusCode: \(statusCode)")
                    completion(json)
                case .failure:
                    print("🔴 updateWriteText statusCode: \(statusCode)")
                    completion(json)
                    break
                }
            }
    }
    func updatePassword(email: String,password: String, completion: @escaping(DefaultResponse)-> Void) {
        let url = EndPoint.setNewPassword.url
        let parameters : [String : String] = ["email": email + "@gnu.ac.kr","password":password]
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        AF.request(url,method: .patch,parameters: parameters,encoding: JSONEncoding.default,headers: headers)
            .validate(statusCode: 200..<300)
            .response { response in
                guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                switch response.result {
                case .success:
                    print("🟢 updatePassword statusCode :\(statusCode)")
                    guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
                    completion(json)
                case .failure:
                    guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
                    print("🔴 updatePassword statusCode :\(statusCode)")
                    completion(json)
                    break
                }
            }
    }
   
}
