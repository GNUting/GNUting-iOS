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
    var isPushNotification = false
    
    var chatMessageList: [ChatRoomMessageModelResult] = []{
        didSet {
            self.chatRoomTableView.reloadData()
            self.chatRoomTableViewMoveToBottom()
        }
    }
    
    var originalPostion = CGPoint.zero
    var accessToken = ""
    var chatRoomID: Int = 0
    var navigationTitle: String?
    var subTitleSting: String?
    var message: String = ""
    var userEmail : String = ""
    var swiftStomp : SwiftStomp!
    private lazy var navigationBarView: ChatRoomNavigationBar = {
        let view = ChatRoomNavigationBar()
        
        view.naviagtionBarButtonDelegate = self
        return view
    }()
    
    private let borderView1 = BorderView()
    private let borderView2 = BorderView()
    
    private lazy var chatRoomTableView : UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.register(ChatRoomEnterTableViewCell.self, forCellReuseIdentifier: ChatRoomEnterTableViewCell.identi)
        tableView.register(ChatRoomTableViewSendMessageCell.self, forCellReuseIdentifier: ChatRoomTableViewSendMessageCell.identi)
        tableView.register(ChatRoomTableViewReceiveMessageCell.self, forCellReuseIdentifier: ChatRoomTableViewReceiveMessageCell.identi)
        tableView.register(ChatRoomDefaultTableViewCell.self, forCellReuseIdentifier: ChatRoomDefaultTableViewCell.identi)
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
        setChatKeyboardObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        getAccessToken()
        getChatRoomNavigationInfoAPI()
        getChatMessageList()
        getUserData()
        getChatRoomMember()
        getAlertSet()
        initStomp()
        isChatRoomVisible()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObserver()
        chatRoomOut()
        swiftStomp.disconnect()
        isNotificationPushed(isPush: isPushNotification)
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
        }
        
        chatRoomTableView.snp.makeConstraints { make in
            make.top.equalTo(borderView1.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(25)
        }
        
        borderView2.snp.makeConstraints { make in
            make.top.equalTo(chatRoomTableView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
        }
        
        sendStackView.snp.makeConstraints { make in
            make.top.equalTo(borderView2.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(5)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-15)
        }
        
        sideView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.right.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        textField.setContentHuggingPriority(.init(249), for: .horizontal)
        sendMessageButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        
     
    }
}
extension ChatRoomVC {
    private func setChatKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(chatKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chatKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func removeChatKeyboardObserver() { // 옵저버 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func isNotificationPushed(isPush: Bool) {
        if isPush {
            let vc = TabBarController()
            
            vc.selectedIndex = 2
            self.navigationController?.popToRootViewController(animated: true)
            view.window?.rootViewController = vc
        }
    }
    
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
        chatMessageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = chatMessageList[indexPath.row]
        
        if cellData.messageType == "CHAT" {
            if cellData.email == userEmail{
                guard let sendCell = tableView.dequeueReusableCell(withIdentifier: ChatRoomTableViewSendMessageCell.identi, for: indexPath) as? ChatRoomTableViewSendMessageCell else { return UITableViewCell() }
                sendCell.setCell(nickName: cellData.nickname ?? "(알 수 없음)", UserImage: cellData.profileImage ?? "", message: cellData.message, sendDate: cellData.createdDate)
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

// MARK: - API

extension ChatRoomVC {
    func getAccessToken(){
        guard let email = KeyChainManager.shared.read(key: "UserEmail") else { return }
        userEmail = email
        guard let token = KeyChainManager.shared.read(key: email) else { return }
        self.accessToken = token
    }
    func initStomp(){
        let url = URL(string: Bundle.main.testSocketURL)!
        self.swiftStomp = SwiftStomp(host: url, headers: ["Authorization" : "Bearer \(accessToken)"])
        self.swiftStomp.enableLogging = true
        self.swiftStomp.delegate = self
        self.swiftStomp.connect()
    }
    private func getChatMessageList() {
        APIGetManager.shared.getChatMessageData(chatRoomID: self.chatRoomID) { chatMessageListData, response in
            if response.isSuccess {
                guard let result = chatMessageListData?.result else { return }
                self.chatMessageList = result
            }
        }
    }
    private func getAlertSet() {
        APIGetManager.shared.getChatRoomSetAlertStatus(chatRoomID: chatRoomID) { response in
            guard let success = response?.isSuccess else {
                self.showAlert(message: "재시도하세요. 계속해서 문제 발생시 고객센터로 연락 부탁드립니다.")
                self.dismiss(animated: true)
                return
            }
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
    
    private func getUserData() {
        APIGetManager.shared.getUserData { userData,response  in
            self.errorHandling(response: response)
            self.sideView.userNickname = userData?.result?.nickname ?? "(알 수 없음)"
        }
    }
    
    private func getChatRoomNavigationInfoAPI() {
        APIGetManager.shared.getChatRoomNavigationInfo(chatRoomID: self.chatRoomID) { response  in
            guard let title = response?.result.title else { return }
            guard let leaderUserDepartment = response?.result.leaderUserDepartment else { return }
            guard let applyLeaderDepartment = response?.result.applyLeaderDepartment else { return }
            
            self.navigationBarView.setLabel(title: title, subTitle: "\(leaderUserDepartment) | \(applyLeaderDepartment)")
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
                } else {
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
extension ChatRoomVC: SendTappedUserData {
    func tapUserImageButton(userData: ChatRommUserModelResult?) { // 사이드뷰에서
        let vc = UserDetailVC()
        
        vc.userDetailData = UserDetailModel(imageURL: userData?.profileImage,
                                            nickname: userData?.nickname,
                                            userStudentID: userData?.studentID,
                                            userDepartment: userData?.department)
        presentViewController(viewController: vc, modalPresentationStyle: .fullScreen)
    }
    
    func tapReceivedUserImageButton(userData: ChatRoomMessageModelResult?) { // 받은메세지 유저클릭
        let vc = UserDetailVC()
        
        vc.userDetailData = UserDetailModel(imageURL: userData?.profileImage,
                                            nickname: userData?.nickname,
                                            userStudentID: userData?.studentId,
                                            userDepartment: userData?.department)
        presentViewController(viewController: vc, modalPresentationStyle: .fullScreen)
    }
}

// MARK: Action

extension ChatRoomVC {
    @objc func chatKeyboardWillShow(_ notification: Notification) { // 채팅방 버전 키보드 올림
        let offsetY = max(chatRoomTableView.contentSize.height - chatRoomTableView.bounds.size.height, 0)
        
        chatRoomTableView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true) // 스크롤을 가장 아래로 내림
    }
    
    @objc func chatKeyboardWillHide(_ notification: Notification) { // 키보드가 사라질 때 인셋을 원래대로 설정
        chatRoomTableView.contentInset.bottom = 0
        chatRoomTableView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    @objc private func tapOutSideView() {
        sideView.transform = CGAffineTransform(translationX: 0, y: 0)
        UIView.animate(withDuration: 1.0, delay: 0) {
            self.sideView.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
            self.opaqueView.isHidden = true
        }
    }
    
    @objc private func changeValueTextField(_ sender: UITextField) {
        guard let textFieldText = sender.text else { return }
        self.message = textFieldText
    }
    
    @objc private func handleCardPan(recognizer:UIPanGestureRecognizer) {
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
    
    private func tapSendMessageButton() {
        textField.text = ""
        swiftStomp.send(body: SendMessageModel(messageType: "CHAT", message: message), to: "/pub/chatRoom/\(chatRoomID)",headers: ["Authorization" : "Bearer \(accessToken)"])
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
}
