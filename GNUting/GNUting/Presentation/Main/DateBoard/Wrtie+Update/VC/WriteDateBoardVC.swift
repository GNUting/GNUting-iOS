//
//  WriteDateBoardVC.swift
//  GNUting
//
//  Created by 원동진 on 2/19/24.
//

import UIKit

class WriteDateBoardVC: BaseViewController {
    let textViewPlaceHolder = "내용을 입력해주세요."
    var writeEnable : Bool = false
    var addMemberDataList: [UserInfosModel] = [] {
        didSet {
            memberTableView.reloadData()
        }
    }
  
    private lazy var titleContentView : WrtieUpdatePostTextView = {
        let customView = WrtieUpdatePostTextView()
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
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    private lazy var completedButton: ThrottleButton = {
       let button = ThrottleButton()
        button.setTitle("완료", for: .normal)
        button.isEnabled = false
        button.titleLabel?.font = Pretendard.medium(size: 18)
        button.setTitleColor(UIColor(named: "SecondaryColor"), for: .normal)
      
        
        return button
    }()
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserData()
        addSubViews()
        setAutoLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
        setCompletedButton()
    }
    

}
extension WriteDateBoardVC{
    private func setNavigationBar(){
        setNavigationBar(title: "글쓰기")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: completedButton)
    }
    private func setCompletedButton() {
        completedButton.throttle(delay: 3) { _ in
            if self.titleContentView.getTitleTextFieldText()?.count == 0 {
                self.showAlert(message: "글 제목 또는 내용을 채워주세요.")
            } else if self.titleContentView.getContentTextViewText().count == 0{
                self.showAlert(message: "글 제목 또는 내용을 채워주세요.")
            } else {
                self.tapCompletedButton()
            }
        }
    }
    private func addSubViews() {
        view.addSubViews([titleContentView, memberTableView])
    }
    private func setAutoLayout(){
        titleContentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Spacing.top)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        
        memberTableView.snp.makeConstraints { make in
            make.top.equalTo(titleContentView.snp.bottom).offset(Spacing.top)
            make.left.right.equalToSuperview().inset(Spacing.horizontalSpacing27)
            
            make.height.equalToSuperview().dividedBy(2)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
}

// MARK: - DataSource

extension WriteDateBoardVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = SearchAddMemberVC()
            
            vc.searchAddMemberVCDelegate = self
            vc.setProperties(pushRequestChatVC: false, addMemberInfos: addMemberDataList)
            presentViewController(viewController: vc)
        }
    }
}

// MARK: - Delegate

extension WriteDateBoardVC : UITextViewDelegate{
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
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range,in: currentText) else { return false}
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        return changedText.count <= 300
    }
}

extension WriteDateBoardVC: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
// MARK: - Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return addMemberDataList.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MemberTableViewCell.identi, for: indexPath) as? MemberTableViewCell else { return UITableViewCell()}
            cell.setUserInfoViews(model: addMemberDataList[indexPath.row])
            cell.selectionStyle = .none
            return cell
        } else {
            guard let addCell = tableView.dequeueReusableCell(withIdentifier: MemBerAddTableViewCell.identi, for: indexPath) as? MemBerAddTableViewCell else { return UITableViewCell()}
            addCell.selectionStyle = .none
            return addCell
        }
    }
    
// MARK: - Header
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

// MARK: - ButtonAction

extension WriteDateBoardVC{
    private func tapCompletedButton(){
        var joinMemberID : [UserIDList] = []
        
        for userData in addMemberDataList {
            joinMemberID.append(UserIDList(id: userData.id))
        }
        if joinMemberID.count == 1 {
            self.showMessage(message: "과팅 게시판 이용은 2명 이상부터 가능합니다.")
        } else {
            APIPostManager.shared.postWriteText(title: titleContentView.getTitleTextFieldText() ?? "", detail: titleContentView.getContentTextViewText(), joinMemberID: joinMemberID) { response in
                if response.isSuccess {
                    self.showMessagePop(message: "게시물 작성이 완료되었습니다.")
                } else {
                    self.errorHandling(response: response)
                }
            }
        }
     
        
    }
}
extension WriteDateBoardVC{
    private func getUserData(){
        APIGetManager.shared.getUserData { userData,response  in
            self.errorHandling(response: response)
            guard let userData = userData?.result else { return }
            self.addMemberDataList.append(UserInfosModel(id: userData.id, name: userData.nickname, gender: userData.gender, age: userData.age, nickname: userData.nickname, department: userData.department, studentId: userData.studentId, userRole: userData.userRole, userSelfIntroduction: userData.userSelfIntroduction, profileImage: userData.profileImage))
            
        }
    }
}


extension WriteDateBoardVC {
    func sendDetailTextData(textTuple : (String,String)) {
        titleContentView.setTitleTextFieldText(text: textTuple.0)
        titleContentView.setContentTextView(text: textTuple.1)
        titleContentView.setContentTextViewTextColor(color: .black)
    }
    
}
extension WriteDateBoardVC: SearchAddMemberVCDelegate {
    func sendAddMemberData(send: [UserInfosModel]) {
        addMemberDataList = send
    }
    
}

