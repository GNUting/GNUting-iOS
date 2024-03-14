//
//  ViewController.swift
//  GNUting
//
//  Created by 원동진 on 2024/01/23.
//

import UIKit
import SnapKit
class AppStartVC: UIViewController {
    private lazy var explainLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 20)
        label.numberOfLines = 3
        label.textColor = .black
        label.setRangeTextFont(fullText: "경상국립대학교 새로운 만남 과팅앱\n지누팅\n학교 속 새로운 인연을 만나보세요.", range: "지누팅", uiFont: UIFont(name: Pretendard.Bold.rawValue, size: 20)!)
        return label
    }()
    private lazy var startBackImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "StatBackImg")
        return imgView
    }()
    private lazy var loginButton : PrimaryColorButton = {
        let button = PrimaryColorButton()
        button.setText("로그인")
        button.addTarget(self, action: #selector(tapLoginButton), for: .touchUpInside)
        return button
    }()
    private lazy var signUpButton : PrimaryColorButton = {
        let button = PrimaryColorButton()
        button.setText("회원가입")
        button.addTarget(self, action: #selector(tapSignUpButton), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        startBackImgView.isUserInteractionEnabled = true
        setAddSubViews()
        setAutoLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
}
extension AppStartVC{
    @objc func tapLoginButton(){
        let loginVC = LoginVC()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    @objc func tapSignUpButton(){
        let loginVC = TermsVC()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
}
extension AppStartVC {
    private func setAddSubViews(){
        self.view.addSubview(startBackImgView)
        startBackImgView.addSubViews([explainLabel,loginButton,signUpButton])
    }
    private func setAutoLayout(){
        startBackImgView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        explainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        loginButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(explainLabel.snp.bottom)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(18)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.bottom.equalToSuperview().offset(-50)
        }
    }
}

