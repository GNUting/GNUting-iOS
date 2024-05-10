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
        
        guard let email = KeyChainManager.shared.read(key: "UserEmail") else { return } //🔨
        
        guard urlRequest.url?.absoluteString.hasPrefix(BaseURL.shared.urlString) == true,
              let accessToken = KeyChainManager.shared.read(key: email) else {
            
            completion(.success(urlRequest))
            return
        }
    
        var urlRequest = urlRequest
        urlRequest.headers.add(.authorization(bearerToken: accessToken))
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
                guard let email = KeyChainManager.shared.read(key: "UserEmail") else { return } //🔨//🔨
                KeyChainManager.shared.create(key: email, token: response.result.accessToken)
                completion(.retry)
            default:
                print("🔴 updateAccessToken Success:\(statusCode)")
                completion(.doNotRetryWithError(error))
            }
        }
        
    }
}

