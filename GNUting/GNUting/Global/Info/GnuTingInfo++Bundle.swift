//
//  GnuTingInfo++Bundle.swift
//  GNUting
//
//  Created by 원동진 on 10/10/24.
//

import Foundation

extension Bundle {
    private func getValue(key: String) -> String {
        guard let file = self.path(forResource: "GnutingInfo", ofType: "plist") else { return ""}
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let value = resource[key] as? String else { fatalError("\(key)를 찾을수 없습니다.")}
        return value
    }
    
    var downloadURL: String {
        return getValue(key: "AppStoreDownloadURL")
    }
    
    var baseURL: String {
        return getValue(key: "BaseURL")
    }
    
    var socketURL: String {
        return getValue(key: "SocketURL")
    }
    
    var  testBaseURL: String {
        return getValue(key: "TestBaseURL")
    }
    
    var testSocketURL: String {
        return getValue(key: "TestSocketURL")
    }
}
