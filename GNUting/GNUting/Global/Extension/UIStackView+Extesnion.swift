//
//  UIStackView+Extesnion.swift
//  GNUting
//
//  Created by 원동진 on 2024/01/24.
//

import UIKit

extension UIStackView{
    func addStackSubViews(_ views : [UIView]){
        _ = views.map{self.addArrangedSubview($0)}
    }
}
