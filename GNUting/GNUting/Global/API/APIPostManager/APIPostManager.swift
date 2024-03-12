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
    
    
    func postSignUP(signUpdata : SignUpModel,image : UIImage,completion: @escaping (Error?) -> Void) {
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
                    print("postSignUP response Body : \(json)")
                }
                
            case .failure(let err):
                print(err)
                completion(err)
            }
        }
        
        
    }
    
}

