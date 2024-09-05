//
//  WritePostButton.swift
//  GNUting
//
//  Created by 원동진 on 5/1/24.
//

// MARK: - 홈 화면 게시글 작성하기 버튼 (초기 두개의 VC에서 이용됬으나 현재 Home에서만 사용)

import UIKit

// MARK: - protocol

protocol  WritePostButtonDelegate: AnyObject {
    func tapButtonAction()
}

class WritePostButton: UIButton {
    
    // MARK: - Properties
    weak var writePostButtonDelegate: WritePostButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setConfiguration()
    }
    
    // MARK: - Init
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Method Set
    
    private func setConfiguration() {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 17, bottom: 10, trailing: 17)
        config.attributedTitle = AttributedString("게시글 작성하기", attributes: AttributeContainer([NSAttributedString.Key.font: Pretendard.medium(size: 12) ?? .boldSystemFont(ofSize: 12),NSAttributedString.Key.foregroundColor : UIColor.white]))
        self.configuration = config
        self.backgroundColor = UIColor(named: "SecondaryColor")
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.addTarget(self, action: #selector(tapWritePostButton), for: .touchUpInside)
    }
    
    // MARK: - Action
    
    @objc private func tapWritePostButton() {
        writePostButtonDelegate?.tapButtonAction()
    }
}
