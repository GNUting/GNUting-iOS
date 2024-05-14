//
//  SignupInputViewEmailCheckType.swift
//  GNUting
//
//  Created by 원동진 on 4/30/24.
//

import UIKit


protocol CheckEmailButtonDelegate {
    func action(textFieldText: String)
}
protocol CheckEmailTextFieldDelegate {
    func didBegin()
}
class SignUpInputViewEmailCheckType : UIView{
    var checkEmailButtonDelegate: CheckEmailButtonDelegate?
    var checkEmailTextFieldDelegate: CheckEmailTextFieldDelegate?
    private lazy var inputTypeLabel : UILabel = {
        let label = UILabel()
        label.text = "학교 이메일"
        label.font = UIFont(name: Pretendard.Medium.rawValue, size: 14)
        return label
    }()
    
    private lazy var middleStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        
        return stackView
    }()
    private lazy var inputTextField : UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: Pretendard.Regular.rawValue, size: 12)
        textField.delegate = self
        textField.addTarget(self, action: #selector(changeInputTextField(_:)), for: .editingChanged)
        
        return textField
    }()
    private lazy var emailLabel : UILabel = {
        let uiLabel = UILabel()
        uiLabel.text = "@gnu.ac.kr"
        uiLabel.font = UIFont(name: Pretendard.Regular.rawValue, size: 14)
        
        return uiLabel
    }()
    private let bottomLine : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "EAEAEA")
        return view
    }()
    private lazy var confirmButton : ThrottleButton = {
        
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        config.attributedTitle = AttributedString("인증받기", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: Pretendard.Regular.rawValue, size: 14)!]))
        config.titleAlignment = .center
        config.baseForegroundColor = .white
        
        let button = ThrottleButton(configuration: config)
        
        button.backgroundColor = UIColor(hexCode: "979C9E")
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.throttle(delay: 3) { _ in
            self.getEmailAuthNumber()
        }
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension SignUpInputViewEmailCheckType{
    private func setAddSubViews() {
        addSubViews([inputTypeLabel,middleStackView,bottomLine,confirmButton])
        middleStackView.addStackSubViews([inputTextField,emailLabel])
                     
    }
    private func setAutoLayout(){
        inputTypeLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            
        }
        middleStackView.snp.makeConstraints { make in
            make.top.equalTo(inputTypeLabel.snp.bottom).offset(7)
            make.left.equalToSuperview()
        }
        bottomLine.snp.makeConstraints { make in
            make.top.equalTo(middleStackView.snp.bottom).offset(5)
            make.height.equalTo(1)
            make.width.equalTo(middleStackView)
            make.bottom.equalToSuperview()
        }
        confirmButton.snp.makeConstraints { make in
            make.left.equalTo(middleStackView.snp.right).offset(15)
            make.bottom.right.equalToSuperview()
            make.width.equalTo(80)
        }
        
        
    }
}
extension SignUpInputViewEmailCheckType {
    func setFoucInputTextFiled() { // 포커스 주기
        inputTextField.becomeFirstResponder()
    }
   
    func getTextFieldText() -> String { // 텍스트 필드 받아오기
        inputTextField.text ?? ""
    }
   
}
extension SignUpInputViewEmailCheckType {
    @objc private func changeInputTextField(_ sender: UITextField){
        if sender.text?.count == 0 {
            confirmButton.backgroundColor = UIColor(hexCode: "979C9E")
            confirmButton.isEnabled = false
        } else {
            confirmButton.backgroundColor = UIColor(named: "PrimaryColor")
            confirmButton.isEnabled = true
        }
        
    }
    private func getEmailAuthNumber(){
        checkEmailButtonDelegate?.action(textFieldText: inputTextField.text ?? "")
        
    }
    
}
extension SignUpInputViewEmailCheckType: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        bottomLine.backgroundColor = UIColor(named: "PrimaryColor")
        confirmButton.backgroundColor = UIColor(named: "PrimaryColor")
        checkEmailTextFieldDelegate?.didBegin()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        bottomLine.backgroundColor = UIColor(hexCode: "EAEAEA")
        confirmButton.backgroundColor = UIColor(hexCode: "979C9E")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

