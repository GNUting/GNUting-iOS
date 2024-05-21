//
//  ChatRoomListVC.swift
//  GNUting
//
//  Created by 원동진 on 2/17/24.
//

import UIKit

class ChatRoomListVC: BaseViewController {
    var userName : String = ""
    var chatRoomData: ChatRoomModel? {
        didSet{
            if chatRoomData?.result.count == 0 {
                noDataScreenView.isHidden = false
            } else {
                noDataScreenView.isHidden = true
            }
            chatTableView.reloadData()
         
            chatTableView.refreshControl?.endRefreshing()
        }
    }
 
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
        label.font = UIFont(name: Pretendard.Medium.rawValue, size: 18)
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
        getChatRoomData()
    }
    
}
extension ChatRoomListVC{
    private func addSubViews() {
        view.addSubViews([titleLabel,chatTableView,noDataScreenView])
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
        
        vc.chatRoomID = result?.id ?? 0
        vc.navigationTitle = result?.title ?? "채팅방"
        vc.subTitleSting = "\(result?.leaderUserDepartment ?? "학과") | \(result?.applyLeaderDepartment ?? "학과")"
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
            cell.setChatTableViewCell(title: result.title, leaderUserDepartment: result.leaderUserDepartment, applyLeaderDepartment: result.applyLeaderDepartment, chatRoomUserProfileImages: result.chatRoomUserProfileImages, hasNewMessage: result.hasNewMessage)
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
extension ChatRoomListVC {
    func AlertpushChatRoom(locationID: String) {
        let chatRoomID = Int(locationID)
        let vc = ChatRoomVC()
        APIGetManager.shared.getApplicationChatRoomTitleData(chatRoomID: chatRoomID ?? 0) { responseResult in
            guard let success = responseResult?.isSuccess else { return }
            let rootVC = UIApplication.shared.connectedScenes.compactMap{$0 as? UIWindowScene}.first?.windows.filter{$0.isKeyWindow}.first?.rootViewController as? UITabBarController
          
            if success {
                vc.chatRoomID = chatRoomID ?? 0
                vc.navigationTitle = responseResult?.result.title ?? "채팅방 제목"
                
                vc.subTitleSting = "\(responseResult?.result.leaderUserDepartment ?? "학과") | \(responseResult?.result.applyLeaderDepartment ?? "학과")"
                
                self.pushViewContoller(viewController: vc)
            } else {
                if responseResult?.code == "CHATROOM4001"{
                    self.showAlert(message: "채팅방을 찾을수 없습니다.")
                } else if responseResult?.code == "CHATROOMUSER4001"{
                    self.showAlert(message: "채팅방을 찾을수 없습니다.")
                }
                rootVC?.selectedIndex = 0
            }
            
        } 
    }
}

