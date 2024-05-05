//
//  UserDetailVC.swift
//  GNUting
//
//  Created by 원동진 on 4/9/24.
//

import UIKit

class UserDetailVC: BaseViewController {
    var imaegURL : String?
    var userNickName: String?
    var userStudentID: String?
    var userDepartment: String?
    private lazy var userImageView = UIImageView()
    private lazy var userNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Medium.rawValue, size: 16)
        return label
    }()
    private lazy var subInfoLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Medium.rawValue, size: 12)
        label.textColor = UIColor(named: "DisableColor")
        return label
    }()
    private lazy var reportButton : UIButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 27, bottom: 10, trailing: 27)
        
        config.attributedTitle = AttributedString("신고하기", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: Pretendard.Medium.rawValue, size: 16)!,NSAttributedString.Key.foregroundColor : UIColor(named: "PrimaryColor") ?? .red]))
        config.titleAlignment = .center
        
        let button = UIButton(configuration: config)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor

        button.addTarget(self, action: #selector(tapReportButton), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserData()
        setAddSubViews()
        setAutoLayout()
        setUserDetailView()
        setNavigationBar()
        
    }
   
}
extension UserDetailVC{
    private func setAddSubViews() {
        self.view.addSubViews([userImageView,userNameLabel,subInfoLabel,reportButton])
    }
    private func setAutoLayout(){
        userImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(200)
        }
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        subInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        reportButton.snp.makeConstraints { make in
            make.top.equalTo(subInfoLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    private func setUserDetailView() {
        userNameLabel.text = userNickName
        subInfoLabel.text = "\(userStudentID ?? "학번")학번 | \(userDepartment ?? "학과")"
        setImageFromStringURL(stringURL: imaegURL) { image in
            DispatchQueue.main.async {
                self.userImageView.image = image
                self.userImageView.layer.cornerRadius = self.userImageView.layer.frame.size.height / 2
                self.userImageView.clipsToBounds = true
            }
        }
    }
    private func setNavigationBar() {
        setNavigationBarPresentType(title: "")
        
    }
    @objc private func tapReportButton() {
        let vc = ReportVC()
        vc.userNickname = self.userNickName ?? "유저이름"
        //        self.navigationController?.pushViewController(vc, animated: true)
        self.presentFullScreenVC(viewController: vc)
    }
}

extension UserDetailVC {
    
    func getUserData(){
        APIGetManager.shared.getUserData { userData,response  in
            self.errorHandling(response: response)
            //            if self.userNickName == userData?.result?.nickname {
            //                self.reportButton.isHidden = true
            //            }
        }
    }
}
