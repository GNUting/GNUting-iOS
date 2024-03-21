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
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    private lazy var emailTextField : PaddingTextField = {
        let textField = PaddingTextField()
        textField.attributedPlaceholder = NSAttributedString(string: "email",attributes: [NSAttributedString.Key.font : UIFont(name: Pretendard.Regular.rawValue, size: 20)!,NSAttributedString.Key.foregroundColor : UIColor(named: "Gray")!])
        textField.backgroundColor = UIColor(named: "Gray")?.withAlphaComponent(0.1)
        textField.text =  "testDJ1@gnu.ac.kr"
        return textField
    }()
    private lazy var passwordTextField : PaddingTextField = {
        let textField = PaddingTextField()
        textField.attributedPlaceholder = NSAttributedString(string: "password",attributes: [NSAttributedString.Key.font : UIFont(name: Pretendard.Regular.rawValue, size: 20)!,NSAttributedString.Key.foregroundColor : UIColor(named: "Gray")!])
        textField.backgroundColor = UIColor(named: "Gray")?.withAlphaComponent(0.1)
        textField.text =  "test1234!"
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
        setNavigationBar(title: "")
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
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        APIPostManager.shared.postLoginAPI(email: email, password: password) { statusCode in
            switch statusCode {
            case 200..<300:
                self.view.window?.rootViewController = TabBarController()
            default:
                let alert = UIAlertController(title: "로그인 오류 로그인을 다시 진행해주세요.", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                self.present(alert, animated: true)
            }   
        }
        

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
            make.bottom.lessThanOrEqualTo(self.view.safeAreaLayoutGuide).offset(-100)
        }
        loginButton.setContentCompressionResistancePriority(.required, for: .vertical)
    }
}
