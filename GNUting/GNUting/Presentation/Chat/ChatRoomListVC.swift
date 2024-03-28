//
//  ChatVC.swift
//  GNUting
//
//  Created by 원동진 on 2/17/24.
//

import UIKit

class ChatVC: UIViewController {
    var chatRoomData: ChatRoomModel? {
        didSet{
            chatTableView.reloadData()
        }
    }
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "전체 채팅방"
        label.font = UIFont(name: Pretendard.Bold.rawValue, size: 22)
        return label
    }()
    
    private lazy var chatTableView : UITableView = {
       let tableView = UITableView()
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.identi)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        addSubViews()
        setAutoLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        getChatRoomData()
    }
}
extension ChatVC{
    private func addSubViews() {
        view.addSubViews([titleLabel,chatTableView])
    }
    private func setAutoLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(20)
        }
        chatTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
        }
    }
    
}

extension ChatVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatRoomVC()
        let result = chatRoomData?.result[indexPath.row]
        vc.chatRoomID = result?.id ?? 0
        vc.navigationTitle = result?.title ?? "채팅방"
        vc.subTitleSting = "\(result?.leaderUserDepartment ?? "학과") | \(result?.applyLeaderDepartment ?? "학과")"
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ChatVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRoomData?.result.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identi, for: indexPath) as? ChatTableViewCell else {return UITableViewCell()}
        if let result = chatRoomData?.result[indexPath.row] {
            cell.setChatTableViewCell(title: result.title, leaderUserDepartment: result.leaderUserDepartment, applyLeaderDepartment: result.applyLeaderDepartment, newChatMessage: "메세지없음")
        }
        return cell
    }
    
    
}


extension ChatVC {
    private func getChatRoomData() {
        APIGetManager.shared.getChatRoomData { getChatRoomData, response in
            self.chatRoomData = getChatRoomData
            
        }
    }
}