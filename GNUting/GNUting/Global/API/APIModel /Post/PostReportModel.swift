//
//  PostReportModel.swift
//  GNUting
//
//  Created by 원동진 on 3/15/24.
//

import Foundation

//MARK: - 신고하기

struct ReportPostModel: Codable {
    let boardId: Int
    let reportCategory: String
    let reportReason: String
}

struct ReportUserModel: Codable {
    let nickName: String
    let reportCategory: String
    let reportReason: String
}
