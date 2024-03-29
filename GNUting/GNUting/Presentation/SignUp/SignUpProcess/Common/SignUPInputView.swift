//
//  InputAddButtonView.swift
//  GNUting
//
//  Created by 원동진 on 2/8/24.
//

import Foundation
import UIKit
protocol CheckEmailButtonDelegate {
    func action(number: String)
}

protocol ConfirmButtonDelegate {
    func action(sendTextFieldText: String)
}

protocol PasswordCheckDelegate {
    func keyboarReturn(text: String)
}

class SignUPInputView : UIView{
    var checkEmailButtonDelegate: CheckEmailButtonDelegate?
    var confirmButtonDelegate: ConfirmButtonDelegate?
    var passwordCheckDelegate : PasswordCheckDelegate?
    var textFieldType : SignUpInputViewType = .email
    
    private lazy var inputTextTypeLabel : UILabel = {
        let uiLabel = UILabel()
        uiLabel.font = UIFont(name: Pretendard.SemiBold.rawValue, size: 14)
        return uiLabel
    }()
    private lazy var bottomStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    private lazy var inputTextField : UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: Pretendard.Medium.rawValue, size: 14)
        textField.delegate = self
        
        return textField
    }()
    private lazy var confirmButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hexCode: "979C9E")
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.isHidden = true
        return button
    }()
    private lazy var emailLabel : UILabel = {
        let uiLabel = UILabel()
        uiLabel.text = "@gnu.ac.kr"
        uiLabel.font = UIFont(name: Pretendard.Regular.rawValue, size: 14)
        uiLabel.isHidden = true
        return uiLabel
    }()
    private let bottomLine : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "EAEAEA")
        return view
    }()
    lazy var inputCheckLabel : UILabel = {
        let label = UILabel()
        label.text = "틀렸습니다."
        label.textAlignment = .right
        label.textColor = UIColor(named: "PrimaryColor")
        label.font = UIFont(name: Pretendard.Bold.rawValue, size: 14)
        label.isHidden = true
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension SignUPInputView{
    private func configure(){
        self.addSubViews([inputTextTypeLabel,bottomStackView,bottomLine,inputCheckLabel])
        bottomStackView.addStackSubViews([inputTextField,emailLabel,confirmButton])
        inputTextTypeLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        bottomStackView.snp.makeConstraints { make in
            make.top.equalTo(inputTextTypeLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
        }
        
        bottomLine.snp.makeConstraints { make in
            make.top.equalTo(bottomStackView.snp.bottom).offset(2)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(1)
        }
        inputCheckLabel.snp.makeConstraints { make in
            make.top.equalTo(bottomLine.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(10)
        }
        inputTextField.setContentHuggingPriority(.init(250), for: .horizontal)
        emailLabel.setContentHuggingPriority(.init(251), for: .horizontal)
        confirmButton.setContentHuggingPriority(.init(251), for: .horizontal)
        emailLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        confirmButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}
extension SignUPInputView{
    func setInputTextTypeLabel(text: String){
        inputTextTypeLabel.text = text
    }
    func setFoucInputTextFiled() {
        inputTextField.becomeFirstResponder()
    }
    func setPlaceholder(placeholder: String){
        inputTextField.placeholder = placeholder
    }
    func setConfirmButton(text: String){
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        config.attributedTitle = AttributedString("\(text)", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: Pretendard.Regular.rawValue, size: 14)!]))
        config.titleAlignment = .center
        config.baseForegroundColor = .white
        confirmButton.configuration = config
        confirmButton.isHidden = false
    }
    
    func setUnderLineColor(color: UIColor){
        bottomLine.backgroundColor = color
    }
    func isEmailTextField(emailField: Bool){
        emailLabel.isHidden = !emailField
    }
    func setCheckLabel(isHidden: Bool,text: String?){
        inputCheckLabel.isHidden = isHidden
        if !isHidden {
            inputCheckLabel.text = text
        }
    }
    func getTextFieldText() -> String {
        inputTextField.text ?? ""
    }
    // 추후 델리게이트로 빼야됨
    func setCheckEmailAction() {
        confirmButton.addTarget(self, action: #selector(getEmailAuthNumber), for: .touchUpInside)
    }
    func setConfrimButton() {
        confirmButton.addTarget(self, action: #selector(confrimButtonAction), for: .touchUpInside)
    }
    
}





extension SignUPInputView {
    @objc private func getEmailAuthNumber(){
        APIPostManager.shared.postEmailCheck(email: (inputTextField.text ?? "") + "@gnu.ac.kr") { checkNumber,error  in
            guard let error = error else {
                self.checkEmailButtonDelegate?.action(number: checkNumber)
                return
            }
            print("error\(error)")
            
            
        }
        
    }
    @objc private func confrimButtonAction(){
        confirmButtonDelegate?.action(sendTextFieldText: inputTextField.text ?? "")
    }
}
extension SignUPInputView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
     
        
        bottomLine.backgroundColor = UIColor(named: "PrimaryColor")
        confirmButton.backgroundColor = UIColor(named: "PrimaryColor")
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        bottomLine.backgroundColor = UIColor(hexCode: "EAEAEA")
        confirmButton.backgroundColor = UIColor(hexCode: "979C9E")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textFieldType == .passwordCheck {
            passwordCheckDelegate?.keyboarReturn(text: textField.text ?? "")
        }
        return textField.resignFirstResponder()
    }
}
