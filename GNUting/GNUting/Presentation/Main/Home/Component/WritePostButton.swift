//
//  WritePostButton.swift
//  GNUting
//
//  Created by 원동진 on 5/1/24.
//

import UIKit
protocol  WritePostButtonDelegate{
    func tapButton()
}
class WritePostButton: UIButton {
    var writePostButtonDelegate: WritePostButtonDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 17, bottom: 10, trailing: 17)
        
        config.attributedTitle = AttributedString("게시글 작성하기", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: Pretendard.Medium.rawValue, size: 12)!,NSAttributedString.Key.foregroundColor : UIColor.white]))
        self.configuration = config
        self.configuration = config
        self.backgroundColor = UIColor(named: "SecondaryColor")
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.addTarget(self, action: #selector(tapWritePostButton), for: .touchUpInside)
     
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc private func tapWritePostButton() {
        writePostButtonDelegate?.tapButton()
    }
}
