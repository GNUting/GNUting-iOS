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
    
    func updateAccessToken(refreshToken: String, completion: @escaping(RefreshAccessTokenResponse,Int)->Void){
        let url = EndPoint.updateAccessToken.url
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let parameters : [String : String] = ["refreshToken": refreshToken]
        
        AF.request(url,method: .post,parameters: parameters,encoding: JSONEncoding.default,headers: headers)
            .responseDecodable(of:RefreshAccessTokenResponse.self) { response in
                guard let statusCode = response.response?.statusCode else { return }
                guard let responseData = response.value else { return }
               completion(responseData, statusCode)
            }
    }
    
    func postAuthenticationCheck(email: String, number: String, completion: @escaping(DefaultResponse?,Int)->Void) {
        let url = EndPoint.checkMailVerify.url
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let parameters : [String : String] = ["email": email,"number":number]
        AF.request(url,method: .post,parameters: parameters,encoding: JSONEncoding.default,headers: headers).responseData { response in
            guard let statusCode = response.response?.statusCode else { return }
            guard let data = response.value else { return }
            if let json = try? JSONDecoder().decode(DefaultResponse.self, from: data)  {
                completion(json,statusCode)
            }else{
                completion(nil,statusCode)
            }
        }
        
    }
    func postFCMToken(fcmToken: String, completion: @escaping(DefaultResponse?,Int) -> Void) {
        let url = EndPoint.fcmToken.url
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let token = UserEmailManager.shard.getToken() else { return }
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let requestBody = FcmTokenModel(fcmToken: fcmToken)
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
            guard let data = data else { return }
            let responseBody = try? JSONDecoder().decode(DefaultResponse.self, from: data)
            if (200..<300).contains(httpResponse.statusCode) {
                print("🟢 successful",#function)
                completion(responseBody,httpResponse.statusCode)
            } else {
                print("postFCMToken Request failed with status code: \(httpResponse.statusCode)")
                completion(responseBody,httpResponse.statusCode)
                // Handle error response
            }
        }.resume()
    }
    
    func postRequestChat(userInfos: [UserInfosModel],boardID: Int, completion: @escaping(requestChatResponse,Int) -> Void){
        
        let uslString = "http://localhost:8080/api/v1/board/apply/\(boardID)"
        guard let url = URL(string: uslString) else { return }
        guard let token = UserEmailManager.shard.getToken() else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = userInfos
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
            guard let data = data else { return }
            guard let response = try? JSONDecoder().decode(requestChatResponse.self, from: data) else { return }
            if (200..<300).contains(httpResponse.statusCode) {
                print("postRequestChat Request successful")
                completion(response,httpResponse.statusCode)
            } else {
                
                print("postRequestChat Request failed with status code: \(httpResponse.statusCode)")
                completion(response,httpResponse.statusCode)
                // Handle error response
            }
        }.resume()
    }
    func postReportBoard(boardID: Int,reportCategory: String, reportReason: String, completion: @escaping(Int)-> Void) {
        let url = EndPoint.report.url
        guard let token = UserEmailManager.shard.getToken() else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let requestBody = PostReportModel(boardId: boardID, reportCategory: reportCategory, reportReason: reportReason)
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
                print("postReportBoard Request successful")
                completion(httpResponse.statusCode)
            } else {
                print("postReportBoard Request failed with status code: \(httpResponse.statusCode)")
                completion(httpResponse.statusCode)
                // Handle error response
            }
        }.resume()
    }
    
    func postWriteText(title: String,detail:String,joinMemberID: [UserIDList],completion: @escaping(Int)->Void) {
        let url = EndPoint.writeText.url
        guard let token = UserEmailManager.shard.getToken() else { return }
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
                print("postWriteText Request successful")
                completion(httpResponse.statusCode)
            } else {
                print("postWriteText Request failed with status code: \(httpResponse.statusCode)")
                completion(httpResponse.statusCode)
                // Handle error response
            }
        }.resume()
        
    }
    func postLoginAPI(email: String, password: String, completion: @escaping (Int) -> Void) { // httpbody가아니라 파라미터로 넣는데 통신되는 이유 ?
        let url = EndPoint.login.url
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let parameters : [String : String] = ["email": email,"password":password]
        AF.request(url,method: .post,parameters: parameters,encoding: JSONEncoding.default,headers: headers)
            .responseData { response in
                
                guard let statusCode = response.response?.statusCode else { return }
                switch statusCode {
                case 200..<300:
                    guard let data = response.value else { return }
                    print("postLoginAPI statusCode:\(statusCode)")
                    if let json = try? JSONDecoder().decode(LoginSuccessResponse.self, from: data){
                        let accessToken = json.result.accessToken
                        let refrechToken = json.result.refreshToken
                        KeyChainManager.shared.create(key: email, token: accessToken)
                        KeyChainManager.shared.create(key: "RefreshToken", token: refrechToken)
                        UserEmailManager.shard.email = email
                        completion(statusCode)
                        
                    }
                default:
                    completion(statusCode)
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
                multipartFormData.append(image, withName: "profileImage",fileName: "UserImage.jpeg",mimeType: "image/jpg")
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

