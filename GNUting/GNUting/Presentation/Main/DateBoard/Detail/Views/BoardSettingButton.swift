//
//  BoardSettingButton.swift
//  GNUting
//
//  Created by 원동진 on 3/15/24.
//

// MARK: - 게시글 Detail 신고,삭제,수정 관련 Button

import UIKit

class BoardSettingButton: UIButton {
    
    // MARK: - init
    
    init(text: String) {
        super.init(frame: .zero)
        setButton(text: text)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetView
    
    func setButton(text: String) {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("\(text)", attributes: AttributeContainer([NSAttributedString.Key.font: Pretendard.regular(size: 12) ?? .systemFont(ofSize: 12)]))
        config.baseForegroundColor = .black
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 15, bottom: 10, trailing: 130)
        self.configuration = config
        
    }
}
