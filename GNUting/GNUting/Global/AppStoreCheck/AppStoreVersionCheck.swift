//
//  AppStoreVersionCheck.swift
//  GNUting
//
//  Created by 원동진 on 5/22/24.
//

import UIKit
enum VersionError: Error {
    case invalidResponse, invalidBundleInfo, readErrorBundleID
}
class AppStoreVersionCheck {
    // 현재 버전 : 타겟 -> 일반 -> Version
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let appStoreOpenUrlString = Bundle.main.downloadURL
    
    // 앱 스토어 최신 정보 확인
    
    static func isUpdateAvailable(completion: @escaping (String?, Error?) -> Void) throws -> URLSessionDataTask {
        guard let bundleID = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String else { throw VersionError.readErrorBundleID }
        guard let url = URL(string: "http://itunes.apple.com/kr/lookup?bundleId=\(bundleID)") else {
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
                print(version)
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
