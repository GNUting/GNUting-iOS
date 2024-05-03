//
//  RequestModel.swift
//  GNUting
//
//  Created by 원동진 on 2/29/24.
//

import UIKit

enum RequestState {
    case waiting
    case Success
    case cacnel
    case refuse
}

extension RequestState {
    var textColor : UIColor {
        switch self {
        case .waiting:
            return UIColor(named: "979C9E") ?? .systemGray
        case .Success:
            return UIColor(named: "SecondaryColor") ?? .systemBlue
        case .cacnel:
            return UIColor(named: "PrimaryColor") ?? .systemRed
        case .refuse:
            return UIColor(named: "PrimaryColor") ?? .systemRed
        }
    }
    var backgroundColor : UIColor {
        switch self {
        case .waiting:
            return UIColor(named: "979C9E") ?? .systemGray
        case .Success:
            return UIColor(named: "SecondaryColor") ?? .systemBlue
        case .cacnel:
            return UIColor(named: "PrimaryColor") ?? .systemRed
        case .refuse:
            return UIColor(named: "PrimaryColor") ?? .systemRed
        }
    }
    var statusString: String{
        switch self {
        case .waiting:
            return "대기중"
        case .Success:
            return "수락 완료"
        case .cacnel:
            return "신청 취소"
        case .refuse:
            return "거절 완료"
        }
    }
}

