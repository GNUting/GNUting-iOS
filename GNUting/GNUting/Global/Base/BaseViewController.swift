//
//  BaseViewController.swift
//  GNUting
//
//  Created by 원동진 on 5/5/24.
//

import UIKit

class BaseViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        swipeRecognizer()
        hideKeyboardWhenTappedAround()
        setNetworkMonitor()
    }
    func setBackgroundColor() {
        view.backgroundColor = .white
    }
    func setNetworkMonitor() {
        if !NetworkMonitor.shared.isConnected {
            self.showAlert(message: "네트워크 신호가 약합니다. 네트워크를 연결해주세요.")
        }
    }
}
