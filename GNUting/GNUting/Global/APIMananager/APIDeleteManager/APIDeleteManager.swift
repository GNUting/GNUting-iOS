//
//  APIDeleteManager.swift
//  GNUting
//
//  Created by 원동진 on 3/17/24.
//

import Foundation
import Alamofire

class APIDeleteManager {
    static let shared = APIDeleteManager()
    
    // MARK: - 채팅 신청 취소하기 ✅
    func deleteRequestChat(boardID: Int,completion: @escaping(DefaultResponse)->Void ) {
        let uslString = "http://localhost:8080/api/v1/board/applications/cancel/\(boardID)"
        guard let url = URL(string: uslString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        AF.request(request,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .response { response in
                
                guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
                
                switch response.result {
                case .success:
                    print("🟢 deleteRequestChat statusCode :\(statusCode)")
                    completion(json)
                case .failure:
                    print("🔴 deleteRequestChat statusCode :\(statusCode)")
                    completion(json)
                    break
                }
            }
    }
    
    // MARK: - 내글 삭제 ✅
    
    func deletePostText(boardID: Int,completion: @escaping(DefaultResponse)->Void) {
        let uslString = "http://localhost:8080/api/v1/board/\(boardID)"
        guard let url = URL(string: uslString) else { return }
        AF.request(url,method: .delete,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .response { response in
                guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
                
                switch response.result {
                case .success:
                    print("🟢 deletePostText statusCode :\(statusCode)")
                    completion(json)
                case .failure:
                    print("🔴 deletePostText statusCode :\(statusCode)")
                    completion(json)
                    break
                }
            }
    }
    
    func deleteUser(completion:@escaping(ResponseWithResult)-> Void){
        let url = EndPoint.deleteUser.url
        AF.request(url,method: .delete,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .response {
                response in
                   guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                   guard let json = try? JSONDecoder().decode(ResponseWithResult.self, from: data) else { return }
                   
                   switch response.result {
                   case .success:
                       print("🟢 deleteUser statusCode :\(statusCode)")
                       completion(json)
                   case .failure:
                       print(json)
                       print("🔴 deleteUser statusCode :\(statusCode)")
                       completion(json)
                       break
                   }
            }
        
    }
}
