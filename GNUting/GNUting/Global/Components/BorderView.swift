//
//  BorderView.swift
//  GNUting
//
//  Created by 원동진 on 5/5/24.
//

import UIKit

class BorderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BorderView {
    private func configure() {
        self.backgroundColor = UIColor(named: "BorderColor")
        self.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
}
extension BorderView {
    func disableColor() {
        self.backgroundColor = UIColor(named: "BorderColor")
    }

    func enableColor() {
        self.backgroundColor = UIColor(named: "PrimaryColor")
    }
}
