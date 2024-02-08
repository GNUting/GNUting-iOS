//
//  InputAddButtonView.swift
//  GNUting
//
//  Created by 원동진 on 2/8/24.
//

import Foundation
import UIKit
class InputAddButtonView : UIView {
    private lazy var inputTextTypeLabel : UILabel = {
        let uiLabel = UILabel()
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
    private lazy var inputTextField : TextFieldBottomLine = {
        let textField = TextFieldBottomLine()
        textField.backgroundColor = .blue
        return textField
    }()
    private lazy var confirmButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hexCode: "979C9E")
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension InputAddButtonView{
    private func configure(){
        self.addSubViews([inputTextTypeLabel,bottomStackView])
        bottomStackView.addStackSubViews([inputTextField,confirmButton])
        inputTextTypeLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        bottomStackView.snp.makeConstraints { make in
            make.top.equalTo(inputTextTypeLabel)
            make.bottom.left.right.equalToSuperview()
        }
    }
    public func setInputTextTypeLabel(text : String){
        inputTextTypeLabel.text = text
    }
    public func setConrimButton(text : String){
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        config.attributedTitle = AttributedString("\(text)", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: Pretendard.Bold.rawValue, size: 15)!]))
        config.titleAlignment = .center
        config.baseForegroundColor = .white
        confirmButton.configuration = config
    }
    
}
