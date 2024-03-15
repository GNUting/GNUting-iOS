//
//  APIUpdateManager.swift
//  GNUting
//
//  Created by 원동진 on 3/15/24.
//

import Foundation
class APIUpdateManager {
    static let shared = APIUpdateManager()
    func updateWriteText(boardID: Int,title: String,detail:String,joinMemberID: [UserIDList],completion: @escaping(Int)->Void) {
        let uslString = "http://localhost:8080/api/v1/board/\(boardID)"
        guard let url = URL(string: uslString) else { return }
        guard let token = UserEmailManager.shard.getToken() else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
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
}
