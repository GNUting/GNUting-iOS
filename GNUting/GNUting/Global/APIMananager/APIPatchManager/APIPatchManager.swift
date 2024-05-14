//
//  APIPatchManager.swift
//  GNUting
//
//  Created by 원동진 on 5/14/24.
//

import Foundation
import Alamofire
class APIPatchManager {
    static let shared = APIPatchManager()
    func deleteApplystate(chatRoomID: Int, completion: @escaping(DefaultResponse) -> Void) {
        let url = BaseURL.shared.urlString + "board/applications/applystate/" + "\(chatRoomID)"
        AF.request(url,method: .patch,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .response { response in
                guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
                
                switch response.result {
                case .success:
                    print("🟢 deleteApplystate statusCode :\(statusCode)")
                    completion(json)
                case .failure:
                    print("🔴 deleteApplystate statusCode :\(statusCode)")
                    completion(json)
                }
            }
    }
    func deleteReceivedstate(chatRoomID: Int, completion: @escaping(DefaultResponse) -> Void) {
        let url = BaseURL.shared.urlString + "board/applications/receivedstate/" + "\(chatRoomID)"
        AF.request(url,method: .patch,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .response { response in
                guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
                
                switch response.result {
                case .success:
                    print("🟢 deleteReceivedstate statusCode :\(statusCode)")
                    completion(json)
                case .failure:
                    print("🔴 deleteReceivedstate statusCode :\(statusCode)")
                    completion(json)
                }
            }
    }
}
