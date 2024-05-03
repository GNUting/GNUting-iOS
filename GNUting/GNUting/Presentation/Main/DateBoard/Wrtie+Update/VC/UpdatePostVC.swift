//
//  UpdatePostVC.swift
//  GNUting
//
//  Created by 원동진 on 3/17/24.
//

import UIKit

class UpdatePostVC: UIViewController {
    let textViewPlaceHolder = "내용을 입력해주세요."
    var writeDateBoardState : Bool = true
    var boardID: Int = 0
    var memberDataList: [UserInfosModel] = [] {
        didSet {
            memberTableView.reloadData()
        }
    }
    
    private lazy var postTextView : WrtieUpdatePostTextView = {
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
        
        return tableView
    }()
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        addSubViews()
        setAutoLayout()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
    
}
extension UpdatePostVC{
    private func setNavigationBar(){
        setNavigationBar(title: "수정하기")
        
        let completedButton = UIButton()
        completedButton.setTitle("완료", for: .normal)
        completedButton.titleLabel?.font = UIFont(name: Pretendard.Medium.rawValue, size: 18)
        completedButton.setTitleColor(UIColor(named: "SecondaryColor"), for: .normal)
        completedButton.addTarget(self, action: #selector(tapCompletedButton), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: completedButton)
    }
    private func addSubViews() {
        view.addSubViews([postTextView,memberTableView])
    }
    private func setAutoLayout(){
        postTextView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Spacing.top)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        
        memberTableView.snp.makeConstraints { make in
            make.top.equalTo(postTextView.snp.bottom).offset(Spacing.top)
            make.left.right.equalToSuperview().inset(Spacing.UpperInset)
            make.height.equalToSuperview().dividedBy(2)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
}

// MARK: - DataSource

extension UpdatePostVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = SearchAddMemberVC()
            vc.memberAddButtonDelegate = self
            vc.addMemberInfos = memberDataList
            let navigationVC = UINavigationController.init(rootViewController: vc)
            present(navigationVC, animated: true)
            
        }
    }
}

// MARK: - Delegate

extension UpdatePostVC : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
            
        }
        if textView.text != "" {
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

extension UpdatePostVC: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    // MARK: - Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return memberDataList.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MemberTableViewCell.identi, for: indexPath) as? MemberTableViewCell else { return UITableViewCell()}
            cell.setUserInfoViews(model: memberDataList[indexPath.row])
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
            headerView.setMemberLabelCount(memberCount: memberDataList.count)
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

extension UpdatePostVC{
    @objc private func tapCompletedButton(){
        
        APIUpdateManager.shared.updateWriteText(boardID: boardID, title: postTextView.getTitleTextFieldText() ?? "", detail: postTextView.getContentTextViewText(), memeberInfos: memberDataList) { response in
            if response.isSuccess {
                self.successHandlingPopAction(message: response.message)
            } else {
                self.errorHandling(response: response)
            }
        }
    }
}

extension UpdatePostVC: MemberAddButtonDelegate {
    func sendAddMemberData(send: [UserInfosModel]) {
        
        memberDataList = send
    }
    
    
}
extension UpdatePostVC {
    func setPostTestView(title: String, content: String){
        postTextView.setTitleTextFieldText(text: title)
        postTextView.setContentTextView(text: content)
        
    }
}
