//
//  File.swift
//  GNUting
//
//  Created by 원동진 on 5/5/24.
//

import Foundation
enum AlertState {
    case enable
    case disable
}
extension AlertState {
    var status: String {
        switch self {
        case .enable:
            return "ENABLE"
        case .disable:
            return "DISABLE"
        }
    }
}
