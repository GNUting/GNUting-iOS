//
//  UserDetailVC.swift
//  GNUting
//
//  Created by 원동진 on 4/9/24.
//

// MARK: - 프로필 클릭시 사용자 디테일 VC

import UIKit

final class UserDetailVC: BaseViewController {
    
    //MARK: - Properties
    
     var imaegURL: String? // 사용자 이미지 URL 주소
     var userNickname: String? // 사용자 닉네임
     var userStudentID: String? // 사용자 학번
     var userDepartment: String? // 사용자 학과
    
    // MARK: - SubViews
    
    private lazy var userImageButton = UIButton()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = Pretendard.medium(size: 16)
        
        return label
    }()
    
    private lazy var subInfoLabel: UILabel = { // 학번 & 학과 Label
        let label = UILabel()
        label.font = Pretendard.medium(size: 12)
        label.textColor = UIColor(named: "DisableColor")
        
        return label
    }()
    
    private lazy var reportButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 27, bottom: 10, trailing: 27)
        config.attributedTitle = AttributedString("신고하기", attributes: AttributeContainer([NSAttributedString.Key.font: Pretendard.medium(size: 16) ?? .boldSystemFont(ofSize: 16),NSAttributedString.Key.foregroundColor: UIColor(named: "PrimaryColor") ?? .red]))
        config.titleAlignment = .center
        
        let button = UIButton(configuration: config)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
        button.addTarget(self, action: #selector(tapReportButton), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserData()
        setAddSubViews()
        setAutoLayout()
        setUserDetailViewLabel()
        setUserDetailViewImageView()
        setNavigationBar()
    }
}

// MARK: - Layout Helpers

extension UserDetailVC {
    private func setAddSubViews() {
        view.addSubViews([userImageButton,userNameLabel,subInfoLabel,reportButton])
    }
    
    private func setAutoLayout() {
        userImageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(200)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        subInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        reportButton.snp.makeConstraints { make in
            make.top.equalTo(subInfoLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-100)
        }
    }
}

// MARK: - SetView

extension UserDetailVC {
    private func setNavigationBar() {
        setNavigationBarPresentType(title: "")
    }
    
    private func setUserDetailViewLabel() {
        userNameLabel.text = userNickname
        subInfoLabel.text = "\(userStudentID ?? "학번")학번 | \(userDepartment ?? "학과")"
    }
    
    private func setUserDetailViewImageView() {
        setImageFromStringURL(stringURL: imaegURL) { image in
            DispatchQueue.main.async {
                self.userImageButton.setImage(image, for: .normal)
                self.userImageButton.layer.cornerRadius = self.userImageButton.layer.frame.size.width / 2
                self.userImageButton.layer.masksToBounds = true
            }
        }
    }
}


// MARK: - GET API

extension UserDetailVC {
    private func getUserData() { // 사용자 정보 Get
        APIGetManager.shared.getUserData { userData,response  in
            self.errorHandling(response: response)
            if userData?.result?.nickname == self.userNickname { // 사용자 정보와 비교하여 일치할 경우 신고하기 버튼 Hidden
                self.reportButton.isHidden = true
            }
        }
    }
}

// MARK: - Action

extension UserDetailVC {
    @objc private func tapReportButton() { // 신고하기 버튼 클릭
        let vc = ReportVC()
        vc.userNickname = self.userNickname ?? "유저이름"
        self.presentFullScreenVC(viewController: vc)
    }
}
