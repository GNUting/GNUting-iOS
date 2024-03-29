//
//  ChatRoomVC.swift
//  GNUting
//
//  Created by 원동진 on 3/27/24.
//

import UIKit
import SwiftStomp
import Starscream
class ChatRoomVC: UIViewController {
    
    var chatMessageList: [ChatRoomMessageModelResult] = []{
        didSet{
            chatRoomTableView.reloadData()
        }
    }
    
    var accessToken = ""
    var chatRoomID: Int = 0
    var navigationTitle: String = "게시글 제목"
    var subTitleSting: String = "학과|학과"
    var message: String = ""
    var userName : String = ""
    private var swiftStomp : SwiftStomp!
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = subTitleSting
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 14)
        label.textColor = UIColor(hexCode: "767676")
        
        return label
    }()
    
    private lazy var borderView1 : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "E9E9E9")
        return view
    }()
    private lazy var borderView2 : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "E9E9E9")
        return view
    }()
    private lazy var chatRoomTableView : UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.register(ChatRoomTableViewSendMessageCell.self, forCellReuseIdentifier: ChatRoomTableViewSendMessageCell.identi)
        tableView.register(ChatRoomTableViewReceiveMessageCell.self, forCellReuseIdentifier: ChatRoomTableViewReceiveMessageCell.identi)
        tableView.bounces = false
        return tableView
    }()
    private lazy var textField: PaddingTextField = {
        let textField = PaddingTextField(textPadding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        textField.placeholder = "전송할 메시지를 적어주세요"
        textField.backgroundColor = UIColor(hexCode: "F5F5F5")
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.addTarget(self, action: #selector(changeValueTextField(_ :)), for: .editingChanged)
        return textField
    }()
    private lazy var sendStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        return stackView
    }()
    private lazy var sendMessageButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "SendImg"), for: .normal)
        button.addTarget(self, action: #selector(tapSendMessageButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAccessToken()
        view.backgroundColor = .white
        tabBarController?.tabBar.isHidden = true
        
        setAddSubViews()
        setAutoLayout()
        setNavigationBar()
        getChatMessageList()
        initStomp()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.swiftStomp.disconnect()
    }
}
extension ChatRoomVC{
    private func setAddSubViews() {
        view.addSubViews([subTitleLabel,borderView1,chatRoomTableView,borderView2,sendStackView])
        sendStackView.addStackSubViews([textField,sendMessageButton])
    }
    private func setAutoLayout(){
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
        borderView1.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        chatRoomTableView.snp.makeConstraints { make in
            make.top.equalTo(borderView1.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().offset(50)
        }
        sendStackView.snp.makeConstraints { make in
            make.bottom.greaterThanOrEqualTo(view.keyboardLayoutGuide.snp.top).offset(-20)
            make.left.right.equalToSuperview().inset(5)
        }
        borderView2.snp.makeConstraints { make in
            make.bottom.equalTo(sendStackView.snp.top).offset(-5)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
}

extension ChatRoomVC {
    private func setNavigationBar(){
        self.navigationController?.navigationBar.isHidden = false
        setNavigationBar(title: self.navigationTitle)
    }
}
extension ChatRoomVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return chatMessageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let sendCell = tableView.dequeueReusableCell(withIdentifier: ChatRoomTableViewSendMessageCell.identi, for: indexPath) as? ChatRoomTableViewSendMessageCell else { return UITableViewCell() }
            return sendCell
        } else {
            guard let receiveCell = tableView.dequeueReusableCell(withIdentifier: ChatRoomTableViewReceiveMessageCell.identi, for: indexPath) as? ChatRoomTableViewReceiveMessageCell else { return UITableViewCell() }
            return  receiveCell
        }
    }
    
    
}
extension ChatRoomVC {
    @objc private func tapSendMessageButton() {
//        do {
//            let encondingData = try JSONEncoder().encode(SendMessageModel(messageType: "CHAT", message: message))
//            self.swiftStomp.send(body: encondingData, to: "pub/chatRoom/\(chatRoomID)",headers: ["Authorization" : "Bearer \(accessToken)"])
//        } catch {
//            print(error)
//            
//        }
        
        swiftStomp.send(body: SendMessageModel(messageType: "CHAT", message: message), to: "/pub/chatRoom/\(chatRoomID)",headers: ["Authorization" : "Bearer \(accessToken)"])
        //        swiftStomp.send(body: message, to: "/pub/chatRoom/\(chatRoomID)",headers: ["Authorization" : "Bearer \(accessToken)"])
    }
    @objc private func changeValueTextField(_ sender: UITextField) {
        guard let textFieldText = sender.text else { return }
        self.message = textFieldText
    }
}
extension ChatRoomVC {
    private func getAccessToken(){
        guard let email = KeyChainManager.shared.read(key: "UserEmail") else { return }
        guard let token = KeyChainManager.shared.read(key: email) else { return }
        self.accessToken = token
    }
    private func initStomp(){
        let url = URL(string: "ws://localhost:8080/chat")!
        
        
        self.swiftStomp = SwiftStomp(host: url, headers: ["Authorization" : "Bearer \(accessToken)"])
        self.swiftStomp.enableLogging = true
        self.swiftStomp.delegate = self
        self.swiftStomp.connect()
    }
    private func getChatMessageList() {
        APIGetManager.shared.getChatMessageData(chatRoomID: chatRoomID) { chatMessageListData, response in
            if response.isSuccess {
                guard let result = chatMessageListData?.result else { return }
                self.chatMessageList = result
            }
        }
    }
}
extension ChatRoomVC: SwiftStompDelegate{
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
        
        if let message = message{
            
            print("message : \(message)")
        } else if let message = message as? Data{
            print("Data message with id `\(messageId)` and binary length `\(message.count)` received at destination `\(destination)`")
        }
        
        print()
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
