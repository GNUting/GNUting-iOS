//
//  PrimaryColorButton.swift
//  GNUting
//
//  Created by 원동진 on 2024/01/23.
//

import Foundation
import UIKit
import SnapKit
class PrimaryColorButton : UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "PrimaryColor")
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.isUserInteractionEnabled = true
        self.setTitleColor(.white, for: .disabled)
        self.snp.makeConstraints { make in
            make.height.equalTo(65)
        }
    }
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.backgroundColor = UIColor(named: "PrimaryColor")
            } else {
                self.backgroundColor = UIColor(named: "DisableColor")
            }
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func setText(_ text : String){
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 22, leading: 10, bottom: 22, trailing: 10)
        config.attributedTitle = AttributedString("\(text)", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: Pretendard.Bold.rawValue, size: 20)!]))
        config.titleAlignment = .center
        config.baseForegroundColor = .white
        self.configuration = config
    }
    
}
 
