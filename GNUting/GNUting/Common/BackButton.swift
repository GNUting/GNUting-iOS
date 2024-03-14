//
//  BackButton.swift
//  GNUting
//
//  Created by 원동진 on 3/7/24.
//

import UIKit

class BackButton : UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setBackButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension BackButton {
    private func setBackButton(){
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "PopImg")
        config.baseForegroundColor = UIColor(hexCode: "504A4A")
        config.imagePlacement = .leading
        config.imagePadding = 5
        self.configuration = config
    }
}

