//
//  ConfirmButton.swift
//  GNUting
//
//  Created by 원동진 on 5/29/24.
//

// MARK: - 인증 받기/확인 버튼

import UIKit

final class ConfirmButton: ThrottleButton {
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Method

extension ConfirmButton {
    public func setConfiguration(title: String) {
        var configuration = UIButton.Configuration.plain()
        
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        configuration.attributedTitle = AttributedString("\(title)", attributes: AttributeContainer([NSAttributedString.Key.font : Pretendard.regular(size: 14) ?? .systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.white]))
        configuration.titleAlignment = .center
        configuration.baseForegroundColor = .white
        self.configuration = configuration
    }
}

// MARK: - Private Method

extension ConfirmButton {
    private func setButton() {
        self.backgroundColor = UIColor(named: "DisableColor")
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
}
