//
//  ImageChaheManager.swift
//  GNUting
//
//  Created by 원동진 on 5/14/24.
//


import UIKit
class ImageCacheManager {
    static let shared = NSCache<NSString,UIImage>()
    private init() {}
}
