//
//  NotePostModel.swift
//  GNUting
//
//  Created by 원동진 on 9/12/24.
//

import Foundation

struct NotePostModel: Encodable {
    let content: String
}

struct NoteApplyModel: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: NoteApplyModelData
}

struct NoteApplyModelData: Decodable {
    let chatId: Int
}
