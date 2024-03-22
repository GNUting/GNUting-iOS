//
//  RequestStatusDetailVC.swift
//  GNUting
//
//  Created by 원동진 on 2/29/24.
//

import UIKit

class RequestStatusDetailVC: UIViewController {
    var dedatilData: ApplicationStatusResult?
    var requestStatus : Bool = true // false : Received
    private lazy var topStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        return stackView
    }()
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    private lazy var cancelButton : PrimaryColorButton = {
        let button = PrimaryColorButton()
        button.setText("취소하기",fointSize: 15)
        button.setHeight(height: 50)
        button.addTarget(self, action: #selector(tapCancelButton), for: .touchUpInside)
        return button
    }()
    private lazy var acceptButton : PrimaryColorButton = {
        let button = PrimaryColorButton()
        button.setText("수락하기",fointSize: 15)
        button.setHeight(height: 50)
        button.backgroundColor = UIColor(named: "SecondaryColor")
        return button
    }()
    private lazy var groupCountLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: Pretendard.SemiBold.rawValue, size: 20)
        
        return label
    }()
    
    private lazy var stateLabel : BasePaddingLabel = {
        let label = BasePaddingLabel(padding: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        label.font = UIFont(name: Pretendard.SemiBold.rawValue, size: 16)
        label.textColor = .white
        
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        return label
    }()
    private lazy var dateMemeberTableView : UITableView = {
        let tableView = UITableView(frame: .zero,style: .grouped)
        tableView.register(MemberTableViewCell.self, forCellReuseIdentifier: MemberTableViewCell.identi)
        tableView.register(DateMemberHeader.self, forHeaderFooterViewReuseIdentifier: DateMemberHeader.identi)
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setAddSubViews()
        setAutoLayout()
        navigationController?.navigationBar.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setStateLabel(state: dedatilData?.applyStatus ?? "", groupCount: dedatilData?.applyUserCount ?? 0)
        setNaviagtionBar()
        setButtonStackView(requestStatus: requestStatus)
    }
}
extension RequestStatusDetailVC{
    private func setAddSubViews() {
        view.addSubViews([topStackView,dateMemeberTableView,buttonStackView])
        topStackView.addStackSubViews([groupCountLabel,stateLabel])
        
    }
    private func setAutoLayout(){
        topStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview().inset(Spacing.left)
        }
        groupCountLabel.setContentHuggingPriority(.init(249), for: .horizontal)
        dateMemeberTableView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom).offset(Spacing.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-65)
        }
        buttonStackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview().inset(Spacing.left)
        }
        
    }
    private func setNaviagtionBar(){
        setNavigationBar(title: "신청현황")
    }
    
    private func setButtonStackView(requestStatus: Bool) {
        if requestStatus {
            buttonStackView.addArrangedSubview(cancelButton)
        } else {
            cancelButton.setText("거절하기", fointSize: 15)
            buttonStackView.addStackSubViews([cancelButton,acceptButton])
        }
    }
}
extension RequestStatusDetailVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dedatilData?.applyUserCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemberTableViewCell.identi, for: indexPath) as? MemberTableViewCell else {return UITableViewCell()}
        if indexPath.section == 0 {
            if let applyUserData = dedatilData?.applyUser{
                cell.setDateMember(model: applyUserData[indexPath.row])
            }
            
        }else {
            if let participantUser = dedatilData?.participantUser{
                cell.setDateMember(model: participantUser[indexPath.row])
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DateMemberHeader.identi) as? DateMemberHeader else { return UIView()}
        if section == 0 {
            header.setHeader(major: dedatilData?.applyUserDepartment, count: dedatilData?.applyUserCount)
        }else {
            header.setHeader(major: dedatilData?.participantUserDepartment, count: dedatilData?.participantUserCount)
        }
        
        return header
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
}
extension RequestStatusDetailVC {
    private func setStateLabel(state: String,groupCount: Int) {
        groupCountLabel.text = "\(groupCount):\(groupCount) 매칭"
        var applyStatus: RequestState = .waiting
        switch state{
        case "성공":
            applyStatus = .Success
            buttonStackView.isHidden = true
        case "신청 취소":
            buttonStackView.isHidden = true
            applyStatus = .cacnel
        case "거절":
            buttonStackView.isHidden = true
            applyStatus = .refuse
        default:
            buttonStackView.isHidden = false
            applyStatus = .waiting
        }
        stateLabel.text = applyStatus.statusString
        stateLabel.backgroundColor = applyStatus.backgroundColor
    }
}

extension RequestStatusDetailVC {
    @objc private func tapCancelButton(){
        if requestStatus{
            APIDeleteManager.shared.deleteRequestChat(boardID:dedatilData?.id ?? 0) { response in
                if response.isSuccess {
                    self.successHandlingPopAction(message: response.message)
                } else {
                    self.errorHandling(response: response)
                }
            }
        } else {
            APIUpdateManager.shared.rejectedApplication(boardID: dedatilData?.id ?? 0) { response in
                if response.isSuccess {
                    self.successHandlingPopAction(message: response.message)
                } else {
                    self.errorHandling(response: response)
                }
                
            }
        }
    }
}
