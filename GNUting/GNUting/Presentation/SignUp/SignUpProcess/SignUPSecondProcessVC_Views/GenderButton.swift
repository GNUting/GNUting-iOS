//
//  GenderButton.swift
//  GNUting
//
//  Created by 원동진 on 6/26/24.
//

// MARK: - 회원가입 2 남,여 버튼

import UIKit

protocol GenderButtonDelegate: AnyObject {
    func tapButton(tag: Int)
}

final class GenderButton: UIButton {
    
    // MARK: - Properties
    
    weak public var genderButtonDelegate: GenderButtonDelegate?
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundColor = UIColor(named: "PrimaryColor")?.withAlphaComponent(0.3)
                self.configuration?.baseForegroundColor = UIColor(named: "PrimaryColor")
                self.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
                
            } else {
                self.backgroundColor =  UIColor(hexCode: "F5F5F5")
                self.configuration?.baseForegroundColor = UIColor(hexCode: "767676")
                self.layer.borderColor = UIColor(hexCode: "EAEAEA").cgColor
            }
        }
    }
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setButton()
        setButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure

extension GenderButton {
    private func setButton() {
        self.layer.borderColor = UIColor(hexCode: "EAEAEA").cgColor
        self.backgroundColor = UIColor(hexCode: "F5F5F5")
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.setBackgroundImage(nil, for: .selected)
        self.tintColor = .clear
    }
}

// MARK: - Method public

extension GenderButton {
    public func setGenderButton(title: String, tag: Int) {
        var configuration = UIButton.Configuration.plain()
        
        configuration.attributedTitle = AttributedString(title, attributes: AttributeContainer([NSAttributedString.Key.font: Pretendard.medium(size: 16) ?? .systemFont(ofSize: 16)]))
        configuration.baseForegroundColor = UIColor(hexCode: "767676")
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10)
        configuration.titleAlignment = .center
        
        self.tag = tag
        self.configuration = configuration
    }
}

// MARK: - Action

extension GenderButton {
    private func setButtonAction() {
        self.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }
    
    @objc private func tapButton() {
        genderButtonDelegate?.tapButton(tag: self.tag)
    }
}
