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
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: Pretendard.Medium.rawValue, size: 18)!]
    }
    func setNavigationBarSignUpProcess(imageName: String){
        let backButton = BackButton()
        backButton.addTarget(self, action: #selector(popButtonTap), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        let image = UIImage(named: imageName)
        self.navigationItem.titleView = UIImageView(image: image)
    }
    func setNavigationBarPresentType(title: String) {
        let dismissButton = DismissButton()
        dismissButton.addTarget(self, action: #selector(tapDissmisButton), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: dismissButton)
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
            guard let image = UIImage(named: "photoImg") else { return }
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
                self.showAlert(message: "\(response?.message ?? "다시 시도 해보세요.") \n 지속된 오류 발생시 고객센터로 문의 해주세요. ")
            }
        }
    }
    func errorHandlingLogin(response: LoginSuccessResponse?) {
        if response?.isSuccess == false{
            if response?.code != "BOARD4003"{
                self.showAlert(message: "\(response?.message ?? "지속된 오류 발생시 고객센터로 문의 해주세요.")")
            }
        }
    }
  
    func successHandling(message: String) {
        let alertController = UIAlertController(title: "성공", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .cancel))
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    func successHandlingPopAction(message: String) {
        let alertController = UIAlertController(title: "성공", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default,handler: { _ in
            self.popButtonTap()
        }))
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    func presentFullScreenVC(viewController: UIViewController) {
        let navigationVC = UINavigationController.init(rootViewController: viewController)
        navigationVC.modalPresentationStyle = .fullScreen
        self.present(navigationVC, animated: true)
    }
    func hideKeyboardWhenTappedAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func pushViewContoller(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @objc func tapWriteTextButton(){
        pushViewContoller(viewController: WriteDateBoardVC())
    }
    func instagramOpen() {
        guard let url = URL(string: "https://www.instagram.com/gnu_ting?igsh=MXh1anNvY2N6cnhv"), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}
