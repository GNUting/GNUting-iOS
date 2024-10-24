//
//  ReportCategory.swift
//  GNUting
//
//  Created by 원동진 on 3/15/24.
//

// MARK: - 신고 종류 Model

import Foundation

enum ReportCategory {
    case COMMERCIAL_SPAM
    case ABUSIVE_LANGUAGE
    case OBSCENITY
    case FLOODING
    case PRIVACY_VIOLATION
    case OTHER
}

extension ReportCategory {
    var category: String {
        switch self {
        case .COMMERCIAL_SPAM:
            return "COMMERCIAL_SPAM"
        case .ABUSIVE_LANGUAGE:
            return "ABUSIVE_LANGUAGE"
        case .OBSCENITY:
            return "OBSCENITY"
        case .FLOODING:
            return "FLOODING"
        case .PRIVACY_VIOLATION:
            return "PRIVACY_VIOLATION"
        case .OTHER:
            return "OTHER"
        }
    }
}
