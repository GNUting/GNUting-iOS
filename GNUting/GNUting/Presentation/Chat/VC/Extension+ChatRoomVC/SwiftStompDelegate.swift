//
//  Extension+ChatRoomVC.swift
//  GNUting
//
//  Created by 원동진 on 10/7/24.
//

import UIKit
import SwiftStomp
import Starscream

extension ChatRoomVC: SwiftStompDelegate {
    func onConnect(swiftStomp: SwiftStomp, connectType: StompConnectType) {
        
        if connectType == .toSocketEndpoint{
            print("Connected to socket")
        } else if connectType == .toStomp{
            print("Connected to stomp")
            swiftStomp.subscribe(to: "/sub/chatRoom/\(chatRoomID)")
            
        }
    }
    
    func onDisconnect(swiftStomp: SwiftStomp, disconnectType: StompDisconnectType) {
        if disconnectType == .fromSocket{
            print("Socket disconnected. Disconnect completed")
        } else if disconnectType == .fromStomp{
            print("Client disconnected from stomp but socket is still connected!")
        }
    }
    
    func onMessageReceived(swiftStomp: SwiftStomp, message: Any?, messageId: String, destination: String, headers : [String : String]) {
        print("Received")
        
        if let message = message{
            let messageString = message as! String
            let messageData = Data(messageString.utf8)
            if messageString.contains("LEAVE") && messageString.contains("채팅방을 나갔습니다."){
                do {
                    
                    let jsonData = try JSONDecoder().decode(LeaveMessageModel.self, from: messageData)
                    let leaveData = ChatRoomMessageModelResult(id: 0, chatRoomId: 0, messageType: jsonData.messageType, email: nil, nickname: nil, profileImage: nil, message: jsonData.message, createdDate: "",studentId: "",department: "")
                    chatMessageList.append(leaveData)
                } catch {
                    print(error)
                }
                
            }  else {
                do {
                    let jsonData = try JSONDecoder().decode(ChatRoomMessageModelResult.self, from: messageData)
                    
                    chatMessageList.append(jsonData)
                } catch {
                    print(error)
                }
            }
        } else if let message = message as? Data{
            print("Data message with id `\(messageId)` and binary length `\(message.count)` received at destination `\(destination)`")
        }
    }
    
    func onReceipt(swiftStomp: SwiftStomp, receiptId: String) {
        print("Receipt with id `\(receiptId)` received")
    }
    
    func onError(swiftStomp: SwiftStomp, briefDescription: String, fullDescription: String?, receiptId: String?, type: StompErrorType) {
        if type == .fromSocket{
            print("Socket error occurred! [\(briefDescription)]")
        } else if type == .fromStomp{
            print("Stomp error occurred! [\(briefDescription)] : \(String(describing: fullDescription))")
        } else {
            print("Unknown error occured!")
        }
    }
    
    func onSocketEvent(eventName: String, description: String) {
        print("Socket event occured: \(eventName) => \(description)")
    }
    
}
