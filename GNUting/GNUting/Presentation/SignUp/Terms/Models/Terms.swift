//
//  Terms.swift
//  GNUting
//
//  Created by 원동진 on 9/5/24.
//

// MARK: 이용약관 관련 정적 배열값

import Foundation

struct Terms {
    let type: String
    let description: String
    
    static let termsArray: [Terms] = [
        Terms(type: "(필수)", description: "경상국립대학교 재학중입니다."),
        Terms(type: "(필수)", description: "개인 정보 처리 방침"),
        Terms(type: "(필수)", description: "서비스 이용약관 동의")
    ]
}
