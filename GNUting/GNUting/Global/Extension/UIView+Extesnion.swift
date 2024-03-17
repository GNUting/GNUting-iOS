//
//  UIView+Extesnion.swift
//  GNUting
//
//  Created by 원동진 on 2024/01/23.
//

import UIKit


extension UIView{
    func addSubViews(_ views : [UIView]){
        _ = views.map{self.addSubview($0)}
    }
    func setImageFromStringURL(stringURL: String?,completion: @escaping(UIImage) -> Void){
        if let url = URL(string: stringURL ?? "") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let imageData = data else { return }
                guard let image = UIImage(data: imageData) else { return }
                completion(image)
            }.resume()
        }else {
            guard let image = UIImage(named: "ProfileImg") else { return }
            completion(image)
        }
    }
}
