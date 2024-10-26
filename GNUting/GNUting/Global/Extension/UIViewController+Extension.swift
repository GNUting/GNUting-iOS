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
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Pretendard.medium(size: 18) ?? .boldSystemFont(ofSize: 18)]
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
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:  Pretendard.semiBold(size: 18) ?? .systemFont(ofSize: 18)]
    }
    func setImageFromStringURL(stringURL: String?,completion: @escaping(UIImage) -> Void){
        
        if let url = URL(string: stringURL ?? "") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let imageData = data else { return }
                guard let image = UIImage(data: imageData) else { return }
                completion(image)
            }.resume()
        } else {
            guard let image = UIImage(named: "photoImg") else { return }
            completion(image)
        }
    }
    
 
    func errorHandling(response: DefaultResponse?) {
        if response?.isSuccess == false{
            if response?.code != "BOARD4003"{
                self.showAlert(message: "\(response?.message ?? "지속된 오류 발생시 고객센터로 문의 해주세요.")")
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
   
    func showAlert(title: String = "", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .cancel))
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    
    
    func showAlertNavigationBack(title: String = "", message: String, actionTitle: String = "확인", backType: NavigationType) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: actionTitle, style: .default,handler: { _ in
            switch backType {
            case .pop:
                self.popButtonTap()
            case .dismiss:
                self.tapDissmisButton()
            }
            
        }))
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    
    func setRootViewControllerLoginVC() {
        let alertController = UIAlertController(title: "", message: "로그인을 다시 시도해주세요.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default,handler: { _ in
            self.changeRootViewController(viewController: LoginVC())
        }))
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
            
        }
    }
    
    func presentViewController(viewController: UIViewController, modalPresentationStyle: UIModalPresentationStyle = .pageSheet) {
        let navigationVC = UINavigationController.init(rootViewController: viewController)
        navigationVC.modalPresentationStyle = modalPresentationStyle
        
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
    func pushViewController(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @objc func tapWriteTextButton(){
        pushViewController(viewController: WriteDateBoardVC())
    }
    
    func swipeRecognizer() {
        let swifpeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_ :)))
        swifpeRight.direction = .right
        self.view.addGestureRecognizer(swifpeRight)
    }
    @objc func respondToSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .right{
            self.navigationController?.popViewController(animated: true)
        }
    }


    func setKeyboardObserver() { // 옵저버 등록
           NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       }

       func removeKeyboardObserver() { // 옵저버 해제
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
       }
    func instagramOpen() {
        guard let url = URL(string: "https://www.instagram.com/gnu_ting/p/C5bIzh2yIe5/?img_index=1"), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    @objc func keyboardWillShow(_ sender: Notification) {
        // keyboardFrame : 현재 동작하고 있는 이벤트에서 키보드의 frame을 전달
        // currentTextField : UIResponder.currentResponder로부터 현재 응답을 받고 있는 UITextField를 확인
        guard let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue, let currentTextField = UIResponder.currentResponder as? UITextField else { return }

        // keyboardYTop : 키보드 상단의 y값
        let keyboardYTop = keyboardFrame.cgRectValue.origin.y
        // convertedTextFieldFrame : 현재 선택한 textField의 frame을 해당 텍스트 필드의 superview에서 view cooridnate system으로 변환
        let convertedTextFieldFrame = view.convert(currentTextField.frame, from : currentTextField.superview)
        // textFieldYBottom : 텍스트필드 하단의 y값 = 텍스트필드의 y값(=y축 위치) + 텍스트필드의 높이
        let textFieldYBottom = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height
        
        // textField 하단이 키보드 상단보다 높을 때 view의 높이를 조정
        if textFieldYBottom > keyboardYTop {
            let textFieldYTop = convertedTextFieldFrame.origin.y
            let properTextFieldHeight = textFieldYTop - keyboardYTop / 1.3
            view.frame.origin.y = CGFloat(-properTextFieldHeight)
        }
    }
    @objc func keyboardWillHide(_ sender: Notification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
  
    func expirationRefreshtoken() { // 리프레쉬 토큰 만료시 불러올 함수
        UserDefaultsManager.shared.setLogout()
        setRootViewControllerLoginVC()
    }
    @objc func expirationRefreshToken() {
        NotificationCenter.default.removeObserver(self, name: .expirationRefreshToken, object: nil)
        self.expirationRefreshtoken()
    }
   
    func changeRootViewController(viewController: UIViewController) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            window.rootViewController = UINavigationController.init(rootViewController: viewController)
        }
    }
    
    func setAttributedText(for label: UILabel, text: String, highlightText: String, highlightColor: UIColor) {
        let range = (text as NSString).range(of: highlightText)
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttribute(.foregroundColor, value: highlightColor, range: range)
        label.attributedText = attributedString
    }
    
    func setTapGestureView(view: UIView, action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: self, action: action)
        
        view.addGestureRecognizer(tapGesture)
    }
}
