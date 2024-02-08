//
//  InputAddButtonView.swift
//  GNUting
//
//  Created by 원동진 on 2/8/24.
//

import Foundation
import UIKit
class SignUPInpuView : UIView {
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
    private lazy var inputCheckLabel : UILabel = {
        let label = UILabel()
        label.text = "틀렸습니다."
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
extension SignUPInpuView{
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
extension SignUPInpuView{
    public func setInputTextTypeLabel(text : String){
        inputTextTypeLabel.text = text
    }
    public func setPlaceholder(placeholder : String){
        inputTextField.placeholder = placeholder
    }
    public func setConfirmButton(text : String){
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        config.attributedTitle = AttributedString("\(text)", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: Pretendard.Regular.rawValue, size: 14)!]))
        config.titleAlignment = .center
        config.baseForegroundColor = .white
        confirmButton.configuration = config
    }
    
    public func setUnderLineColor(color : UIColor){
        bottomLine.backgroundColor = color
    }
    public func isEmailTextField(eamilField : Bool){
        emailLabel.isHidden = !eamilField
    }
    public func setAddButton(AddButton : Bool){
        confirmButton.isHidden = !AddButton
    }
    public func checkLabelHidden(isHidden : Bool){
        inputCheckLabel.isHidden = isHidden
    }
}
