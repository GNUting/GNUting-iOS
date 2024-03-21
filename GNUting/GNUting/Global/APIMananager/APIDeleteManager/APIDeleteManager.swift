//
//  APIDeleteManager.swift
//  GNUting
//
//  Created by 원동진 on 3/17/24.
//

import Foundation
class APIDeleteManager {
    static let shared = APIDeleteManager()
    func deleteRequestChat(boardID: Int,completion: @escaping(Int)->Void ) {
        let uslString = "http://localhost:8080/api/v1/board/applications/cancel/\(boardID)"
        guard let url = URL(string: uslString) else { return }
        guard let token = UserEmailManager.shard.getToken() else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue(token, forHTTPHeaderField: "Authorization")
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
                print("deleteRequestChat Request successful")
                completion(httpResponse.statusCode)
            } else {
                print("deleteRequestChat Request failed with status code: \(httpResponse.statusCode)")
                completion(httpResponse.statusCode)
                // Handle error response
            }
        }.resume()
    }
    
    func deletePostText(boardID: Int,completion: @escaping(Int)->Void) {
        let uslString = "http://localhost:8080/api/v1/board/\(boardID)"
        guard let url = URL(string: uslString) else { return }
        guard let token = UserEmailManager.shard.getToken() else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
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
                print("deletePostText Request successful")
                completion(httpResponse.statusCode)
            } else {
                print("deletePostText Request failed with status code: \(httpResponse.statusCode)")
                completion(httpResponse.statusCode)
                // Handle error response
            }
        }.resume()
        
    }
}
