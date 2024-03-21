//
//  APIInterceptorManager.swift
//  GNUting
//
//  Created by 원동진 on 3/21/24.
//

import Foundation
import Alamofire

final class APIInterceptorManager: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix(BaseURL.shared.urlString) == true,
              let accessToken = UserEmailManager.shard.getToken() else {
            
            completion(.success(urlRequest))
            return
        }
        var urlRequest = urlRequest
        urlRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        completion(.success(urlRequest))
    }
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        guard let refreshToken = KeyChainManager.shared.read(key: "RefreshToken") else { return }
        APIPostManager.shared.updateAccessToken(refreshToken: refreshToken) { response,statusCode  in
            switch statusCode {
            case 200..<300:
                print("🟢 updateAccessToken Success:\(statusCode)")
                KeyChainManager.shared.create(key: UserEmailManager.shard.email, token: response.result.accessToken)
                completion(.retry)
            default:
                print("🔴 updateAccessToken Success:\(statusCode)")
                completion(.doNotRetryWithError(error))
            }
        }
        
    }
}

