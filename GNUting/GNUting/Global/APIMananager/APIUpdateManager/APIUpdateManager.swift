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
    func rejectedApplication(boardID: Int, completion: @escaping(DefaultResponse?) -> Void) {
        let uslString = "http://localhost:8080/api/v1/board/applications/refuse/\(boardID)"
        guard let url = URL(string: uslString) else { return }
        guard let token = UserEmailManager.shard.getToken() else { return }
        let header: HTTPHeaders = ["Content-Type": "application/json","Authorization": token]
        guard let url = URL(string: uslString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
            let json = try? JSONDecoder().decode(DefaultResponse.self, from: data)
            if (200..<300).contains(httpResponse.statusCode) {
                print("rejectedApplication Request successful")
                completion(json)
            } else {
                print("rejectedApplication Request failed with status code: \(httpResponse.statusCode)")
                completion(json)
            }
        }.resume()
    }
    func updateUserProfile(nickname: String, department: String, userSelfIntroduction: String,image: UIImage,completion :@escaping(Int)->Void) {
        let url = EndPoint.updateProfile.url
        guard let token = UserEmailManager.shard.getToken() else { return }
        let header: HTTPHeaders = ["Content-Type": "multipart/form-data","Authorization": token]
        let parameters : [String : String] = ["department":department,"nickname": nickname,"userSelfIntroduction": userSelfIntroduction]
        let imageData = image.jpegData(compressionQuality: 0.2)
        AF.upload(multipartFormData: { multipartFormData in
            for (key,value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            if let image = imageData {
                multipartFormData.append(image, withName: "profileImage",fileName: "userUpdateImage.jpeg",mimeType: "image/jpg")
            }
        }, to: url,method: .patch,headers:header).response { response in
            guard let statusCode = response.response?.statusCode else { return }
            completion(statusCode)
        }
    }
    
    
    func updateWriteText(boardID: Int,title: String,detail:String,memeberInfos: [UserInfosModel],completion: @escaping(Int)->Void) {
        let uslString = "http://localhost:8080/api/v1/board/\(boardID)"
        guard let url = URL(string: uslString) else { return }
        guard let token = UserEmailManager.shard.getToken() else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        let requestBody = UpdateMypostModel(title: title, detail: detail, inUser: memeberInfos)
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
                print("updateWriteText Request failed with status code: \(httpResponse.statusCode)")
                completion(httpResponse.statusCode)
                // Handle error response
            }
        }.resume()
        
    }
}
