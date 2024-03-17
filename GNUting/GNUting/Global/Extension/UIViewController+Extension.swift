//
//  UIViewController+Extension.swift
//  GNUting
//
//  Created by 원동진 on 2024/01/24.
//

import UIKit


extension UIViewController{

    @objc func popButtonTap(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func tapDissmisButton(){
        dismiss(animated: true)
    }
    
    func setNavigationBar(title: String) {
        let backButton = BackButton()
        backButton.addTarget(self, action: #selector(popButtonTap), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.title = title
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: Pretendard.SemiBold.rawValue, size: 18)!]
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
