//
//  FontRelate.swift
//  GNUting
//
//  Created by 원동진 on 2024/01/23.
//

import UIKit

struct Pretendard {
    private init() {}
    
    static func regular(size: CGFloat) -> UIFont? {
        return UIFont(name: "Pretendard-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func thin(size: CGFloat) -> UIFont? {
        return UIFont(name: "Pretendard-Thin", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func extraLight(size: CGFloat) -> UIFont? {
        return UIFont(name: "Pretendard-ExtraLight", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func light(size: CGFloat) -> UIFont? {
        return UIFont(name: "Pretendard-Light", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func medium(size: CGFloat) -> UIFont? {
        return UIFont(name: "Pretendard-Medium", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func semiBold(size: CGFloat) -> UIFont? {
        return UIFont(name: "Pretendard-SemiBold", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func bold(size: CGFloat) -> UIFont? {
        return UIFont(name: "Pretendard-Bold", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func extraBold(size: CGFloat) -> UIFont? {
        return UIFont(name: "Pretendard-ExtraBold", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func black(size: CGFloat) -> UIFont? {
        return UIFont(name: "Pretendard-Black", size: size) ?? .systemFont(ofSize: size)
    }
}
