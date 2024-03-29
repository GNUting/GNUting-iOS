//
//  ChatRoomVC.swift
//  GNUting
//
//  Created by 원동진 on 3/27/24.
//

import UIKit
import Starscream
class ChatRoomVC: UIViewController {
    
    
    var chatRoomID: Int = 0
    var navigationTitle: String = "게시글 제목"
    var subTitleSting: String = "학과|학과"
    
    var socket: WebSocket!
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
        return tableView
    }()
    private lazy var textField: PaddingTextField = {
        let textField = PaddingTextField(textPadding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        textField.placeholder = "전송할 메시지를 적어주세요"
        textField.backgroundColor = UIColor(hexCode: "F5F5F5")
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
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
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connect()
        view.backgroundColor = .white
        setAddSubViews()
        setAutoLayout()
        setNavigationBar()
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disconnect()
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
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
    func connect() {
        let url = URL(string: "ws://localhost:8080/chat")!
        guard let email = KeyChainManager.shared.read(key: "UserEmail") else { return }
        guard let accessToken = KeyChainManager.shared.read(key: email) else { return }
        //
        var request = URLRequest(url: url)

        request.timeoutInterval = 5
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        socket = WebSocket(request: request)
        
        socket.delegate = self
        socket.connect()
        
    }
    func disconnect() {
        socket?.disconnect()
    }
}

extension ChatRoomVC: WebSocketDelegate {
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocketClient) {
        print("event:\(event)")
        
        switch event{
        case .viabilityChanged:
            print("[Websocket] Viability changed")
        case .connected(_):
            
            print("[WebSocket] Connected")
            socket?.write(string: "dongjin")
  
        case .disconnected(let reason,let code):
            print("[Websocket] Disconnected")
            print("\(reason) with code \(code)")
        case .text(let text):
            do {
                let result = try JSONDecoder().decode(ChatRoomModel.self, from: Data(text.utf8))
                print(result)
            } catch {
                print(error)
            }
        case .binary(_): break
            
        case .error(let error):
            print("[WebSocket] Error")
            print(String(describing: error))
            
            
            
        case .reconnectSuggested(_):
            print("[Websocket] reconnectSuggested")
            
        case .cancelled:
            print("[Websocket] cancelled")
            
        default:
            print("[WebSocket] Did receive something")
        }
    }
    
    
}
//
