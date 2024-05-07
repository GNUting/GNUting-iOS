//
//  SignupInputViewAuthNumType.swift
//  GNUting
//
//  Created by 원동진 on 4/30/24.
//

import UIKit

protocol ConfirmButtonDelegate {
    func action(sendTextFieldText: String)
}
class SignUpInputViewAuthNumType : UIView{
    var confirmButtonDelegate: ConfirmButtonDelegate?
    
    private lazy var inputTextTypeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Medium.rawValue, size: 14)
        label.text = "인증번호"
        return label
    }()
    
    private lazy var inputTextField : UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: Pretendard.Regular.rawValue, size: 12)
        textField.delegate = self
        textField.addTarget(self, action: #selector(changeInputTextField(_:)), for: .editingChanged)
        textField.keyboardType = .numberPad
        return textField
    }()
    private lazy var confirmButton : ThrottleButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        config.attributedTitle = AttributedString("확인", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: Pretendard.Regular.rawValue, size: 14)!]))
        config.titleAlignment = .center
        config.baseForegroundColor = .white
        
        let button = ThrottleButton(configuration: config)
        button.backgroundColor = UIColor(hexCode: "979C9E")
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.throttle(delay: 3) { _ in
            self.confrimButtonAction()
        }
        
        return button
    }()
    
    private let bottomLine : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "EAEAEA")
        return view
    }()
    private lazy var inputCheckLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: Pretendard.Medium.rawValue, size: 12)
        label.isHidden = true
        
        return label
    }()
    private lazy var remainNumberLabel : UILabel = {
       let label = UILabel()
        label.text = "03:00"
        label.textColor = UIColor(named: "PrimaryColor")
        label.font = UIFont(name: Pretendard.Medium.rawValue, size: 12)
        return label
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
extension SignUpInputViewAuthNumType{
    private func setAddSubViews() {
        addSubViews([inputTextTypeLabel,inputTextField,bottomLine,inputCheckLabel,remainNumberLabel,confirmButton])
    }
    private func setAutoLayout(){
        inputTextTypeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        inputTextField.snp.makeConstraints { make in
            make.top.equalTo(inputTextTypeLabel.snp.bottom).offset(10)
            make.left.equalToSuperview()
        }
        bottomLine.snp.makeConstraints { make in
            make.top.equalTo(inputTextField.snp.bottom).offset(6)
            make.height.equalTo(1)
            make.left.equalToSuperview()
            make.width.equalTo(inputTextField)
        }
        inputCheckLabel.snp.makeConstraints { make in
            make.top.equalTo(bottomLine.snp.bottom).offset(6)
            make.left.bottom.equalToSuperview()
            
        }
        remainNumberLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(inputTextField.snp.right).offset(15)
            
        }
        confirmButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(remainNumberLabel.snp.right).offset(15)
            make.right.equalToSuperview()
            make.width.equalTo(80)
        }
        
        
    }
    func setCheckLabel(isHidden: Bool, text: String?, success: Bool){
        inputCheckLabel.isHidden = isHidden
        if !isHidden {
            inputCheckLabel.text = text
        }
        if success {
            inputCheckLabel.textColor = UIColor(named: "SecondaryColor")
        } else {
            inputCheckLabel.textColor = UIColor(named: "PrimaryColor")
        }
        
    }
    func setRemainLabel(text: String?) {
        remainNumberLabel.text = text
    }
}
extension SignUpInputViewAuthNumType{
    
    func setFoucInputTextFiled() {
        inputTextField.becomeFirstResponder()
    }
    
    func getTextFieldText() -> String {
        inputTextField.text ?? ""
    }
}

extension SignUpInputViewAuthNumType {
    @objc private func changeInputTextField(_ sender: UITextField){
        if sender.text?.count == 0 {
            confirmButton.backgroundColor = UIColor(hexCode: "979C9E")
            confirmButton.isEnabled = false
        } else {
            confirmButton.backgroundColor = UIColor(named: "PrimaryColor")
            confirmButton.isEnabled = true
        }
        
    }
    
    private func confrimButtonAction(){
        confirmButtonDelegate?.action(sendTextFieldText: inputTextField.text ?? "")
    }
}
extension SignUpInputViewAuthNumType: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        bottomLine.backgroundColor = UIColor(named: "PrimaryColor")
        
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        bottomLine.backgroundColor = UIColor(hexCode: "EAEAEA")
        
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
