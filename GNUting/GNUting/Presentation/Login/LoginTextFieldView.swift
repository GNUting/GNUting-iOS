//
//  LoginTextFieldView.swift
//  GNUting
//
//  Created by 원동진 on 4/18/24.
//

// MARK: - 로그인 화면 TextFiledView

import UIKit

class LoginTextFieldView: UIView {
    
    // MARK: - Properties
    
    private lazy var textField : PaddingTextField = {
        let paddingTextField = PaddingTextField()
        paddingTextField.backgroundColor = .white
        paddingTextField.layer.cornerRadius = 10
        paddingTextField.layer.masksToBounds = true
        paddingTextField.delegate = self
        
        return paddingTextField
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConfigure()
        setShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MAKR: - Method

extension LoginTextFieldView {
    
    // MARK: - Layout Helpers
    
    private func setConfigure() {
        self.addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - SetView
    
    private func setShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.1
    }
    
    func setTextFieldPlaceHolder(text: String){
        textField.attributedPlaceholder = NSAttributedString(string: text,attributes: [NSAttributedString.Key.font : Pretendard.regular(size: 20) ?? .systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor : UIColor(hexCode: "7D7D7D")])
    }
    func setPasswordTypeTextField() {
        textField.isSecureTextEntry = true
    }
    func getTextFieldString() -> String {
        return textField.text ?? ""
    }
}

// MARK: - Delegate

extension LoginTextFieldView: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

