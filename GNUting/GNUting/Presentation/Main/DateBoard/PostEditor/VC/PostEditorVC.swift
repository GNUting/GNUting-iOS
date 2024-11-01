//
//  WriteDateBoardVC.swift
//  GNUting
//
//  Created by 원동진 on 2/19/24.
//

// MARK: - 게시글 작성 ViewController

import UIKit

final class PostEditorVC: BaseViewController {
    
    // MARK: - Properties
    
    var isEditingMode: Bool = false // true : 수정, false: 글쓰기
    var boardID: Int = 0
    var memberList: [UserInfosModel] = [] {
        didSet {
            memberTableView.reloadData()
        }
    }
    
    // MARK: - SubViews
    
    private lazy var contentView: WriteUpdatePostTextView = {
        let view = WriteUpdatePostTextView()
        view.wrtieUpdatePostTextViewDelegate = self
        
        return view
    }()
    
    private lazy var memberTableView: UITableView = {
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
        button.throttle(delay: 3) { _ in
            self.completedButtonAction()
        }
        
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAddSubViews()
        setAutoLayout()
        setNavigationBar(isEditingMode: isEditingMode)
        getUserDataAPI(isEditingMode: isEditingMode)
    }
}

extension PostEditorVC {
    
    // MARK: - Layout Helpers
    
    private func setAddSubViews() {
        view.addSubViews([contentView, memberTableView])
    }
    
    private func setAutoLayout() {
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Spacing.top)
            make.left.right.equalToSuperview().inset(Spacing.size25)
        }
        
        memberTableView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(Spacing.top)
            make.left.right.equalToSuperview().inset(Spacing.size27)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalToSuperview().dividedBy(2)
        }
    }
    
    // MARK: - SetView
    
    private func setNavigationBar(isEditingMode: Bool) {
        setNavigationBar(title: isEditingMode ? "수정하기" : "글쓰기")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: completedButton)
    }
    
    private func addMemberID() -> [UserIDList] {
        var joinMemberIDList: [UserIDList] = []
        
        for userData in memberList {
            joinMemberIDList.append(UserIDList(id: userData.id))
        }
        return joinMemberIDList
    }
    
    func setPostTestView(title: String, content: String){
        contentView.setTitleTextFieldText(text: title)
        contentView.setContentTextView(text: content)
        contentView.content = content
    }
}

// MARK: - API

extension PostEditorVC  {
    private func getUserDataAPI(isEditingMode: Bool) {
        if !isEditingMode {
            APIGetManager.shared.getUserData { userData,response  in
                self.errorHandling(response: response)
                guard let userData = userData?.result else { return }
                self.memberList.append(UserInfosModel(id: userData.id,
                                                             name: userData.nickname,
                                                             gender: userData.gender,
                                                             age: userData.age,
                                                             nickname: userData.nickname,
                                                             department: userData.department,
                                                             studentId: userData.studentId,
                                                             userRole: userData.userRole,
                                                             userSelfIntroduction: userData.userSelfIntroduction,
                                                             profileImage: userData.profileImage))
            }
        }
  
    }
    
    private func postWriteTextAPI(joinMemberIDlList: [UserIDList]) {
        APIPostManager.shared.postWriteText(title: contentView.getTitleTextFieldText() ?? "", detail: contentView.getContentTextViewText(), joinMemberID: joinMemberIDlList) { response in
            response.isSuccess ? self.showAlertNavigationBack(message: "게시물 작성이 완료되었습니다.",backType: .pop) : self.errorHandling(response: response)
        }
    }
    
    private func updateWriteTextAPI() {
        APIUpdateManager.shared.updateWriteText(boardID: boardID, title: contentView.getTitleTextFieldText() ?? "", detail: contentView.getContentTextViewText(), memeberInfos: memberList) { response in
            response.isSuccess ? self.showAlertNavigationBack(message: "게시글 수정이 완료되었습니다.",backType: .pop) : self.errorHandling(response: response)
        }
    }
}

// MARK: - UITableView DataSource

extension PostEditorVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return isEditingMode ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? memberList.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MemberTableViewCell.identi, for: indexPath) as? MemberTableViewCell else { return UITableViewCell()}
            cell.setUserInfoViews(model: memberList[indexPath.row])
            cell.selectionStyle = .none
            return cell
        } else {
            guard let addCell = tableView.dequeueReusableCell(withIdentifier: MemBerAddTableViewCell.identi, for: indexPath) as? MemBerAddTableViewCell else { return UITableViewCell()}
            addCell.selectionStyle = .none
            return addCell
        }
    }
}

// MARK: - Delegate

extension PostEditorVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = SearchAddMemberVC()
            vc.searchAddMemberVCDelegate = self
            vc.setProperties(pushRequestChatVC: false, addMemberInfos: memberList)
            presentViewController(viewController: vc)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MemberTableViewHeader.identi) as? MemberTableViewHeader else {return UIView()}
        headerView.setMemberLabelCount(memberCount: memberList.count)
        
        return section == 0 ? headerView : UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 1 ? 1 : tableView.estimatedSectionHeaderHeight
    }
}

extension PostEditorVC: WriteUpdatePostTextViewDelegate {
    func tapDoneButton() {
        view.endEditing(true)
    }
}

extension PostEditorVC: SearchAddMemberVCDelegate {
    func sendAddMemberData(send: [UserInfosModel]) {
        memberList = send
    }
}

// MARK: - Action

extension PostEditorVC {
    private func completedButtonAction() {
        guard let titleText = contentView.getTitleTextFieldText(), !titleText.isEmpty else {
            self.showAlert(message: "제목을 입력해주세요.")
            return
        }
        
        guard contentView.getContentTextViewText() != Strings.WriteDateBoard.textPlaceHolder else {
            self.showAlert(message: "내용을 입력해주세요.")
            return
        }
        
        if isEditingMode {
            updateWriteTextAPI()
        } else {
            self.memberList.count == 1 ? self.showAlert(message: "과팅 게시판 이용은 2명 이상부터 가능합니다.") : postWriteTextAPI(joinMemberIDlList: addMemberID())
        }
    }
}
