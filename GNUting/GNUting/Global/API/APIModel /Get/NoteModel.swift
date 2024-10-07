//
//  NoteModel.swift
//  GNUting
//
//  Created by 원동진 on 9/11/24.
//

import Foundation

struct NoteGetModel: Decodable {
    let isSuccess: Bool
    let code, message: String
    let result: [NoteModelData]
}

struct NoteModelData: Decodable {
    let id: Int
    let content, gender: String
}

struct NoteApplRemainModel: Decodable {
    let isSuccess: Bool
    let code, message: String
    let result: Int
}


