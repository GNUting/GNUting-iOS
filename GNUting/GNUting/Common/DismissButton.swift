//
//  DismissButton.swift
//  GNUting
//
//  Created by 원동진 on 4/9/24.
//

import UIKit


class DismissButton : UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setBackButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension DismissButton {
    private func setBackButton(){
        self.setImage(UIImage(named: "DissmissImg"), for: .normal)
        self.tintColor = UIColor(named: "IconColor")
        
    }
    
}
