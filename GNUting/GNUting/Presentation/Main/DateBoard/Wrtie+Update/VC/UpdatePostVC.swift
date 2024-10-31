//
//  UpdatePostVC.swift
//  GNUting
//
//  Created by 원동진 on 3/17/24.
//

// MARK: - 게시글 수정 ViewController

import UIKit

final class UpdatePostVC: BaseViewController {
    
    // MARK: - Properties
    
    var boardID: Int = 0
    var memberDataList: [UserInfosModel] = [] {
        didSet {
            memberTableView.reloadData()
        }
    }
    
    // MARK: - SubViews
    
    private lazy var postTextView: WriteUpdatePostTextView = {
        let view = WriteUpdatePostTextView()
        view.wrtieUpdatePostTextViewDelegate = self
    
        return view
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
        button.throttle(delay: 3) { _ in
            self.completedButtonAction()
        }
        
        return button
    }()

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        setAutoLayout()
        setNavigationBar()
    }
}

extension UpdatePostVC {
    
    // MARK: - Layout Helpers
    
    private func addSubViews() {
        view.addSubViews([postTextView, memberTableView])
    }
    
    private func setAutoLayout() {
        postTextView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Spacing.top)
            make.left.right.equalToSuperview().inset(Spacing.size25)
        }
        
        memberTableView.snp.makeConstraints { make in
            make.top.equalTo(postTextView.snp.bottom).offset(Spacing.top)
            make.left.right.equalToSuperview().inset(Spacing.size27)
            make.height.equalToSuperview().dividedBy(2)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - SetView
    
    private func setNavigationBar() {
        setNavigationBar(title: "수정하기")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: completedButton)
    }
    
    func setPostTestView(title: String, content: String){
        postTextView.setTitleTextFieldText(text: title)
        postTextView.setContentTextView(text: content)
        postTextView.content = content
    }
    
    // MARK: - API

    private func updateWriteTextAPI() {
        APIUpdateManager.shared.updateWriteText(boardID: boardID, title: postTextView.getTitleTextFieldText() ?? "", detail: postTextView.getContentTextViewText(), memeberInfos: memberDataList) { response in
            response.isSuccess ? self.showAlertNavigationBack(message: "게시글 수정이 완료되었습니다.",backType: .pop) : self.errorHandling(response: response)
        }
    }
}

// MARK: - DataSource

extension UpdatePostVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemberTableViewCell.identi, for: indexPath) as? MemberTableViewCell else { return UITableViewCell()}
        cell.setUserInfoViews(model: memberDataList[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK: - Delegate

extension UpdatePostVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MemberTableViewHeader.identi) as? MemberTableViewHeader else {return UIView()}
        headerView.setMemberLabelCount(memberCount: memberDataList.count)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.estimatedSectionHeaderHeight
    }
}

extension UpdatePostVC: WriteUpdatePostTextViewDelegate {
    func tapDoneButton() {
        view.endEditing(true)
    }
}

extension UpdatePostVC: SearchAddMemberVCDelegate {
    func sendAddMemberData(send: [UserInfosModel]) {
        memberDataList = send
    }
}

// MARK: - Action

extension UpdatePostVC {
    private func completedButtonAction() {
        if self.postTextView.getTitleTextFieldText()?.count == 0 {
            self.showAlert(message: "제목을 입력해주세요.")
        } else if self.postTextView.getContentTextViewText() == Strings.WriteDateBoard.textPlaceHolder {
            self.showAlert(message: "내용을 입력해주세요.")
        } else {
            updateWriteTextAPI()
        }
    }
}
