//
//  SignupInputViewAuthNumType.swift
//  GNUting
//
//  Created by 원동진 on 4/30/24.
//

// MARK: - 인증번호 InputView

import UIKit

// MARK: - Protocol

protocol AuthNumberInputViewDelegate: AnyObject {
    func tapComfirmButton(authNumber: String)
}

final class AuthNumberInputView: UIView {
    
    // MARK: - Properties
    
     weak var authNumberInputViewDelegate: AuthNumberInputViewDelegate?
    
    // MARK: - SubViews
    
    private lazy var inputTextTypeLabel: UILabel = {
        let label = UILabel()
        label.font = Pretendard.medium(size: 14)
        label.text = "인증번호"
        
        return label
    }()
    
    private lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.font = Pretendard.regular(size: 12)
        textField.delegate = self
        textField.addTarget(self, action: #selector(changeInputTextField(_:)), for: .editingChanged)
        textField.keyboardType = .numberPad
        
        return textField
    }()
    
    private lazy var confirmButton: ThrottleButton = {
        let button = ConfirmButton()
        button.setConfiguration(title: "확인")
        button.throttle(delay: 3) { _ in
            self.tapConfirmButton()
        }
        
        return button
    }()
    
    private lazy var borderView = BorderView()
    
    private lazy var inputCheckLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Pretendard.medium(size: 12)
        label.isHidden = true
        
        return label
    }()
    
    private lazy var remainNumberLabel: UILabel = { // 인증번호 인증 남은 시간
       let label = UILabel()
        label.textColor = UIColor(named: "PrimaryColor")
        label.font = Pretendard.medium(size: 12)
        
        return label
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout Helpers

extension AuthNumberInputView {
    private func setAddSubViews() {
        addSubViews([inputTextTypeLabel,inputTextField,borderView,inputCheckLabel,remainNumberLabel,confirmButton])
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
        
        borderView.snp.makeConstraints { make in
            make.top.equalTo(inputTextField.snp.bottom).offset(6)
            make.left.equalToSuperview()
            make.width.equalTo(inputTextField)
        }
        
        inputCheckLabel.snp.makeConstraints { make in
            make.top.equalTo(borderView.snp.bottom).offset(6)
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
}

// MARK: - Internal Method SetView

extension AuthNumberInputView {
     func setCheckLabel(isHidden: Bool, text: String?, success: Bool) { // 인증번호 성공 or 실패에 대한 출력 Label
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
    
     func setRemainLabel(text: String?) { // 인증 완료 남은시간 Set
        remainNumberLabel.text = text
    }
    
     func setFoucInputTextFiled() { // 포커스 주기
        inputTextField.becomeFirstResponder()
    }
}

// MARK: - Action

extension AuthNumberInputView {
    @objc private func changeInputTextField(_ sender: UITextField) {
        if sender.text?.count == 0 {
            confirmButton.backgroundColor = UIColor(named: "DisableColor")
            confirmButton.isEnabled = false
        } else {
            confirmButton.backgroundColor = UIColor(named: "PrimaryColor")
            confirmButton.isEnabled = true
        }
        
    }
    
    private func tapConfirmButton() {
        authNumberInputViewDelegate?.tapComfirmButton(authNumber: inputTextField.text ?? "")
    }
}

// MARK: - Delegate

extension AuthNumberInputView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        borderView.enableColor()
        confirmButton.backgroundColor = UIColor(named: "PrimaryColor")
        inputTextField.text = ""
        inputCheckLabel.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        borderView.disableColor()
        confirmButton.backgroundColor = UIColor(named: "DisableColor")
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
