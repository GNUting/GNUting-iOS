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
}
