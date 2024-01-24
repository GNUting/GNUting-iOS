//
//  LoginVC.swift
//  GNUting
//
//  Created by 원동진 on 2024/01/24.
//

import UIKit

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
        config.attributedTitle = AttributedString("아이디 또는 비밀번호를 잊어버리셨나요?", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: Pretendard.Bold.rawValue, size: 15)!]))
        config.baseForegroundColor = UIColor(named: "LightGray")
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(tapFindPasswordButton), for: .touchUpInside)
        return button
    }()
    private lazy var loginButton : PrimaryColorButton = {
        let button = PrimaryColorButton()
        button.setText("로그인")
        button.sizeToFit()
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addSubViews()
        setAutoLayout()
        setNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}
extension LoginVC{
    @objc func tapSignUpBarButtonItem(){
        
    }
    @objc func tapFindPasswordButton(){
        let findPasswordVC = FindPasswordVC()
        self.navigationController?.pushViewController(findPasswordVC, animated: true)
    }
}
extension LoginVC {
    private func addSubViews(){
        self.view.addSubViews([upperStackView,textFieldStackView])
        upperStackView.addStackSubViews([LoginLabel,textFieldStackView,findPasswordButton,loginButton])
        textFieldStackView.addStackSubViews([emailTextField,passwordTextField])
    }
    private func setAutoLayout(){
        upperStackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(180)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-180)
        }
    }
    private func setNavigationBar(){
        let popButton = UIBarButtonItem(image: UIImage(named: "PopImg"), style: .plain, target: self, action: #selector(popButtonTap))
        popButton.tintColor = UIColor(named: "Gray")
        let signUPButton = UIBarButtonItem(title: "회원가입", style: .plain, target: self, action: #selector(tapSignUpBarButtonItem))
        signUPButton.setTitleTextAttributes([.font : UIFont(name: Pretendard.Bold.rawValue, size: 15)!], for: .normal)
        signUPButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = signUPButton
        self.navigationItem.leftBarButtonItem = popButton
    }
}
