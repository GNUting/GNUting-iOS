//
//  ChatRoomListVC.swift
//  GNUting
//
//  Created by 원동진 on 2/28/24.
//

// MARK: - 과팅 게시글 - 채팅 신청하기 화면 ViewController

import UIKit

final class RequestChatVC: BaseViewController {
    
    // MARK: - Properties
    
    var boardID: Int = 0
    var chatMemeberCount: Int = 0
    private var addMemberDataList: [UserInfosModel] = []{
        didSet {
            memberTableView.reloadData()
        }
    }
    
    private lazy var memberTableView: UITableView = {
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
    
    private lazy var chatRequestCompletedButton: PrimaryColorButton = {
        let button = PrimaryColorButton()
        button.setText("채팅 신청완료",fointSize: 16)
        button.throttle(delay: 3) { _ in
            self.postRequestChatAPI()
        }
        
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        setAutoLayout()
        getUserDataAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar()
    }
}

extension RequestChatVC{
    
    // MARK: - Layout Helpers
    
    private func addSubViews() {
        view.addSubViews([memberTableView, chatRequestCompletedButton])
    }
    
    private func setAutoLayout() {
        memberTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Spacing.top)
            make.left.right.equalToSuperview().inset(Spacing.size27)
        }
        
        chatRequestCompletedButton.snp.makeConstraints { make in
            make.top.equalTo(memberTableView.snp.bottom).offset(Spacing.top)
            make.left.right.equalToSuperview().inset(Spacing.size25)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-15)
        }
    }
    
    // MARK: - SetView
    
    private func setNavigationBar() {
        setNavigationBar(title: "과팅 멤버 추가하기")
    }
}

// MARK: - API

extension RequestChatVC {
    private func getUserDataAPI() {
        APIGetManager.shared.getUserData { userData,response  in
            self.errorHandling(response: response)
            guard let userData = userData?.result else { return }
            self.addMemberDataList.append(UserInfosModel(id: userData.id, name: userData.name, gender: userData.gender, age: userData.age, nickname: userData.nickname, department: userData.department, studentId: userData.studentId, userRole: userData.userRole, userSelfIntroduction: userData.userSelfIntroduction, profileImage: userData.profileImage))
        }
    }
    
    private func postRequestChatAPI() {
        APIPostManager.shared.postRequestChat(userInfos: self.addMemberDataList, boardID: self.boardID) { response  in
            switch response?.code {
            case "COMMON200":
                self.showAlertNavigationBack(message: "채팅 신청이 완료되었습니다.",backType: .pop)
            case "APPLY4001":
                self.showAlert(message: "이미 신청한 유저가 존재합니다.")
            default:
                self.showAlert(message: response?.message ?? "고객센터에 문의하세요.")
            }
        }
    }
}

// MARK: - UITalbeView DataSource

extension RequestChatVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? addMemberDataList.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell =  UITableViewCell()
        
        switch indexPath.section {
        case 0:
            guard let defaultCell = tableView.dequeueReusableCell(withIdentifier: MemberTableViewCell.identi, for: indexPath) as? MemberTableViewCell else { return UITableViewCell()}
            defaultCell.setUserInfoViewsPost(model: addMemberDataList[indexPath.row])
            cell = defaultCell
        case 1:
            guard let addCell = tableView.dequeueReusableCell(withIdentifier: MemBerAddTableViewCell.identi, for: indexPath) as? MemBerAddTableViewCell else { return UITableViewCell()}
            cell = addCell
        default:
            print("UnExpoected Section : \(indexPath.section)")
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK: - Delegate

extension RequestChatVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = SearchAddMemberVC()
            
            vc.searchAddMemberVCDelegate = self
            vc.setProperties(pushRequestChatVC: true, addMemberInfos: addMemberDataList,chatMemeberCount: chatMemeberCount)
            presentViewController(viewController: vc)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MemberTableViewHeader.identi) as? MemberTableViewHeader else {return UIView()}
        headerView.setMemberLabelCount(memberCount: addMemberDataList.count)
        
        return section == 0 ? headerView : UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 1 : tableView.estimatedSectionHeaderHeight
    }
}

extension RequestChatVC: SearchAddMemberVCDelegate {
    func sendAddMemberData(send: [UserInfosModel]) {
        addMemberDataList = send
    }
}
