//
//  UpdaetProfileVC.swift
//  GNUting
//
//  Created by 원동진 on 2/29/24.
//

import UIKit

// MARK: - 프로필 수정화면

class UpdaetProfileVC: UIViewController {
    private lazy var userImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle")
        imageView.layer.cornerRadius = imageView.layer.frame.size.width / 2
        return imageView
    }()
    
    private lazy var nickNameInputView : SignUPInputView = {
        let inputView = SignUPInputView()
        inputView.setInputTextTypeLabel(text: "닉네임")
        inputView.setPlaceholder(placeholder: "닉네임을 입력해주세요.")
        inputView.setConfirmButton(text: "중복확인")
        return inputView
    }()
    
    private lazy var majorInputView : SignUPInputView = {
       let majorInputView = SignUPInputView()
        majorInputView.setInputTextTypeLabel(text: "학과")
        majorInputView.setPlaceholder(placeholder: "힉과를 입력해주세요.")
        return majorInputView
    }()
    
    private lazy var introduceInputView : SignUPInputView = {
       let majorInputView = SignUPInputView()
        majorInputView.setInputTextTypeLabel(text: "한줄 소개")
        majorInputView.setPlaceholder(placeholder: "한줄 소개를 입력해주세요.")
        return majorInputView
    }()
    
    private lazy var updateProfileButton : UIButton = {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("프로필 수정", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: Pretendard.Medium.rawValue, size: 20)!]))
        config.baseForegroundColor = .black
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 10, bottom: 10, trailing: 10)
        let button = UIButton(configuration: config)
        button.backgroundColor = UIColor(hexCode: "F5F5F5")
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tapUpdateProfileButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setAddSubViews()
        setAutoLayout()
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    @objc private func tapUpdateProfileButton() {
        
    }
}

extension UpdaetProfileVC{
    private func setAddSubViews() {
        view.addSubViews([userImageView,nickNameInputView,majorInputView,introduceInputView,updateProfileButton])
    }
    private func setAutoLayout(){
        userImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(50)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(150)
        }
        nickNameInputView.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.bottom).offset(100)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        majorInputView.snp.makeConstraints { make in
            make.top.equalTo(nickNameInputView.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        introduceInputView.snp.makeConstraints { make in
            make.top.equalTo(majorInputView.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        updateProfileButton.snp.makeConstraints { make in
            make.top.equalTo(introduceInputView.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-15)
        }
    }
    
}
