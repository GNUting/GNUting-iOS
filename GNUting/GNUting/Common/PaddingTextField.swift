//
//  PaddingTextField.swift
//  GNUting
//
//  Created by 원동진 on 2024/01/24.
//

import Foundation
import UIKit

class PaddingTextField : UITextField {
    var textPadding = UIEdgeInsets(top: 20, left: 25, bottom: 20, right: 25)
    convenience init(textPadding: UIEdgeInsets) {
        self.init()
        self.textPadding = textPadding
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
