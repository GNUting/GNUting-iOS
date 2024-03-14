//
//  WriteDateBoardVC.swift
//  GNUting
//
//  Created by 원동진 on 2/19/24.
//

import UIKit

class WriteUpdateDateBoardVC: UIViewController {
    var titleState = "글쓰기"
    let textViewPlaceHolder = "내용을 입력해주세요."
    var addMemberDataList: [SearchUserData] = [] {
        didSet {
            memberTableView.reloadData()
        }
    }
  
    private lazy var titleContentView : WrtieUpdateTitleContentView = {
        let customView = WrtieUpdateTitleContentView()
        customView.contentTextView.delegate = self
        customView.contentTextView.text = textViewPlaceHolder
        
        return customView
    }()
    private lazy var memberTableView : UITableView = {
        let tableView = UITableView()
        
        tableView.sectionHeaderTopPadding = 0
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.register(MemberTableViewCell.self, forCellReuseIdentifier: MemberTableViewCell.identi)
        tableView.register(MemBerAddTableViewCell.self, forCellReuseIdentifier: MemBerAddTableViewCell.identi)
        tableView.register(MemberTableViewHeader.self, forHeaderFooterViewReuseIdentifier: MemberTableViewHeader.identi)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        getUserData()
        addSubViews()
        setAutoLayout()
        setNavigationBar()
    }
    

}
extension WriteUpdateDateBoardVC{
    private func setNavigationBar(){
        setNavigationBar(title: "\(titleState)")
        
        let completedButton = UIButton()
        completedButton.setTitle("완료", for: .normal)
        completedButton.titleLabel?.font = UIFont(name: Pretendard.Medium.rawValue, size: 18)
        completedButton.setTitleColor(UIColor(named: "SecondaryColor"), for: .normal)
        completedButton.addTarget(self, action: #selector(tapCompletedButton), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: completedButton)
    }
    private func addSubViews() {
        view.addSubViews([titleContentView,memberTableView])
    }
    private func setAutoLayout(){
        titleContentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Spacing.top)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
//            make.height.equalTo(self.view.frame.height).dividedBy(3)
        }
        memberTableView.snp.makeConstraints { make in
            make.top.equalTo(titleContentView.snp.bottom).offset(Spacing.top)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
}
extension WriteUpdateDateBoardVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = SearchAddMemberVC()
            vc.memberAddButtonDelegate = self
            let navigationVC = UINavigationController.init(rootViewController: vc)
            navigationVC.modalPresentationStyle = .fullScreen
            present(navigationVC, animated: true)
            
        }
    }
}
extension WriteUpdateDateBoardVC: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            print(addMemberDataList.count)
            return addMemberDataList.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MemberTableViewCell.identi, for: indexPath) as? MemberTableViewCell else { return UITableViewCell()}
            cell.setUserInfoView(model: addMemberDataList[indexPath.row])
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
extension WriteUpdateDateBoardVC : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
           if textView.text == textViewPlaceHolder {
               textView.text = nil
               textView.textColor = .black
               
           }
       }

       func textViewDidEndEditing(_ textView: UITextView) {
           if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
               textView.text = textViewPlaceHolder
               textView.textColor = UIColor(hexCode: "9F9F9F")
           }
       }
}

extension WriteUpdateDateBoardVC{
    @objc private func tapCompletedButton(){
        var joinMemberID : [UserIDList] = []
        for userData in addMemberDataList {
            joinMemberID.append(UserIDList(id: userData.id))
        }
//        print(joinMemberID)
        APIPostManager.shared.postWriteText(title: titleContentView.getTitleTextFieldText() ?? "", detail: titleContentView.getContentTextViewText(), joinMemberID: joinMemberID) { statusCode in
            print(statusCode)
        }
        popButtonTap()
    }
}
extension WriteUpdateDateBoardVC{
    private func getUserData(){
        APIGetManager.shared.getUserData { userData in
            guard let userData = userData?.result else { return }
            self.addMemberDataList.append(SearchUserData(id: userData.id, name: userData.nickname, gender: userData.gender, age: userData.age, nickname: userData.nickname, department: userData.department, studentId: userData.studentId, userRole: userData.userRole, profileImage: userData.profileImage , userSelfIntroduction: userData.userSelfIntroduction))
            
        }
    }
}


extension WriteUpdateDateBoardVC {
    public func sendDetailTextData(textTuple : (String,String)) {
        titleContentView.setTitleTextFieldText(text: textTuple.0)
        titleContentView.setContentTextView(text: textTuple.1)
        titleContentView.setContentTextViewTextColor(color: .black)
    }
    
}
extension WriteUpdateDateBoardVC: MemberAddButtonDelegate {
    func sendAddMemberData(send: [SearchUserData]) {
        addMemberDataList.append(contentsOf: send)
    }
}

