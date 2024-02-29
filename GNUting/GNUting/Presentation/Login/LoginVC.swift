//
//  LoginVC.swift
//  GNUting
//
//  Created by 원동진 on 2024/01/24.
//

import UIKit
// MARK: - 오토레이아웃 설정 다시 필요
class LoginVC: UIViewController {
    private lazy var upperStackView : UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        return stackView
    }()
    private lazy var LoginLabel : UILabel = {
        let label = UILabel()
        label.text = "로그인"
        label.font = UIFont(name: Pretendard.Bold.rawValue, size: 30)
        label.textAlignment = .left
        return label
    }()
    private lazy var textFieldStackView : UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    private lazy var emailTextField : PaddingTextField = {
        let textField = PaddingTextField()
        textField.attributedPlaceholder = NSAttributedString(string: "email",attributes: [NSAttributedString.Key.font : UIFont(name: Pretendard.Regular.rawValue, size: 15)!,NSAttributedString.Key.foregroundColor : UIColor(named: "Gray")!])
        textField.backgroundColor = UIColor(named: "Gray")?.withAlphaComponent(0.1)
        
        return textField
    }()
    private lazy var passwordTextField : PaddingTextField = {
        let textField = PaddingTextField()
        textField.attributedPlaceholder = NSAttributedString(string: "password",attributes: [NSAttributedString.Key.font : UIFont(name: Pretendard.Regular.rawValue, size: 15)!,NSAttributedString.Key.foregroundColor : UIColor(named: "Gray")!])
        textField.backgroundColor = UIColor(named: "Gray")?.withAlphaComponent(0.1)
        return textField
    }()
    private lazy var findPasswordButton : UIButton = {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("비밀번호를 잊어버리셨나요?", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: Pretendard.Bold.rawValue, size: 15)!]))
        config.baseForegroundColor = UIColor(named: "LightGray")
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(tapFindPasswordButton), for: .touchUpInside)
        return button
    }()
    private lazy var loginButton : PrimaryColorButton = {
        let button = PrimaryColorButton()
        button.setText("로그인")
        button.addTarget(self, action: #selector(tapLoginButton), for: .touchUpInside)
        button.sizeToFit()
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setNavigationBar()
        addSubViews()
        setAutoLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}
extension LoginVC{
    @objc func tapLoginButton(){
        self.view.window?.rootViewController = TabBarController()
    }
    
    @objc func tapFindPasswordButton(){
        let findPasswordVC = FindPasswordVC()
        self.navigationController?.pushViewController(findPasswordVC, animated: true)
    }
}
extension LoginVC {
    private func addSubViews(){
        self.view.addSubViews([upperStackView])
        upperStackView.addStackSubViews([LoginLabel,textFieldStackView,findPasswordButton,loginButton])
        textFieldStackView.addStackSubViews([emailTextField,passwordTextField])
    }
    private func setAutoLayout(){
        upperStackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(100)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-100)
        }
        loginButton.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    private func setNavigationBar(){
        let backButton = BackButton()
        backButton.setConfigure(text: "")
        backButton.addTarget(self, action: #selector(popButtonTap), for: .touchUpInside)
        let popButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = popButton
    }
}
