//
//  AppStoreVersionCheck.swift
//  GNUting
//
//  Created by 원동진 on 5/22/24.
//

import UIKit
enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
}
class AppStoreVersionCheck {
    // 현재 버전 : 타겟 -> 일반 -> Version
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    // 개발자가 내부적으로 확인하기 위한 용도 : 타겟 -> 일반 -> Build
    static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    static let appStoreOpenUrlString = "https://apps.apple.com/kr/app/%EC%A7%80%EB%88%84%ED%8C%85-%EA%B2%BD%EC%83%81%EA%B5%AD%EB%A6%BD%EB%8C%80%ED%95%99%EA%B5%90-%EC%9E%AC%ED%95%99%EC%83%9D-%EC%A0%84%EC%9A%A9-%EA%B3%BC%ED%8C%85%EC%95%B1/id6502196555"
    
    // 앱 스토어 최신 정보 확인
    
    static func isUpdateAvailable(completion: @escaping (String?, Error?) -> Void) throws -> URLSessionDataTask {
        let identifier = 6502196555
        guard let url = URL(string: "http://itunes.apple.com/kr/lookup?bundleId=\(identifier)") else {
            throw VersionError.invalidBundleInfo
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                guard let result = (json?["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String else {
                    throw VersionError.invalidResponse
                } // 앱스토어 버전 가져오기
                
                completion(version, nil)
                // true is needUpdate
                // false is latest version
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
        return task
    }
    // 앱 스토어로 이동 -> urlStr 에 appStoreOpenUrlString 넣으면 이동
    func openAppStore() {
        guard let url = URL(string: AppStoreVersionCheck.appStoreOpenUrlString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
