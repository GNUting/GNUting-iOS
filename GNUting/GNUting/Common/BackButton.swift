//
//  BackButton.swift
//  GNUting
//
//  Created by 원동진 on 2/18/24.
//

import Foundation
import UIKit
class BackButton : UIButton {
   
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    public func setConfigure(text: String){
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("\(text)", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: Pretendard.Medium.rawValue, size: 18)!]))
        config.image = UIImage(named: "PopImg")
        config.baseForegroundColor = UIColor(hexCode: "504A4A")
        config.imagePlacement = .leading
        config.imagePadding = 5
        self.configuration = config
    }
    
}

