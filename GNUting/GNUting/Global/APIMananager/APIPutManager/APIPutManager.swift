//
//  APIPutManager.swift
//  GNUting
//
//  Created by 원동진 on 5/5/24.
//

import Foundation
import Alamofire
class APIPutManager {
    static let shared = APIPutManager()
    func putTotalNotification(alertStatus: String,completion: @escaping(DefaultResponse) -> Void) {
        let url = EndPoint.notificationSetting.url
        let parameters : [String : String] = ["notificationSetting": alertStatus]
        AF.request(url,method: .put,parameters: parameters,encoding: JSONEncoding.default,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .response { response in
                guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
                
                switch response.result {
                case .success:
                    print("🟢 putTotalNotification statusCode :\(statusCode)")
                    completion(json)
                case .failure:
                    print("🔴 putTotalNotification statusCode :\(statusCode)")
                    completion(json)
                }
            }
    }
}
