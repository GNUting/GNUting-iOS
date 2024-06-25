//
//  InputAddButtonView.swift
//  GNUting
//
//  Created by 원동진 on 2/8/24.
// Code 정리 Start

// MARK: - 회원가입, 비밀번호찾기, 프로필 업데이트, InputView

import Foundation
import UIKit

// MARK: - Protocol

protocol PasswordDelegate: AnyObject {
    func passwordkeyBoardReturn(text: String)
}

protocol PasswordCheckDelegate: AnyObject {
    func passwordCheckKeyboardReturn(text: String)
}

protocol InputViewTextFiledDelegate: AnyObject {
    func shouldEndEdting()
}

protocol PhoneNumberDelegate: AnyObject {
    func phoneNumberKeyBoardReturn(textFieldCount: Int)
}

final class CommonInputView: UIView {
    
    // MARK: - Properties
    
    public weak var passwordDelegate: PasswordDelegate? // 비밀번호 return action
    var passwordCheckDelegate: PasswordCheckDelegate? // 비밀번호 확인
    var inputViewTextFiledDelegate: InputViewTextFiledDelegate? // return or 입력이 끝났을때 action
    var phoneNumberDelegate: PhoneNumberDelegate? // return or 입력이 끝났을때 action
    var textFieldType: SignUpInputViewType? // inputView 타입
    
    // MARK: - SubViews
    
    private lazy var inputTextTypeLabel: UILabel = {
        let label = UILabel()
        label.font = Pretendard.medium(size: 14)
        
        return label
    }()
    
    private lazy var inputTextField : UITextField = {
        let textField = UITextField()
        textField.font = Pretendard.regular(size: 12)
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var borderView = BorderView()
    
    private lazy var inputCheckLabel: UILabel = { // 입력값에 따른 분기처리를 위한 Label
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(named: "PrimaryColor")
        label.font = Pretendard.bold(size: 12)
        label.isHidden = true
        label.numberOfLines = 2
        
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

extension CommonInputView {
    private func setAddSubViews() {
        self.addSubViews([inputTextTypeLabel,inputTextField,borderView,inputCheckLabel])
    }

    private func setAutoLayout() {
        inputTextTypeLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        inputTextField.snp.makeConstraints { make in
            make.top.equalTo(inputTextTypeLabel.snp.bottom).offset(14)
            make.left.right.equalToSuperview()
        }
        
        borderView.snp.makeConstraints { make in
            make.top.equalTo(inputTextField.snp.bottom).offset(6)
            make.left.right.equalToSuperview()
        }
        
        inputCheckLabel.snp.makeConstraints { make in
            make.top.equalTo(borderView.snp.bottom).offset(4)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - Method private

extension CommonInputView {
    private func format(mask: String, phone: String) -> String { // 전화번호 format 함수
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        
        return result
    }
    
    private func textFieldHandler(textFieldText: String) { // 텍스트필드 타입에 따른 action 처리
        if textFieldType == .password {
            passwordDelegate?.passwordkeyBoardReturn(text: textFieldText)
        } else if textFieldType == .passwordCheck {
            passwordCheckDelegate?.passwordCheckKeyboardReturn(text: textFieldText)
        } else if textFieldType == .phoneNumber {
            phoneNumberDelegate?.phoneNumberKeyBoardReturn(textFieldCount: textFieldText.count)
        }
    }
}

// MARK: - Method public

extension CommonInputView {
    
    // MARK: - Set
    
    public func setInputTextTypeLabel(text: String) { // 입력 카테고리 Label
        inputTextTypeLabel.text = text
    }
    
    public func setPlaceholder(placeholder: String) { // textField placeholder 설정
        inputTextField.placeholder = placeholder
    }
    
    public func setTextField(text: String) { // textField text 설정
        inputTextField.text = text
    }
    
    public func isEmpty() -> Bool { // textField isEmpty 확인
        return inputTextField.text?.count == 0 ? true : false
    }
    
    public func setInputCheckLabel(isHidden: Bool, text: String?, success: Bool) { // inputCheckLabel 설정
        inputCheckLabel.isHidden = isHidden
        inputCheckLabel.text = text
        
        if success {
            inputCheckLabel.textColor = UIColor(named: "SecondaryColor")
        } else {
            inputCheckLabel.textColor = UIColor(named: "PrimaryColor")
        }
    }
    
    public func setKeyboardTypeNumberPad() { // 키보드 숫자 타입
        inputTextField.keyboardType = .numberPad
    }
    
    public func setSecureTextEntry() { // 비밀번호
        inputTextField.isSecureTextEntry = true
    }
    
    // MARK: - Get
    
    public func getTextFieldText() -> String {
        inputTextField.text ?? ""
    }
}

// MARK: - Delegate

extension CommonInputView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) { // TextField 입력 시작
        borderView.enableColor()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // Return 누
        textFieldHandler(textFieldText: textField.text ?? "")
        inputViewTextFiledDelegate?.shouldEndEdting()
        
        return textField.resignFirstResponder()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldHandler(textFieldText: textField.text ?? "")
        inputViewTextFiledDelegate?.shouldEndEdting()
        borderView.disableColor()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        
        switch textFieldType {
        case .phoneNumber:
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = format(mask:"XXX-XXXX-XXXX", phone: newString)
            
            return false
        case .name:
            guard textField.text?.count ?? 0 < 8 else { return false }
        case .nickname:
            guard textField.text?.count ?? 0 < 10 else { return false }
        case .studentID:
            guard textField.text?.count ?? 0 < 2 else { return false }
        case .introduce:
            guard textField.text?.count ?? 0 < 30 else { return false }
        default:
            break
        }
        
        return true
    }
}
