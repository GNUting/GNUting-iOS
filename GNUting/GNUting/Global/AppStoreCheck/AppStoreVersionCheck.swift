//
//  AppStoreVersionCheck.swift
//  GNUting
//
//  Created by 원동진 on 5/22/24.
//

import UIKit

class AppStoreVersionCheck {
    // 현재 버전 : 타겟 -> 일반 -> Version
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    // 개발자가 내부적으로 확인하기 위한 용도 : 타겟 -> 일반 -> Build
    static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    static let appStoreOpenUrlString = "https://apps.apple.com/kr/app/%EC%A7%80%EB%88%84%ED%8C%85-%EA%B2%BD%EC%83%81%EA%B5%AD%EB%A6%BD%EB%8C%80%ED%95%99%EA%B5%90-%EC%9E%AC%ED%95%99%EC%83%9D-%EC%A0%84%EC%9A%A9-%EA%B3%BC%ED%8C%85%EC%95%B1/id6502196555"
    
    // 앱 스토어 최신 정보 확인
    func latestVersion() -> String? {
        let appleID = 6502196555
        guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(appleID)&country=kr"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
              let results = json["results"] as? [[String: Any]],
              let appStoreVersion = results[0]["version"] as? String else {
            return nil
        }
        return appStoreVersion
    }
    
    // 앱 스토어로 이동 -> urlStr 에 appStoreOpenUrlString 넣으면 이동
    func openAppStore() {
        guard let url = URL(string: AppStoreVersionCheck.appStoreOpenUrlString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
