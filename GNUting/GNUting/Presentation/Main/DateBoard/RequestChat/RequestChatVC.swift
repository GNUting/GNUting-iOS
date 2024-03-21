//
//  RequestChatVC.swift
//  GNUting
//
//  Created by 원동진 on 2/28/24.
//

import UIKit
// MARK: - 채팅신청하기 화면
class RequestChatVC: UIViewController{
    var boardID : Int = 0
    
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
        
        return tableView
    }()
    
    private lazy var chatRequestCompletedButton : PrimaryColorButton = {
       let button = PrimaryColorButton()
        button.setText("채팅 신청완료")
        button.addTarget(self, action: #selector(tapRequestChatButton), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
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
            make.left.right.equalToSuperview()
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
        APIGetManager.shared.getUserData { userData in
            guard let userData = userData?.result else { return }
            guard let profileImage = userData.profileImage else { return }
            self.addMemberDataList.append(UserInfosModel(id: userData.id, name: userData.name, gender: userData.gender, age: userData.age, nickname: userData.nickname, department: userData.department, studentId: userData.studentId, userRole: userData.userRole, userSelfIntroduction: userData.userSelfIntroduction, profileImage: profileImage))
            
        }
    }
}
extension RequestChatVC: MemberAddButtonDelegate {
    func sendAddMemberData(send: [UserInfosModel]) {
        addMemberDataList = send
    }
}
extension RequestChatVC {
    @objc private func tapRequestChatButton() {
        APIPostManager.shared.postRequestChat(userInfos: self.addMemberDataList, boardID: self.boardID) { response,statusCode  in
            
            if statusCode == 200 {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "채팅 신청 완료", message: "채팅 신청이 되었습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "성공", style: .default, handler: { _ in
                        self.popButtonTap()
                    }))
                    self.present(alert, animated: true)
                }
                
            } else {
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "채팅 신청 오류", message: "\(response.message)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                    self.present(alert, animated: true)
                }
            }
        }

     
    }
}
