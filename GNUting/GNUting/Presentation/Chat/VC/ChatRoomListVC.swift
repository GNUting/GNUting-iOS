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
    
    var chatRoomData: ChatRoomModel? {
        didSet{
            noDataScreenView.isHidden = chatRoomData?.result.isEmpty == true ? false : true
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
    
}

extension ChatRoomListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatRoomVC()
        let result = chatRoomData?.result[indexPath.row]
        self.selecetedIndex = indexPath
        vc.chatRoomID = result?.id ?? 0
        pushViewContoller(viewController: vc)
    }
}

extension ChatRoomListVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = chatRoomData?.result.count else { return 0}
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identi, for: indexPath) as? ChatTableViewCell else {return UITableViewCell()}
      
        if let result = chatRoomData?.result[indexPath.row] {
            print(result)
//            cell.setChatTableViewCell(title: result.title, leaderUserDepartment: result.leaderUserDepartment, applyLeaderDepartment: result.applyLeaderDepartment, chatRoomUserProfileImages: result.chatRoomUserProfileImages, hasNewMessage: result.hasNewMessage)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    
}

extension ChatRoomListVC {
    private func getChatRoomData() {

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            APIGetManager.shared.getChatRoomData { getChatRoomData, response in
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
        print("Received")
        if let message = message {
            let messageStirng = message as! String
            print("messageStirng: \(messageStirng)")
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
