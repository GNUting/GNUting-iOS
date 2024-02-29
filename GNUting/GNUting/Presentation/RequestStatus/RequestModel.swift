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
    case Failure
}

extension RequestState {
    var backgroundColor : UIColor {
        switch self {
        case .waiting:
            return UIColor(named: "PrimaryColor") ?? .systemRed
        case .Success:
            return UIColor(named: "SecondaryColor") ?? .systemBlue
        case .Failure:
            return UIColor(named: "979C9E") ?? .systemGray
        }
    }
}

