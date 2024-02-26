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
}
