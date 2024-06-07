//
//  SignUpInputViewNicknameType.swift
//  GNUting
//
//  Created by 원동진 on 5/1/24.
//

import UIKit


protocol NicknameCheckButtonDelegate {
    func action(textFieldText: String)
}
protocol NicknameTextfiledDelegate {
    func didBegin()
    func endEdit(textFieldText: String)
}

class SignUpInputViewNicknameType : UIView{
    var nicknameCheckButtonDelegate: NicknameCheckButtonDelegate?
    var nicknameTextfiledDelegate: NicknameTextfiledDelegate?
    private lazy var inputTypeLabel : UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = Pretendard.medium(size: 14)
        return label
    }()
    
    private lazy var inputTextField : UITextField = {
        let textField = UITextField()
        textField.font = Pretendard.regular(size: 12)
        textField.delegate = self
        textField.addTarget(self, action: #selector(changeInputTextField(_:)), for: .editingChanged)
        
        return textField
    }()
    private lazy var emailLabel : UILabel = {
        let uiLabel = UILabel()
        uiLabel.text = "@gnu.ac.kr"
        uiLabel.font = Pretendard.regular(size: 14)
        
        return uiLabel
    }()
    private let bottomLine : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "EAEAEA")
        return view
    }()
    private lazy var nicknameCheckButton : ThrottleButton = {
        
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
    private lazy var inputCheckLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Pretendard.medium(size: 12)
        label.isHidden = true
        
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
extension SignUpInputViewNicknameType{
    private func setAddSubViews() {
        addSubViews([inputTypeLabel,inputTextField,bottomLine,nicknameCheckButton,inputCheckLabel])
                     
    }
    private func setAutoLayout(){
        inputTypeLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()

        }
        inputTextField.snp.makeConstraints { make in
            make.top.equalTo(inputTypeLabel.snp.bottom).offset(6)
            make.left.equalToSuperview()
        }
        bottomLine.snp.makeConstraints { make in
            make.top.equalTo(inputTextField.snp.bottom).offset(6)
            make.height.equalTo(1)
            make.width.equalTo(inputTextField)
            
        }
        inputCheckLabel.snp.makeConstraints { make in
            make.top.equalTo(bottomLine.snp.bottom).offset(6)
            make.left.right.bottom.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        nicknameCheckButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.left.equalTo(inputTextField.snp.right).offset(15)
            
            make.width.equalTo(80)
        }
        
        
    }
}
extension SignUpInputViewNicknameType {
    func setFoucInputTextFiled() { // 포커스 주기
        inputTextField.becomeFirstResponder()
    }
   
    func getTextFieldText() -> String { // 텍스트 필드 받아오기
        inputTextField.text ?? ""
    }
    func setCheckLabel(isHidden: Bool,text: String?,success:Bool){
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
}
extension SignUpInputViewNicknameType {
    @objc private func changeInputTextField(_ sender: UITextField){
        if sender.text?.count == 0 {
            nicknameCheckButton.backgroundColor = UIColor(hexCode: "979C9E")
        } else {
            nicknameCheckButton.backgroundColor = UIColor(named: "PrimaryColor")
        }
        
    }
    private func getNickname(){
        nicknameCheckButtonDelegate?.action(textFieldText: inputTextField.text ?? "")
        
    }
    
}
extension SignUpInputViewNicknameType: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        bottomLine.backgroundColor = UIColor(named: "PrimaryColor")
        nicknameTextfiledDelegate?.didBegin()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        bottomLine.backgroundColor = UIColor(hexCode: "EAEAEA")
        nicknameTextfiledDelegate?.endEdit(textFieldText: textField.text ?? "")
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


