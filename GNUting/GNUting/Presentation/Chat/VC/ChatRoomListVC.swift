//
//  ChatRoomListVC.swift
//  GNUting
//
//  Created by 원동진 on 2/17/24.
//

// MARK: - 채팅 목록 List

import UIKit
import SwiftStomp
import Starscream

class ChatRoomListVC: BaseViewController {
    
    // MARK: - Properties
    
    var selecetedIndex: IndexPath?
    var accessToken = ""
    private var swiftStomp : SwiftStomp!
    
    var chatRoomData: [ChatRoomModelResult] = [] {
        didSet{
            noDataScreenView.isHidden = chatRoomData.isEmpty == true ? false : true
            chatTableView.reloadData()
            chatTableView.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - SubViews
    
    private lazy var noDataScreenView: NoDataScreenView = {
        let view = NoDataScreenView()
        view.isHidden = true
        view.setLabel(text: "현재 참여 중인 채팅방이 없습니다. ", range: "")
        return view
    }()
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "전체 채팅방"
        label.textAlignment = .center
        label.font = Pretendard.medium(size: 18)
        return label
    }()
    
    private lazy var chatTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.identi)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(reloadBoardListData), for: .valueChanged)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setAutoLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
        getAccessToken()
        getChatRoomData()
        initStomp()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.swiftStomp.disconnect()
    }
}

extension ChatRoomListVC{
    
    // MARK: - Layout Helpers
    private func addSubViews() {
        view.addSubViews([titleLabel, chatTableView, noDataScreenView])
    }
    private func setAutoLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        chatTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
        }
        noDataScreenView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
    }
    // MARK: - Private Logic
    
    private func checkImageString(imageArray: [String?])-> String? {
        var chatRoomTitleImageStirng: String? // 채팅리스트 대표사진, 모두 nil일경우 nil || 한명이라도 있을 경우 해당 부분
        
        for image in imageArray {
            if image != nil {
                chatRoomTitleImageStirng = image ?? ""
                return chatRoomTitleImageStirng
            }
        }
        return nil
    }
    
    private func makeUsrnameString(by usernameList: [String]) -> String{
        var usernameString = ""
        
        if usernameList.count == 1 {
            usernameString = usernameList.first ?? "닉네임"
        } else if usernameList.count == 0 {
            usernameString = "(알수없음)"
        } else {
            for (idx,username) in usernameList.enumerated() {
                usernameString += username
                if idx != usernameList.count - 1 {
                    usernameString += ", "
                }
            }
        }
        return usernameString
    }
    
    private func checkOneMatching(userListCount: Int, studentID: String?, department: String?) -> String? {
        if userListCount == 1 {
            return "\(studentID ?? "학번")학번|\(department ?? "학과")"
        } else {
            return nil
        }
    }
    
    private func changeTime(to date: String) -> String {
        let dateFormatter = DateFormatter()
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "HH:mm"
        
        
        return dateFormatter.string(from: date)
    }
}

extension ChatRoomListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatRoomVC()
        self.selecetedIndex = indexPath
        vc.chatRoomID = chatRoomData[indexPath.row].id
        pushViewContoller(viewController: vc)
    }
}

extension ChatRoomListVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return chatRoomData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identi, for: indexPath) as? ChatTableViewCell else {return UITableViewCell()}
        let cellData = chatRoomData[indexPath.row]
        let titleImage = checkImageString(imageArray: cellData.chatRoomUserProfileImages) // 대표 이미지
        let usernameString = makeUsrnameString(by: cellData.chatRoomUsers.map({$0.nickname})) // 나를 제외한 채팅방 사용자 이름 or 아무도 없을 경우 알수없음
        let otherMemberCount = cellData.chatRoomUsers.count // 나를 제외한 채팅 멤버수
        let subInfoString = checkOneMatching(userListCount: otherMemberCount, studentID: cellData.chatRoomUsers.first?.studentID, department: cellData.chatRoomUsers.first?.department)// 1대1일 경우 학번 학과
        let title = otherMemberCount == 1 ? "메모팅" : "\(otherMemberCount-1):\(otherMemberCount-1)" // 몇 대 몇인지 메모팅인지 ? // 추후 1대1 인지 메모팅인지 구분필요
        let lastMessage = cellData.lastMessage // 제일 최근 메세지
        let lastMessageTime = changeTime(to: cellData.lastMessageTime) // 제일 최근 메세지 시간
        
        
        cell.setChatTableViewCell(chatRoomUserProfileImages: titleImage, hasNewMessage: cellData.hasNewMessage, nameList: usernameString, subInfoString: subInfoString, title: title, lastMessage: lastMessage, lastMessageTime: lastMessageTime)
        
        //            cell.setChatTableViewCell(title: result.title, leaderUserDepartment: result.leaderUserDepartment, applyLeaderDepartment: result.applyLeaderDepartment, chatRoomUserProfileImages: result.chatRoomUserProfileImages, hasNewMessage: result.hasNewMessage)
        
        cell.selectionStyle = .none
        return cell
    }
    
    
}

extension ChatRoomListVC {
    private func getChatRoomData() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            APIGetManager.shared.getChatRoomData { getData, response in
                guard let getChatRoomData = getData?.result else { return }
                self.chatRoomData = getChatRoomData
                
            }
        }
    }
    @objc private func reloadBoardListData() {
        getChatRoomData()
    }
}


// MARK: - Chat

extension ChatRoomListVC {
    private func initStomp(){
        //        let url = URL(string: "ws://203.255.15.32:14357/chat")!
        let url = URL(string: "ws://203.255.15.32:1541/chat")!
        self.swiftStomp = SwiftStomp(host: url, headers: ["Authorization" : "Bearer \(accessToken)"])
        self.swiftStomp.enableLogging = true
        self.swiftStomp.delegate = self
        self.swiftStomp.connect()
    }
    private func getAccessToken(){
        guard let email = KeyChainManager.shared.read(key: "UserEmail") else { return }
        guard let token = KeyChainManager.shared.read(key: email) else { return }
        self.accessToken = token
    }
}

extension ChatRoomListVC: SwiftStompDelegate {
    func onConnect(swiftStomp: SwiftStomp, connectType: StompConnectType) {
        if connectType == .toSocketEndpoint{
            print("Connected to socket")
        } else if connectType == .toStomp{
            print("Connected to stomp")
            swiftStomp.subscribe(to: "/sub/chatRoom/update")
            
        }
    }
    
    func onDisconnect(swiftStomp: SwiftStomp, disconnectType: StompDisconnectType) {
        if disconnectType == .fromSocket{
            print("Socket disconnected. Disconnect completed")
        } else if disconnectType == .fromStomp{
            print("Client disconnected from stomp but socket is still connected!")
        }
    }
    
    func onMessageReceived(swiftStomp: SwiftStomp, message: Any?, messageId: String, destination: String, headers: [String : String]) { 
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0, execute: {
//            self.getChatRoomData()
//        })
        print("Recevied")
        if let message = message {
            let messageStirng = message as! String
            let messageData = Data(messageStirng.utf8)
            
            do {
                let jsonData = try JSONDecoder().decode([ChatRoomModelResult].self, from: messageData)
                print(jsonData)
                self.chatRoomData = jsonData
            } catch {
                print(error)
            }
            
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
