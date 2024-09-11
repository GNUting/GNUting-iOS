//
//  NoteModel.swift
//  GNUting
//
//  Created by 원동진 on 9/11/24.
//

import Foundation

struct NoteModel: Decodable {
    let isSuccess: Bool
       let code, message: String
       let result: [NoteModelData]
}

struct NoteModelData: Decodable {
    let id: Int
    let content, gender: String
}
