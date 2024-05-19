//
//  ChatVisibleManager.swift
//  GNUting
//
//  Created by 원동진 on 5/19/24.
//

import Foundation

class ChatVisibleManager {
    static let shared = ChatVisibleManager()
    var isChatRoom : Bool = false
    var chatRoomID: Int = 0
    private init() {}
}
