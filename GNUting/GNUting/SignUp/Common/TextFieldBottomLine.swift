//
//  bottomLineTextField.swift
//  GNUting
//
//  Created by 원동진 on 2/8/24.
//

import Foundation
import UIKit
import SnapKit
class TextFieldBottomLine : UITextField{
    private let bottomLine = UIView()
    private let underLineColor = UIColor(hexCode: "EAEAEA")
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBottomBorderLine()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension TextFieldBottomLine{
    func addBottomBorderLine(){
        self.borderStyle = .none
        bottomLine.backgroundColor = underLineColor
        self.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { make in
            make.top.equalTo(self.snp.bottom).offset(1)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(1)
        }
    }
    public func setUnderLineColor(color : UIColor){
        bottomLine.backgroundColor = color
    }
}
