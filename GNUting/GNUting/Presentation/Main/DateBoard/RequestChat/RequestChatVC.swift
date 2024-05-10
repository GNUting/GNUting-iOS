//
//  ChatRoomListVC.swift
//  GNUting
//
//  Created by 원동진 on 2/28/24.
//

import UIKit

// MARK: - 채팅신청하기 화면

class RequestChatVC: BaseViewController{
    var boardID : Int = 0
    var chatMemeberCount: Int = 0
    
    var addMemberDataList : [UserInfosModel] = []{
        didSet {
            memberTableView.reloadData()
        }
    }
    
    
    private lazy var memberTableView : UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(MemberTableViewCell.self, forCellReuseIdentifier: MemberTableViewCell.identi)
        tableView.register(MemBerAddTableViewCell.self, forCellReuseIdentifier: MemBerAddTableViewCell.identi)
        tableView.register(MemberTableViewHeader.self, forHeaderFooterViewReuseIdentifier: MemberTableViewHeader.identi)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderTopPadding = 0
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var chatRequestCompletedButton : PrimaryColorButton = {
        let button = PrimaryColorButton()
        button.setText("채팅 신청완료",fointSize: 16)
        button.throttle(delay: 3) { _ in
            self.postRequestChat()
        }
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        setAutoLayout()
        getUserData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
}
extension RequestChatVC{
    
    private func addSubViews() {
        view.addSubViews([memberTableView,chatRequestCompletedButton])
    }
    private func setAutoLayout(){
        
        memberTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Spacing.top)
            make.left.right.equalToSuperview().inset(Spacing.UpperInset)
        }
        
        chatRequestCompletedButton.snp.makeConstraints { make in
            make.top.equalTo(memberTableView.snp.bottom).offset(Spacing.top)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-15)
        }
    }
    private func setNavigationBar(){
        setNavigationBar(title: "과팅 멤버 추가하기")
    }
}

// MARK: - DataSource

extension RequestChatVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = SearchAddMemberVC()
            vc.memberAddButtonDelegate = self
            vc.addMemberInfos = addMemberDataList
            vc.chatMemeberCount = chatMemeberCount
            vc.requestChat = true
            let navigationVC = UINavigationController.init(rootViewController: vc)
            present(navigationVC, animated: true)
            
        }
    }
}

// MARK: - Delegate

extension RequestChatVC : UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return addMemberDataList.count
        } else {
            return 1
        }
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MemberTableViewCell.identi, for: indexPath) as? MemberTableViewCell else { return UITableViewCell()}
            cell.setUserInfoViewsPost(model: addMemberDataList[indexPath.row])
            cell.selectionStyle = .none
            
            return cell
        } else {
            guard let addCell = tableView.dequeueReusableCell(withIdentifier: MemBerAddTableViewCell.identi, for: indexPath) as? MemBerAddTableViewCell else { return UITableViewCell()}
            addCell.selectionStyle = .none
            return addCell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MemberTableViewHeader.identi) as? MemberTableViewHeader else {return UIView()}
        if section == 0 {
            headerView.setMemberLabelCount(memberCount: addMemberDataList.count)
            return headerView
        }
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 1
        }
        return tableView.estimatedSectionHeaderHeight
    }
}

extension RequestChatVC {
    private func getUserData() {
        APIGetManager.shared.getUserData { userData,response  in
            self.errorHandling(response: response)
            guard let userData = userData?.result else { return }
            
            
            self.addMemberDataList.append(UserInfosModel(id: userData.id, name: userData.name, gender: userData.gender, age: userData.age, nickname: userData.nickname, department: userData.department, studentId: userData.studentId, userRole: userData.userRole, userSelfIntroduction: userData.userSelfIntroduction, profileImage: userData.profileImage))
            
        }
    }
}
extension RequestChatVC: MemberAddButtonDelegate {
    func sendAddMemberData(send: [UserInfosModel]) {
        addMemberDataList = send
    }
}
extension RequestChatVC {
    private func postRequestChat() {
        APIPostManager.shared.postRequestChat(userInfos: self.addMemberDataList, boardID: self.boardID) { response  in
            if response?.isSuccess == true {
                self.showMessagePop(message: "채팅 신청이 완료되었습니다.")
             
            } else {
                if response?.code == "APPLY4001"{
                    self.showMessage(message: "이미 신청한 유저가 존재합니다.")
                } else {
                    self.showAlert(message: response?.message ?? "고객센터에 문의하세요.")
                }
            }
        }

    }
}
