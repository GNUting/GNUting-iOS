//
//  WriteDateBoardVC.swift
//  GNUting
//
//  Created by 원동진 on 2/19/24.
//

// MARK: - 게시글 작성 ViewController

import UIKit

final class WriteDateBoardVC: BaseViewController {
    
    // MARK: - Properties
    
    private var writeEnable: Bool = false
    private var addMemberDataList: [UserInfosModel] = [] {
        didSet {
            memberTableView.reloadData()
        }
    }
    
    // MARK: - SubViews

    private lazy var titleContentView: WriteUpdatePostTextView = {
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
        setNavigationBar()
        getUserDataAPI()
    }
}

extension WriteDateBoardVC {
    
    // MARK: - Layout Helpers
    
    private func setAddSubViews() {
        view.addSubViews([titleContentView, memberTableView])
    }
    
    private func setAutoLayout() {
        titleContentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Spacing.top)
            make.left.right.equalToSuperview().inset(Spacing.size25)
        }
        
        memberTableView.snp.makeConstraints { make in
            make.top.equalTo(titleContentView.snp.bottom).offset(Spacing.top)
            make.left.right.equalToSuperview().inset(Spacing.size27)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalToSuperview().dividedBy(2)
        }
    }
    
    // MARK: - SetView
    
    private func setNavigationBar() {
        setNavigationBar(title: "글쓰기")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: completedButton)
    }

    private func addMemberID() -> [UserIDList] {
        var joinMemberIDList: [UserIDList] = []
        
        for userData in addMemberDataList {
            joinMemberIDList.append(UserIDList(id: userData.id))
        }
        return joinMemberIDList
    }
    
    // MARK: - API
    
    private func getUserDataAPI() {
        APIGetManager.shared.getUserData { userData,response  in
            self.errorHandling(response: response)
            guard let userData = userData?.result else { return }
            self.addMemberDataList.append(UserInfosModel(id: userData.id,
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
    
    private func postWriteTextAPI(joinMemberIDlList: [UserIDList]) {
        APIPostManager.shared.postWriteText(title: titleContentView.getTitleTextFieldText() ?? "", detail: titleContentView.getContentTextViewText(), joinMemberID: joinMemberIDlList) { response in
            response.isSuccess ? self.showAlertNavigationBack(message: "게시물 작성이 완료되었습니다.",backType: .pop) : self.errorHandling(response: response)
        }
    }
}

// MARK: - UITableView DataSource

extension WriteDateBoardVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? addMemberDataList.count : 1
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
}

// MARK: - Delegate

extension WriteDateBoardVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = SearchAddMemberVC()
            vc.searchAddMemberVCDelegate = self
            vc.setProperties(pushRequestChatVC: false, addMemberInfos: addMemberDataList)
            presentViewController(viewController: vc)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MemberTableViewHeader.identi) as? MemberTableViewHeader else {return UIView()}
        headerView.setMemberLabelCount(memberCount: addMemberDataList.count)
        
        return section == 0 ? headerView : UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 1 ? 1 : tableView.estimatedSectionHeaderHeight
    }
}

extension WriteDateBoardVC: WriteUpdatePostTextViewDelegate {
    func tapDoneButton() {
        view.endEditing(true)
    }
}

extension WriteDateBoardVC: SearchAddMemberVCDelegate {
    func sendAddMemberData(send: [UserInfosModel]) {
        addMemberDataList = send
    }
}

// MARK: - Action

extension WriteDateBoardVC {
    private func completedButtonAction() {
        if self.titleContentView.getTitleTextFieldText()?.count == 0 {
            self.showAlert(message: "제목을 입력해주세요.")
        } else if self.titleContentView.getContentTextViewText() == Strings.WriteDateBoard.textPlaceHolder {
            self.showAlert(message: "내용을 입력해주세요.")
        } else {
            self.addMemberDataList.count == 1 ? self.showAlert(message: "과팅 게시판 이용은 2명 이상부터 가능합니다.") : postWriteTextAPI(joinMemberIDlList: addMemberID())
        }
    }
}
