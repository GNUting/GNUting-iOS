//
//  UIImage+Extension.swift
//  GNUting
//
//  Created by 원동진 on 3/11/24.
//

import UIKit

extension UIImage {
    var hasAlpha: Bool {
        guard let alphaInfo = self.cgImage?.alphaInfo else { return false }
        
        return alphaInfo != .none &&
        alphaInfo != .noneSkipFirst &&
        alphaInfo != .noneSkipLast
    }
}
