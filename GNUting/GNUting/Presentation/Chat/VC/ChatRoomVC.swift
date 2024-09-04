//
//  ChatRoomVC.swift
//  GNUting
//
//  Created by 원동진 on 3/27/24.
//

import UIKit
import SwiftStomp
import Starscream

enum CardState {
    case expanded // 펼쳐짐
    case collapsed // 접혀짐
}
class ChatRoomVC: UIViewController {
    
    var cardVisible = false
    var nextState: CardState{
        return cardVisible ? .collapsed : .expanded
    }
    var chatMessageList: [ChatRoomMessageModelResult] = []{
        didSet{
            self.chatRoomTableView.reloadData()
            self.chatRoomTableViewMoveToBottom()
        }
    }
    
    var originalPostion = CGPoint.zero
    var accessToken = ""
    var chatRoomID: Int = 0
    var navigationTitle: String = "게시글 제목"
    var subTitleSting: String = "학과*학과"
    var message: String = ""
    var userEmail : String = ""
    private var swiftStomp : SwiftStomp!
    private lazy var navigationBarView : ChatRoomNavigationBar = {
        let view = ChatRoomNavigationBar()
        view.setLabel(title: navigationTitle, subTitle: subTitleSting)
        view.naviagtionBarButtonDelegate = self
        return view
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
        tableView.register(ChatRoomDefaultTableViewCell.self, forCellReuseIdentifier: ChatRoomDefaultTableViewCell.identi)
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tap)
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
    private lazy var sendMessageButton : ThrottleButton = {
        let button = ThrottleButton()
        button.setImage(UIImage(named: "SendImg"), for: .normal)
        button.throttle(delay: 1) { _ in
            guard let textFiledText = self.textField.text else { return }
            if textFiledText != "" {
                self.tapSendMessageButton()
            }
        }
        return button
    }()
    private lazy var sideView : ChatRoomSideView = {
        let view = ChatRoomSideView()
        view.backgroundColor = .white
        view.isHidden = true
        view.leaveChatRoomButtonDelegate = self
        view.setAlertButtonDelegate = self
        view.sendTappedUserData = self
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))
        view.addGestureRecognizer(panGestureRecognizer)
        return view
    }()
    
    
    private lazy var opaqueView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
        view.frame = self.view.bounds
        view.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOutSideView))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeRecognizer()
        setAddSubViews()
        setAutoLayout()
        addExpirationRefreshToken()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        getAccessToken()
        getChatMessageList()
        getUserData()
        getChatRoomMember()
        getAlertSet()
        initStomp()
        isChatRoomVisible()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.chatRoomOut()
        self.swiftStomp.disconnect()
        
    }
}
extension ChatRoomVC{
    private func setAddSubViews() {
        view.addSubViews([navigationBarView, borderView1, chatRoomTableView, borderView2, sendStackView, sideView, opaqueView])
        sendStackView.addStackSubViews([textField,sendMessageButton])
        self.view.bringSubviewToFront(opaqueView)
        self.view.bringSubviewToFront(sideView)
    }
    private func setAutoLayout(){
        navigationBarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        borderView1.snp.makeConstraints { make in
            make.top.equalTo(navigationBarView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        chatRoomTableView.snp.makeConstraints { make in
            make.top.equalTo(borderView1.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(25)
            
        }
        sendStackView.snp.makeConstraints { make in
            make.bottom.greaterThanOrEqualTo(view.keyboardLayoutGuide.snp.top).offset(-15)
            make.left.right.equalToSuperview().inset(5)
        }
        textField.setContentHuggingPriority(.init(249), for: .horizontal)
        sendMessageButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        borderView2.snp.makeConstraints { make in
            make.top.equalTo(chatRoomTableView.snp.bottom)
            make.bottom.equalTo(sendStackView.snp.top).offset(-10)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        sideView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.right.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
    }
}
extension ChatRoomVC {
    private func chatRoomTableViewMoveToBottom() {
        let chatMessageCount = self.chatMessageList.count
        DispatchQueue.main.async {
            if chatMessageCount != 0{
                self.chatRoomTableView.scrollToRow(at: IndexPath(row: chatMessageCount - 1, section: 0), at: .bottom, animated: true)
                
            }
        }
    }
    private func isChatRoomVisible() {
        ChatVisibleManager.shared.chatRoomID = self.chatRoomID
        ChatVisibleManager.shared.isChatRoom = true
    }
    private func chatRoomOut() {
        ChatVisibleManager.shared.isChatRoom = false
    }
    private func addExpirationRefreshToken(){
        NotificationCenter.default.addObserver(self, selector: #selector(expirationRefreshToken), name: .expirationRefreshToken, object: nil)
    }

}
extension ChatRoomVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chatMessageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = chatMessageList[indexPath.row]
        
        if cellData.messageType == "CHAT" {
            if cellData.email == userEmail{
                guard let sendCell = tableView.dequeueReusableCell(withIdentifier: ChatRoomTableViewSendMessageCell.identi, for: indexPath) as? ChatRoomTableViewSendMessageCell else { return UITableViewCell() }
                sendCell.setCell(nickName: cellData.nickname ?? "닉네임", UserImage: cellData.profileImage ?? "", message: cellData.message, sendDate: cellData.createdDate)
                sendCell.setSizeToFitMessageLabel()
                sendCell.selectionStyle = .none
                return sendCell
            } else {
                guard let receiveCell = tableView.dequeueReusableCell(withIdentifier: ChatRoomTableViewReceiveMessageCell.identi, for: indexPath) as? ChatRoomTableViewReceiveMessageCell else { return UITableViewCell() }
                receiveCell.setCell(model: cellData)
                receiveCell.selectionStyle = .none
                receiveCell.closure = { tapReceiveData in
                    self.tapReceivedUserImageButton(userData: tapReceiveData)
                }
                return  receiveCell
            }
        } else if cellData.messageType == "ENTER" {
            guard let enterCell = tableView.dequeueReusableCell(withIdentifier: ChatRoomEnterTableViewCell.identi, for: indexPath) as? ChatRoomEnterTableViewCell else { return UITableViewCell() }
            enterCell.setCell(message: cellData.message, enterType: cellData.messageType)
            enterCell.setSizeToFitMessageLabel()
            enterCell.selectionStyle = .none
            return enterCell
        } else {
            guard let enterCell = tableView.dequeueReusableCell(withIdentifier: ChatRoomDefaultTableViewCell.identi, for: indexPath) as? ChatRoomDefaultTableViewCell else { return UITableViewCell() }
            enterCell.setCell(message: cellData.message, enterType: cellData.messageType)
            enterCell.setSizeToFitMessageLabel()
            enterCell.selectionStyle = .none
            return enterCell
        }
    }
    
    
}

// MARK: Button Action
extension ChatRoomVC {
    private func tapSendMessageButton() {
        textField.text = ""
        swiftStomp.send(body: SendMessageModel(messageType: "CHAT", message: message), to: "/pub/chatRoom/\(chatRoomID)",headers: ["Authorization" : "Bearer \(accessToken)"])
        
    }
    @objc private func tapOutSideView() {
        let translation = CGAffineTransform(translationX: 0, y: 0)
        sideView.transform = translation
        
        UIView.animate(withDuration: 1.0, delay: 0) {
            self.sideView.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
            self.opaqueView.isHidden = true
        }
    }
    @objc private func changeValueTextField(_ sender: UITextField) {
        guard let textFieldText = sender.text else { return }
        self.message = textFieldText
    }
    private func tapSettingButton() {
        let translation = CGAffineTransform(translationX: view.frame.width, y: 0)
        view.endEditing(true)
        sideView.transform = translation
        sideView.isHidden = false
        opaqueView.isHidden = false
        
        UIView.animate(withDuration: 1.0, delay: 0) {
            self.sideView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    @objc func handleCardPan(recognizer:UIPanGestureRecognizer) {
        let newLocation = recognizer.location(in: sideView)
        
        switch recognizer.state{
        case .began:   // Pan 시작
            originalPostion = recognizer.location(in: sideView)
        case .changed:         //Pan 하는중
            let xOffset = newLocation.x - originalPostion.x
            UIView.animate(withDuration: 0.5, delay: 0.0) {
                self.sideView.transform = CGAffineTransform(translationX: xOffset, y: 0)
            }
            recognizer.setTranslation(CGPoint.zero, in: sideView)
        case .ended: //Pan 종료
            let translation = CGAffineTransform(translationX: view.frame.width, y: 0)
            sideView.transform = translation
            opaqueView.isHidden = true
            sideView.isHidden = true
            
            setAutoLayout()
        default:
            break
        }
    }
}

// MARK: Get Data

extension ChatRoomVC {
    private func getAccessToken(){
        guard let email = KeyChainManager.shared.read(key: "UserEmail") else { return }
        userEmail = email
        guard let token = KeyChainManager.shared.read(key: email) else { return }
        self.accessToken = token
    }
    private func initStomp(){
        let url = URL(string: "ws://203.255.15.32:14357/chat")!
//        let url = URL(string: "ws://localhost:10001/chat")!
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
    private func getAlertSet() {
        APIGetManager.shared.getChatRoomSetAlertStatus(chatRoomID: chatRoomID) { response in
            guard let success = response?.isSuccess else { return self.showAlert(message: "재시도하세요. 계속해서 문제 발생시 고객센터로 연락 부탁드립니다.")}
            if success {
                
                guard let status = response?.result.notificationSetting else { return }
                self.sideView.setAlertType(alertStatus: status)
            } else {
                self.showAlert(message: response?.message ?? "오류 발생")
            }
        }
    }
    private func getChatRoomMember() {
        APIGetManager.shared.getChatRoomUserList(chatRoomID: chatRoomID) { response in
            guard let memberList = response?.result else { return }
            self.sideView.chatRommUserModelResult = memberList
        }
    }
    func getUserData(){
        APIGetManager.shared.getUserData { userData,response  in
            self.errorHandling(response: response)
            self.sideView.userNickname = userData?.result?.nickname ?? "유저 닉네임"
        }
    }
}
// MARK: - Delegate
extension ChatRoomVC: NaviagtionBarButtonDelegate {
    func tappedBackButton() {
        popButtonTap()
    }
    
    func tappedSettingButton() {
        tapSettingButton()
    }
}
extension ChatRoomVC: LeaveChatRoomButtonDelegate {
    func tapLeaveChatRoomButtonButton() {
        let alertController = UIAlertController(title: "채팅방 나가기", message: "채팅방을 나가시면 다시 들어 오실수없습니다. 채팅방을 나가시겠습니까?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "아니요", style: .destructive))
        alertController.addAction(UIAlertAction(title: "네", style: .default,handler: { _ in
            APIPostManager.shared.postLeavetChatRoom(chatRoomID: self.chatRoomID) { defaultResponse in
                if defaultResponse.isSuccess {
                    self.popButtonTap()
                }else {
                    self.errorHandling(response: defaultResponse)
                }
                
            }
        }))
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
            
        }
        
    }
}

extension ChatRoomVC: SetAlertButtonDelegate {
    func tapSetAlertButton(alertStatus: String) {
        APIPutManager.shared.putAlertNotification(alertStatus: alertStatus, chatRoomID: chatRoomID) { response in
            if !response.isSuccess{
                self.showAlert(message: response.message)
            }
        }
    }
    
}
extension ChatRoomVC: SendTappedUserData{
    func tapUserImageButton(userData: ChatRommUserModelResult?) { // 사이드뷰에서
        let vc = UserDetailVC()
        vc.imaegURL = userData?.profileImage
        vc.userNickname = userData?.nickname
        vc.userStudentID = userData?.studentID
        vc.userDepartment = userData?.department
        
        presentFullScreenVC(viewController: vc)
    }
    
    func tapReceivedUserImageButton(userData: ChatRoomMessageModelResult?) { // 받은메세지 유저클릭
        let vc = UserDetailVC()
        vc.imaegURL = userData?.profileImage
        vc.userNickname = userData?.nickname
        vc.userStudentID = userData?.studentId
        vc.userDepartment = userData?.department
        
        presentFullScreenVC(viewController: vc)
    }
}

// MARK : StompDelegate
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
