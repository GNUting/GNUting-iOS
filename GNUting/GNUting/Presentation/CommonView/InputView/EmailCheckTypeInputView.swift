//
//  SignupInputViewEmailCheckType.swift
//  GNUting
//
//  Created by 원동진 on 4/30/24.
//

// MARK: - 이메일 인증 InputView

import UIKit

// MARK: - protocol

protocol EmailCheckTypeInputViewDelegate: AnyObject {
    func tapButtonAction(textFieldText: String)
    func didBeginTextfield()
}

final class EmailCheckTypeInputView: UIView {
    
    // MARK: - Properties
    
     weak var emailCheckTypeInputViewDelegate: EmailCheckTypeInputViewDelegate?
    
    // MARK: - SubViews
    
    private lazy var inputTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "학교 이메일"
        label.font = Pretendard.medium(size: 14)
        
        return label
    }()
    
    private let borderView = BorderView()
    
    private lazy var confirmButton: ConfirmButton = {
        let button = ConfirmButton()
        button.setConfiguration(title: "인증받기")
        button.throttle(delay: 3) { _ in
            self.tapConfirmButton()
        }
        
        return button
    }()
    
    private lazy var middleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        
        return stackView
    }()
    
    private lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.font = Pretendard.regular(size: 12)
        textField.delegate = self
        textField.addTarget(self, action: #selector(changeInputTextField(_:)), for: .editingChanged)
        
        return textField
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "@gnu.ac.kr"
        label.font = Pretendard.regular(size: 14)
        
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

extension EmailCheckTypeInputView {
    private func setAddSubViews() {
        addSubViews([inputTypeLabel, middleStackView, borderView, confirmButton])
        middleStackView.addStackSubViews([inputTextField, emailLabel])
    }
    
    private func setAutoLayout() {
        inputTypeLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        middleStackView.snp.makeConstraints { make in
            make.top.equalTo(inputTypeLabel.snp.bottom).offset(7)
            make.left.equalToSuperview()
        }
        
        borderView.snp.makeConstraints { make in
            make.top.equalTo(middleStackView.snp.bottom).offset(5)
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

// MARK: - Method 

extension EmailCheckTypeInputView {
     func setFoucInputTextFiled() { // 포커스 주기
        inputTextField.becomeFirstResponder()
    }
   
     func getTextFieldText() -> String { // 텍스트 필드 받아오기
        inputTextField.text ?? ""
    }
}

// MARK: - Delegate

extension EmailCheckTypeInputView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        emailCheckTypeInputViewDelegate?.didBeginTextfield()
        borderView.enableColor()
        confirmButton.backgroundColor = UIColor(named: "PrimaryColor")
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

// MARK: - Action

extension EmailCheckTypeInputView {
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
        emailCheckTypeInputViewDelegate?.tapButtonAction(textFieldText: inputTextField.text ?? "")
    }
}
