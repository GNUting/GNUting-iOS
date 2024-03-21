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
    func showAlert(message: String){
        let alertController = UIAlertController(title: "오류 발생", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .cancel))
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    func errorHandling(response: DefaultResponse?) {
        if response?.isSuccess == false{
            if response?.code != "BOARD4003"{
                self.showAlert(message: "\(response?.message ?? "재접속 또는 로그아웃후 다시 시도하세요.") \n 지속된 오류 발생시 고객센터로 문의 해주세요. ")
            }
        }
    }
}
