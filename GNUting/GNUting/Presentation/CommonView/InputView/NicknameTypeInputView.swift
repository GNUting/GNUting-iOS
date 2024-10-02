//
//  SignUpInputViewNicknameType.swift
//  GNUting
//
//  Created by 원동진 on 5/1/24.
//

// MARK: - 회원가입, 프로필 업데이트 닉네임 InputView

import UIKit

// MARK: - Protocol

protocol NicknameCheckButtonDelegate: AnyObject {
    func action(textFieldText: String)
}
protocol NicknameTextfiledDelegate: AnyObject {
    func didBegin()
    func endEdit()
}

final class NicknameTypeInputView: UIView {
    
    // MARK: - Properties
    
    weak var nicknameCheckButtonDelegate: NicknameCheckButtonDelegate?
    weak var nicknameTextfiledDelegate: NicknameTextfiledDelegate?
    
    // MARK: - SubViews
    
    private lazy var inputTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = Pretendard.medium(size: 14)
        
        return label
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
    
    private let borderView = BorderView()
    
    private lazy var nicknameCheckButton: ThrottleButton = {
        
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        config.attributedTitle = AttributedString("중복확인", attributes: AttributeContainer([NSAttributedString.Key.font: Pretendard.regular(size: 14) ?? .systemFont(ofSize: 14)]))
        config.titleAlignment = .center
        config.baseForegroundColor = .white
        
        let button = ThrottleButton(configuration: config)
        
        button.backgroundColor = UIColor(hexCode: "979C9E")
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.throttle(delay: 3) { _ in
            self.getNickname()
        }
        
        return button
    }()
    
    private lazy var inputCheckLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Pretendard.medium(size: 12)
        label.isHidden = true
        
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

extension NicknameTypeInputView {
    private func setAddSubViews() {
        addSubViews([inputTypeLabel, inputTextField, borderView, nicknameCheckButton, inputCheckLabel])
    }
    
    private func setAutoLayout() {
        inputTypeLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        inputTextField.snp.makeConstraints { make in
            make.top.equalTo(inputTypeLabel.snp.bottom).offset(6)
            make.left.equalToSuperview()
        }
        
        borderView.snp.makeConstraints { make in
            make.top.equalTo(inputTextField.snp.bottom).offset(6)
            make.width.equalTo(inputTextField)
        }
        
        inputCheckLabel.snp.makeConstraints { make in
            make.top.equalTo(borderView.snp.bottom).offset(6)
            make.left.right.bottom.equalToSuperview()
        }
        
        nicknameCheckButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.left.equalTo(inputTextField.snp.right).offset(15)
            make.width.equalTo(80)
        }
    }
}

// MARK: - Method

extension NicknameTypeInputView {
    
    // MARK: - Set
    
   func setCheckLabel(isHidden: Bool, text: String?, success: Bool) {
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
    
    func setTextField(text: String) {
        inputTextField.text = text
    }
    
    // MARK: - Get
    
    func getTextFieldText() -> String { // 텍스트 필드 받아오기
        inputTextField.text ?? ""
    }
    private func isOnlyWhitespace(text: String) -> Bool {
        return text.range(of: "^[\\s]*$", options: .regularExpression) != nil
    }
    
}

// MARK: - Button Action

extension NicknameTypeInputView {
    @objc private func changeInputTextField(_ sender: UITextField) {
        if sender.text?.count == 0 {
            nicknameCheckButton.backgroundColor = UIColor(hexCode: "979C9E")
        } else {
            nicknameCheckButton.backgroundColor = UIColor(named: "PrimaryColor")
        }
    }
    
    private func getNickname() {
        nicknameCheckButtonDelegate?.action(textFieldText: inputTextField.text ?? "")
    }
}

// MARK: - Delegate

extension NicknameTypeInputView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        borderView.enableColor()
        nicknameTextfiledDelegate?.didBegin()
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        borderView.disableColor()
        
        if isOnlyWhitespace(text: textField.text ?? "") {
            setCheckLabel(isHidden: false, text: "공백만 입력 되었습니다.", success: false)
            nicknameCheckButton.isEnabled = false
        } else {
            nicknameCheckButton.isEnabled = true
            nicknameTextfiledDelegate?.endEdit()
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
       
        
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        guard textField.text?.count ?? 0 < 10 else { return false }
        
        return true
    }
}


