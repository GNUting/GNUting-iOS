//
//  GnuTingInfo++Bundle.swift
//  GNUting
//
//  Created by 원동진 on 10/10/24.
//

import Foundation

extension Bundle {
    var appID: String {
        guard let file = self.path(forResource: "GnutingInfo", ofType: "plist") else { return ""}
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let appID = resource["AppID"] as? String else { fatalError("값을 찾을수 없습니다.")}
        return appID
    }
}
