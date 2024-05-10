//
//  ApplicationReceivedModel.swift
//  GNUting
//
//  Created by 원동진 on 5/8/24.
//

import Foundation

struct ApplicationReceivedModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: ApplicationStatusResult
}


