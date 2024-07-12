//
//  LoginTextFieldView.swift
//  GNUting
//
//  Created by 원동진 on 4/18/24.
//

import UIKit

class LoginTextFieldView: UIView {
    private lazy var textField = PaddingTextField()
    override init(frame: CGRect) {
        super.init(frame: frame)
        seTextField()
        setShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension LoginTextFieldView {
    private func setShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.1
    }
    private func seTextField() {
        self.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.delegate = self
    }
    func setTextFieldPlaceHolder(text: String){
        textField.attributedPlaceholder = NSAttributedString(string: text,attributes: [NSAttributedString.Key.font : Pretendard.regular(size: 20) ?? .systemFont(ofSize: 20),NSAttributedString.Key.foregroundColor : UIColor(hexCode: "7D7D7D")])
    }
    func setPasswordTypeTextField() {
        textField.isSecureTextEntry = true
    }
    func getTextFieldString() -> String {
        return textField.text ?? ""
    }
}
extension LoginTextFieldView: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

