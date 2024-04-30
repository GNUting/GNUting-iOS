//
//  ReportCategory.swift
//  GNUting
//
//  Created by 원동진 on 3/15/24.
//

import Foundation
enum ReportCategory{
    case COMMERCIAL_SPAM
    case ABUSIVE_LANGUAGE
    case OBSCENITY
    case FLOODING
    case PRIVACY_VIOLATION
    case OTHER
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
