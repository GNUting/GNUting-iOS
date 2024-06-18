//
//  LoginVC.swift
//  GNUting
//
//  Created by 원동진 on 2024/01/24.
//

import UIKit

// MARK: - 로그인 화면

final class LoginVC: BaseViewController {
    
    // MARK: - SubViews
    
    private lazy var appLogiImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppNameImage")
        
        return imageView
    }()
    private lazy var explainLabel: UILabel = {
        let label = UILabel()
        label.text = "경상국립대학교 재학생 전용 과팅앱\n학교 속 새로운 인연을 만나보세요 :)"
        label.font = Pretendard.regular(size: 12)
        label.textAlignment = .left
        label.numberOfLines = 2
        
        return label
    }()

    private lazy var textFieldStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 19
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var emailTextFieldView: LoginTextFieldView = {
        let loginTextFieldView = LoginTextFieldView()
        loginTextFieldView.setTextFieldPlaceHolder(text: "학교 이메일")
        
        return loginTextFieldView
    }()
    
    private lazy var passwordTextField: LoginTextFieldView = {
        let loginTextFieldView = LoginTextFieldView()
        loginTextFieldView.setTextFieldPlaceHolder(text: "비밀번호")
        loginTextFieldView.setPasswordTypeTextField()
       
        return loginTextFieldView
    }()
    
    private lazy var loginButton: PrimaryColorButton = {
        let button = PrimaryColorButton()
        button.setText("로그인")
        button.sizeToFit()
        button.throttle(delay: 3) { _ in
            self.tapLoginButton()
        }
        
        return button
    }()
    
    private lazy var bottomStackView: UIStackView = { // 비밀번호 찾기, 회원가입 StackView
        let bottomStackView = UIStackView()
        bottomStackView.axis = .horizontal
        bottomStackView.spacing = 20
        bottomStackView.distribution = .equalSpacing
        bottomStackView.alignment = .fill
        
        return bottomStackView
    }()
    
    private lazy var findPasswordButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("비밀번호 찾기", attributes: AttributeContainer([NSAttributedString.Key.font: Pretendard.regular(size: 14) ?? .systemFont(ofSize: 14)]))
        config.baseForegroundColor = UIColor(named: "Gray")
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(tapFindPasswordButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var borderLabel: UILabel = {
        let label = UILabel()
        label.text = "|"
        label.font = Pretendard.regular(size: 14)
        label.textColor = UIColor(named: "Gray")
        
        return label
    }()
    
    private lazy var signUpButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("회원가입", attributes: AttributeContainer([NSAttributedString.Key.font: Pretendard.regular(size: 14) ?? .systemFont(ofSize: 14)]))
        config.baseForegroundColor = UIColor(named: "Gray")
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(tapSingupButton), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setAddSubViews()
        setAutoLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
}

// MARK: - Layout Helpers

extension LoginVC {
    private func setAddSubViews() {
        view.addSubViews([appLogiImageView,explainLabel,textFieldStackView,bottomStackView])
        textFieldStackView.addStackSubViews([emailTextFieldView,passwordTextField,loginButton])
        bottomStackView.addStackSubViews([findPasswordButton,borderLabel,signUpButton])
    }
    
    private func setAutoLayout() {
        appLogiImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(95)
            make.centerX.equalToSuperview()
        }
        explainLabel.snp.makeConstraints { make in
            make.top.equalTo(appLogiImageView.snp.bottom).offset(13)
            make.centerX.equalToSuperview()
        }
        textFieldStackView.snp.makeConstraints { make in
            make.top.equalTo(explainLabel.snp.bottom).offset(70)
            make.left.right.equalToSuperview().inset(Spacing.UpperInset)
        }
        bottomStackView.snp.makeConstraints { make in
            make.top.equalTo(textFieldStackView.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).offset(-50)
        }
    }
}

// MARK: - POST API

extension LoginVC {
    private func loginAPI(email: String, password: String) {
        APIPostManager.shared.postLoginAPI(email: email, password: password) { response,successResponse  in
            if response?.isSuccess == false {
                self.errorHandling(response: response)
            }
            
            if successResponse?.isSuccess == true {
                self.view.window?.rootViewController = TabBarController()
            }
        }
    }
}

// MARK: - Action

extension LoginVC {
    private func tapLoginButton() {
        let email = emailTextFieldView.getTextFieldString()
        let password = passwordTextField.getTextFieldString()
        
        loginAPI(email: email, password: password)
    }
    
    @objc private func tapFindPasswordButton() {
        pushViewContoller(viewController: FindPasswordVC())
    }
    
    @objc private func tapSingupButton() {
        pushViewContoller(viewController: TermsVC())
    }
}
