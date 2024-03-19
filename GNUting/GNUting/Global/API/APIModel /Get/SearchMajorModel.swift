//
//  SearchMajorModel.swift
//  GNUting
//
//  Created by 원동진 on 3/19/24.
//

import Foundation
struct SearchMajorModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: [SearchMajorModelResult]
}
struct SearchMajorModelResult: Codable {
    let id: Int
    let name: String
}
