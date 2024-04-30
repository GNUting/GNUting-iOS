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
            self.chatRoomTableView.reloadData()
            self.chatRoomTableViewMoveToBottom()
        }
    }
    
    var accessToken = ""
    var chatRoomID: Int = 0
    var navigationTitle: String = "게시글 제목"
    var subTitleSting: String = "학과|학과"
    var message: String = ""
    var userEmail : String = ""
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
        tableView.register(ChatRoomEnterTableViewCell.self, forCellReuseIdentifier: ChatRoomEnterTableViewCell.identi)
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
    private lazy var leaveChatButton : BoardSettingButton = {
        let button = BoardSettingButton()
        button.setButton(text: "채팅방 나가기")
        button.addTarget(self, action: #selector(tapLeaveChatRoom), for: .touchUpInside)
        button.isHidden = true
        button.backgroundColor = UIColor(hexCode: "EEEEEE")
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
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
        view.addSubViews([subTitleLabel,borderView1,chatRoomTableView,borderView2,sendStackView,leaveChatButton])
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
            
        }
        sendStackView.snp.makeConstraints { make in
            make.bottom.greaterThanOrEqualTo(view.keyboardLayoutGuide.snp.top)
            make.left.right.equalToSuperview().inset(5)
        }
        borderView2.snp.makeConstraints { make in
            make.top.equalTo(chatRoomTableView.snp.bottom)
            make.bottom.equalTo(sendStackView.snp.top).offset(-5)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        leaveChatButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        self.view.bringSubviewToFront(leaveChatButton)
    }
    
}

extension ChatRoomVC {
    private func setNavigationBar(){
        self.navigationController?.navigationBar.isHidden = false
        setNavigationBar(title: self.navigationTitle)
        let settingButton = UIBarButtonItem(image: UIImage(named: "SettingButton"), style: .plain, target: self, action: #selector(tapSettingButton(_ :)))
        settingButton.tintColor = UIColor(named: "IconColor")
        self.navigationItem.rightBarButtonItem = settingButton
    }
    private func chatRoomTableViewMoveToBottom() {
        let chatMessageCount = self.chatMessageList.count
        DispatchQueue.main.async {
            if chatMessageCount != 0{
                self.chatRoomTableView.scrollToRow(at: IndexPath(row: chatMessageCount - 1, section: 0), at: .bottom, animated: true)
            }
        }
    }
}
extension ChatRoomVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chatMessageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = chatMessageList[indexPath.row]
        if cellData.email == userEmail{
            guard let sendCell = tableView.dequeueReusableCell(withIdentifier: ChatRoomTableViewSendMessageCell.identi, for: indexPath) as? ChatRoomTableViewSendMessageCell else { return UITableViewCell() }
            sendCell.setCell(nickName: cellData.nickname ?? "닉네임", UserImage: cellData.profileImage ?? "", message: cellData.message, sendDate: cellData.createdDate)
            return sendCell
        } else if cellData.email == nil{
            guard let enterCell = tableView.dequeueReusableCell(withIdentifier: ChatRoomEnterTableViewCell.identi, for: indexPath) as? ChatRoomEnterTableViewCell else { return UITableViewCell() }
            enterCell.setCell(message: cellData.message)
            return enterCell
        } else {
            guard let receiveCell = tableView.dequeueReusableCell(withIdentifier: ChatRoomTableViewReceiveMessageCell.identi, for: indexPath) as? ChatRoomTableViewReceiveMessageCell else { return UITableViewCell() }
            receiveCell.setCell(nickName: cellData.nickname ?? "닉네임", UserImage: cellData.profileImage ?? "", message: cellData.message, sendDate: cellData.createdDate)
            return  receiveCell
        }
    }
    
    
}
extension ChatRoomVC {
    @objc private func tapSendMessageButton() {
        textField.text = ""
        swiftStomp.send(body: SendMessageModel(messageType: "CHAT", message: message), to: "/pub/chatRoom/\(chatRoomID)",headers: ["Authorization" : "Bearer \(accessToken)"])
        
    }
    @objc private func changeValueTextField(_ sender: UITextField) {
        guard let textFieldText = sender.text else { return }
        self.message = textFieldText
    }
    @objc private func tapSettingButton(_ sender: UIButton){
        sender.isSelected.toggle()
        if sender.isSelected{
            leaveChatButton.isHidden = false
        }else{
            leaveChatButton.isHidden = true
        }
    }
    @objc private func tapLeaveChatRoom() {
        APIPostManager.shared.postLeavetChatRoom(chatRoomID: chatRoomID) { defaultResponse in
            let alertController = UIAlertController(title: "채팅방 나가기", message: "채팅방을 나가시면 다시 들어 오실수없습니다. 채팅방을 나가시겠습니까?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "확인", style: .default,handler: { _ in
                self.popButtonTap()
                self.leaveChatButton.isHidden = true
            }))
            alertController.addAction(UIAlertAction(title: "취소", style: .cancel))
            DispatchQueue.main.async {
                self.present(alertController, animated: true)
                
            }
        }
    }
}
extension ChatRoomVC {
    private func getAccessToken(){
        guard let email = KeyChainManager.shared.read(key: "UserEmail") else { return }
        userEmail = email
        guard let token = KeyChainManager.shared.read(key: email) else { return }
        self.accessToken = token
    }
    private func initStomp(){
        let url = URL(string: "ws://203.255.3.66:10001/chat")!
        
        
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
        print("Received")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.getChatMessageList()
        }
        
        if let message = message{
            
//
            var stringMessage = message as! String
            stringMessage = stringMessage.replacingOccurrences(of: "\"", with: "")
            stringMessage = stringMessage.replacingOccurrences(of: "{", with: "")
            stringMessage = stringMessage.replacingOccurrences(of: "}", with: "")
            
            let messageArr = stringMessage.split(separator: ",")
            var contentArr : [String] = []

//            for content in messageArr{
//                let splitContent = content.split(separator: ":").map{String($0)}
//                if splitContent[0] == "profileImage"{
//                    contentArr.append(splitContent[1]+splitContent[2])
//                } else if splitContent[0] == "createdDate"{
//                    contentArr.append(splitContent[1]+splitContent[2]+splitContent[3])
//                } else{
//                    contentArr.append(splitContent[1])
//                }
//            }
            
//            let messagStruct = ChatRoomMessageModelResult(id: Int(contentArr[0]) ?? 0, chatRoomId: Int(contentArr[1]) ?? self.chatRoomID, messageType: contentArr[2], email: contentArr[3], nickname: contentArr[4], profileImage: contentArr[5], message: contentArr[6], createdDate: contentArr[7])
//            self.chatMessageList.append(messagStruct)
            
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
