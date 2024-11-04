//
//  BasePaddingLabel.swift
//  GNUting
//
//  Created by 원동진 on 2/29/24.
//

import UIKit
class BasePaddingLabel: UILabel {

    private var padding = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)

    convenience init(padding: UIEdgeInsets, text: String = "", textColor: UIColor, textAlignment: NSTextAlignment = .left, font: UIFont) {
        self.init()
        
        self.padding = padding
        self.text = text
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.font = font
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
    
    
}
