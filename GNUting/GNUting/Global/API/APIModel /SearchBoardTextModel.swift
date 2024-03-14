//
//  SearchBoardTextModel.swift
//  GNUting
//
//  Created by 원동진 on 3/13/24.
//

import Foundation
struct SearchBoardTextModel: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: SearchResult
}
struct SearchResult: Codable {
    let content: [SearchResultContent]
    let pageable: Pageable
    let last: Bool
    let totalPages, totalElements: Int
    let first: Bool
    let size, number: Int
    let sort: Sort
    let numberOfElements: Int
    let empty: Bool
}
// MARK: - Content
struct SearchResultContent: Codable {
    let boardID: Int
    let title, department, studentID: String

    enum CodingKeys: String, CodingKey {
        case boardID = "boardId"
        case title, department
        case studentID = "studentId"
    }
}

// MARK: - Pageable
struct Pageable: Codable {
    let sort: Sort
    let offset, pageNumber, pageSize: Int
    let paged, unpaged: Bool
}

// MARK: - Sort
struct Sort: Codable {
    let empty, unsorted, sorted: Bool
}
