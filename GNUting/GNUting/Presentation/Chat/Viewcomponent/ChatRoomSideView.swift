//
//  ChatRoomSideView.swift
//  GNUting
//
//  Created by 원동진 on 5/5/24.
//

import UIKit
protocol LeaveChatRoomButtonDelegate : AnyObject {
    func tapLeaveChatRoomButtonButton()
}
protocol SetAlertButtonDelegate : AnyObject {
    func tapSetAlertButton(alertStatus: String)
}
protocol SendTappedUserData: AnyObject {
    func tapUserImageButton(userData: ChatRommUserModelResult?)
}
class ChatRoomSideView: UIView {

    var chatRommUserModelResult:  [ChatRommUserModelResult] = []{
        didSet {
            ChatRoomMemberTableView.reloadData()
        }
    }
    var userNickname: String = ""
    var sendTappedUserData: SendTappedUserData?
    var leaveChatRoomButtonDelegate: LeaveChatRoomButtonDelegate?
    var setAlertButtonDelegate: SetAlertButtonDelegate?
    var alertStatus: Bool = false

    private lazy var topViewLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont(name: Pretendard.Medium.rawValue, size: 14)
        label.text = "대화상대"
        return label
    }()
    private lazy var borderView = BorderView()
    private lazy var ChatRoomMemberTableView : UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(ChatRoomMemberTableViewCell.self, forCellReuseIdentifier: ChatRoomMemberTableViewCell.identi)
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    private lazy var bottomView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(hexCode: "F5F5F5")
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        
        return view
    }()
    private lazy var leaveChatRoomButton : UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "LeaveChatRoomImage"), for: .normal)
        button.addTarget(self, action: #selector(tapLeaveChatRoomButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var setAlertButton : UIButton = {
        let button = UIButton()
         button.setImage(UIImage(named: "ChatRoomOnBellImage"), for: .normal)
        button.addTarget(self, action: #selector(tapSetAlertButton), for: .touchUpInside)
         return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ChatRoomSideView {
    private func setAddSubViews() {
        addSubViews([topViewLabel,borderView,ChatRoomMemberTableView,bottomView])
        bottomView.addSubViews([leaveChatRoomButton,setAlertButton])
    }
    private func setAutoLayout(){
        topViewLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.right.equalToSuperview().inset(15)
        }
        borderView.snp.makeConstraints { make in
            make.top.equalTo(topViewLabel.snp.bottom).offset(18)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        ChatRoomMemberTableView.snp.makeConstraints { make in
            make.top.equalTo(borderView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
        }
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(ChatRoomMemberTableView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(85)
            make.bottom.equalToSuperview()
        }
        leaveChatRoomButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(25)
        }
        setAlertButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalTo(leaveChatRoomButton.snp.right).offset(15)
            
        }
    }
}

extension ChatRoomSideView {
    func setAlertType(alertStatus : String) {
        if alertStatus == "ENABLE" {
            setAlertButton.setImage(UIImage(named: "ChatRoomOnBellImage"), for: .normal)
            self.alertStatus = true
        } else {
            self.alertStatus = false
            setAlertButton.setImage(UIImage(named: "ChatRoomOffBellImage"), for: .normal)
        }
            
    }
}

extension ChatRoomSideView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chatRommUserModelResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatRoomMemberTableViewCell.identi, for: indexPath) as? ChatRoomMemberTableViewCell else { return UITableViewCell() }
        cell.closure = { userData in
            self.sendTappedUserData?.tapUserImageButton(userData: userData)
        }
        if userNickname == chatRommUserModelResult[indexPath.row].nickname {
            cell.showMarkMeImaegView()
        }
        
        cell.setCell(model: chatRommUserModelResult[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    
}


// MARK : @objc
extension ChatRoomSideView {
    @objc private func tapLeaveChatRoomButton() {
        leaveChatRoomButtonDelegate?.tapLeaveChatRoomButtonButton()
    }
    @objc private func tapSetAlertButton() {
        if alertStatus {
            alertStatus = false
            setAlertButton.setImage(UIImage(named: "ChatRoomOffBellImage"), for: .normal)
            setAlertButtonDelegate?.tapSetAlertButton(alertStatus: "DISABLE")
        } else {
            alertStatus = true
            setAlertButton.setImage(UIImage(named: "ChatRoomOnBellImage"), for: .normal)
            setAlertButtonDelegate?.tapSetAlertButton(alertStatus: "ENABLE")
        }
    }
}

