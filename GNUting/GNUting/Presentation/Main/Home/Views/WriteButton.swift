//
//  WriteButton.swift
//  GNUting
//
//  Created by 원동진 on 5/1/24.
//

// MARK: - 홈 화면 게시글,메모 작성하기 Button

import UIKit

// MARK: - protocol

protocol  WriteButtonDelegate: AnyObject {
    func tapButtonAction(tag: Int)
}

final class WriteButton: UIButton {
    
    // MARK: - Properties
    
    weak var writeButtonDelegate: WriteButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    // MARK: - Init
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internanl Method Set
    
    func setConfiguration(text: String, textColor: UIColor, backgroundColor: UIColor,tag: Int) {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 17, bottom: 10, trailing: 17)
        config.attributedTitle = AttributedString("\(text)", attributes: AttributeContainer([NSAttributedString.Key.font: Pretendard.medium(size: 12) ?? .boldSystemFont(ofSize: 12),NSAttributedString.Key.foregroundColor: textColor]))
        self.configuration = config
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.addTarget(self, action: #selector(tapWritePostButton), for: .touchUpInside)
        self.tag = tag
    }
    
    // MARK: - Action
    
    @objc private func tapWritePostButton() {
        UIView.animate(withDuration: 0.2) {
            let scale = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.transform = scale

        } completion: { finished in
            UIView.animate(withDuration: 0.2) {
                self.transform = .identity
            }
            self.writeButtonDelegate?.tapButtonAction(tag: self.tag)
        }
    }
}
