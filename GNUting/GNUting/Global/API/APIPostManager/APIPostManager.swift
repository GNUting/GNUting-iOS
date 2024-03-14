//
//  APIPostManager.swift
//  GNUting
//
//  Created by 원동진 on 3/11/24.
//

import Foundation
import UIKit

import Alamofire

class APIPostManager {
    static let shared = APIPostManager()
    func postWriteText(title: String,detail:String,joinMemberID: [UserIDList],completion: @escaping(Int)->Void) {
        let url = EndPoint.writeText.url
        let email = UserEmailManager.shard.email
        guard let token = KeyChainManager.shared.read(key: email) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        let requestBody = WriteTextUserData(title: title, detail: detail, inUser: joinMemberID)
        do {
            try request.httpBody = JSONEncoder().encode(requestBody)
        }catch {
            print("Error encoding request data: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            if (200..<300).contains(httpResponse.statusCode) {
                print("Request successful")
                completion(httpResponse.statusCode)
            } else {
                print("Request failed with status code: \(httpResponse.statusCode)")
                completion(httpResponse.statusCode)
                // Handle error response
            }
        }.resume()
        
    }
    func postLoginAPI(email: String, password: String, completion: @escaping (LoginSuccessResponse?,Int) -> Void) { // httpbody가아니라 파라미터로 넣는데 통신되는 이유 ?
        let url = EndPoint.login.url
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let parameters : [String : String] = ["email": email,"password":password]
        AF.request(url,method: .post,parameters: parameters,encoding: JSONEncoding.default,headers: headers)
            .responseData { response in
                guard let statusCode = response.response?.statusCode else { return }
                switch statusCode {
                case 200..<300:
                    guard let data = response.value else { return }
                    guard let authorization = response.response?.allHeaderFields["Authorization"] else { return }
                    
                    print("postLoginAPI statusCode:\(statusCode)")
                    if let json = try? JSONDecoder().decode(LoginSuccessResponse.self, from: data){
                        completion(json,statusCode)
                        let email = json.result.email
                        KeyChainManager.shared.create(key: email, token: authorization as! String)
                    }
                default:
                    completion(nil,statusCode)
                }
            }
    }
    
    func postEmailCheck(email: String, completion: @escaping (String,Error?) -> Void) {
        let url = EndPoint.emailCheck.url
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let parameters : [String : String] = ["email": email]
        AF.request(url,method: .post,parameters: parameters,encoding: JSONEncoding.default,headers: headers)
            .responseData { response in
                switch response.result {
                case .success:
                    guard let statusCode = response.response?.statusCode else { return }
                    print("postEmailCheck statusCode:\(statusCode)")
                    guard let data = response.value else { return }
                    if let json = try? JSONDecoder().decode(EmailCheckResponse.self, from: data) {
                        print("postEmailCheck response Body : \(json)")
                        completion(json.result.number,nil)
                    }
                    
                case .failure(let err):
                    print(err)
                    completion("",err)
                }
            }
    }
    
    
    func postSignUP(signUpdata : SignUpModel,image : UIImage,completion: @escaping (Error?,Bool) -> Void) {
        let url = EndPoint.signUp.url
        
        let header: HTTPHeaders = ["Content-Type": "multipart/form-data"]
        let parameters : [String : String] = ["birthDate":signUpdata.birthDate,"department":signUpdata.department,"email": signUpdata.email,"gender": signUpdata.gender," name": signUpdata.name,"nickname": signUpdata.nickname, "password": signUpdata.password, "phoneNumber" : signUpdata.phoneNumber, "studentId": signUpdata.studentId,"userSelfIntroduction": signUpdata.userSelfIntroduction]
        let imageData = image.jpegData(compressionQuality: 0.2)
        AF.upload(multipartFormData: { multipartFormData in
            for (key,value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            if let image = imageData {
                multipartFormData.append(image, withName: "profileImage",fileName: "userImage.jpeg",mimeType: "image/jpg")
            }
        }, to: url,method: .post,headers: header).responseData { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                print("postSignUP statusCode:\(statusCode)")
                guard let data = response.value else { return }
                if let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) {
                    print("postSignUP response Body : \(json.isSuccess)")
                    completion(response.error,json.isSuccess)
                }
                
            case .failure(let err):
                print(err)
                completion(err, false)
            }
        }
        
        
    }
    
}

