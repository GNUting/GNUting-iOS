//
//  RequestStatusDetailVC.swift
//  GNUting
//
//  Created by 원동진 on 2/29/24.
//

import UIKit

class RequestStatusDetailVC: BaseViewController {
    var dedatilData: ApplicationStatusResult?
    var requestStatus : Bool = true // false : Received
    private lazy var topStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        
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
        button.throttle(delay: 3.0) { _ in
            self.tapAcceptButton()
        }
        
        return button
    }()
    private lazy var groupCountView = ImagePlusLabelView()
    
    private lazy var stateLabel : UILabel = {
        let label = UILabel()
        label.font = Pretendard.medium(size: 14)
        label.textColor = UIColor(named: "DisableColor")
        label.textAlignment = .right
        return label
    }()
    private lazy var dateMemeberTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(DateMemeberTableViewCell.self, forCellReuseIdentifier: DateMemeberTableViewCell.identi)
        tableView.register(DateMemberHeader.self, forHeaderFooterViewReuseIdentifier: DateMemberHeader.identi)
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        view.addSubViews([topStackView, dateMemeberTableView, buttonStackView])
        topStackView.addStackSubViews([groupCountView, stateLabel])
        
    }
    private func setAutoLayout(){
        topStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Spacing.top)
            make.left.right.equalToSuperview().inset(Spacing.left)
            
        }
        
        dateMemeberTableView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom).offset(Spacing.top)
            make.left.right.equalToSuperview().inset(25)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-65)
        }
        buttonStackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-38)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DateMemeberTableViewCell.identi, for: indexPath) as? DateMemeberTableViewCell else {return UITableViewCell()}
        
        if indexPath.row == (dedatilData?.applyUserCount ?? 0) - 1 {
            cell.addBorders(to: [.bottom], in: UIColor(named: "BorderColor")!, width: 1)
        }
        cell.selectionStyle = .none
        cell.addBorders(to: [.left,.right], in: UIColor(named: "BorderColor")!, width: 1)
        if indexPath.section == 0 {
            if let participantUser = dedatilData?.participantUser{
                cell.setDateMember(model: participantUser[indexPath.row])
                cell.userImageTappedClosure = {
                    let vc = UserDetailVC()
                    
                    vc.userDetailData = UserDetailModel(imageURL: participantUser[indexPath.row].profileImage,
                                                        nickname: participantUser[indexPath.row].nickname,
                                                        userStudentID: participantUser[indexPath.row].studentId,
                                                        userDepartment: participantUser[indexPath.row].department)
                    self.presentFullScreenVC(viewController: vc)
                }
            }
            
        }else {
            if let applyUserData = dedatilData?.applyUser{
                cell.setDateMember(model: applyUserData[indexPath.row])
                cell.userImageTappedClosure = {
                    let vc = UserDetailVC()
                    
                    vc.userDetailData = UserDetailModel(imageURL: applyUserData[indexPath.row].profileImage,
                                                        nickname: applyUserData[indexPath.row].nickname,
                                                        userStudentID: applyUserData[indexPath.row].studentId,
                                                        userDepartment: applyUserData[indexPath.row].department)
                    self.presentFullScreenVC(viewController: vc)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DateMemberHeader.identi) as? DateMemberHeader else { return UIView()}
        
        if section == 0 {
            header.requestStatus = true
            header.setHeader(major: dedatilData?.participantUserDepartment)
            
        }else {
            header.requestStatus = false
            
            header.setHeader(major: dedatilData?.applyUserDepartment)
        }
        
        return header
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
}
extension RequestStatusDetailVC {
    private func setStateLabel(state: String,groupCount: Int) {
        let countStr = "\(groupCount) : \(groupCount) 매칭"
        let groupCountViewString = groupCount == 1 ? countStr : "과팅 (\(countStr))"
        groupCountView.setImagePlusLabelView(imageName: "HeartImage", textFont: Pretendard.bold(size: 16) ?? .boldSystemFont(ofSize: 16), labelText: groupCountViewString)
        var applyStatus: RequestState = .waiting
        switch state {
        case "승인":
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
        stateLabel.textColor = applyStatus.textColor
    }
}

extension RequestStatusDetailVC {
    @objc private func tapCancelButton(){
        
        if requestStatus{
            let alertContoller = UIAlertController(title: "", message: "신청 취소하시겠습니까?", preferredStyle: .alert)
            alertContoller.addAction(UIAlertAction(title: "취소", style: .destructive))
            alertContoller.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                APIDeleteManager.shared.deleteRequestChat(boardID:self.dedatilData?.id ?? 0) { response in
                    if response.isSuccess {
                        self.showMessage(message: "취소되었습니다.")
                        self.popButtonTap()
                    } else {
                        self.errorHandling(response: response)
                    }
                }
            }))
            DispatchQueue.main.async {
                self.present(alertContoller, animated: true)
            }
          
            
        } else {
            let alertContoller = UIAlertController(title: "", message: "신청 거절하시겠습니까?", preferredStyle: .alert)
            alertContoller.addAction(UIAlertAction(title: "취소", style: .destructive))
            alertContoller.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                APIUpdateManager.shared.rejectedApplication(boardID: self.dedatilData?.id ?? 0) { response in
                    if response.isSuccess {
                        self.showMessagePop(message: "신청을 거절하였습니다.")
                    } else {
                        self.errorHandling(response: response)
                    }
                    
                }
            }))
            DispatchQueue.main.async {
                self.present(alertContoller, animated: true)
            }
        }
    }
   private func tapAcceptButton() {
        APIPostManager.shared.chatConfirmed(id: dedatilData?.id ?? 0) { response in
            if response.isSuccess {
                self.showMessage(message: "채팅신청을 수락하였습니다.")
            } else {
                self.errorHandling(response: response)
            }
        }
    }
}
